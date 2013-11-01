Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:60955 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab3KABCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 21:02:54 -0400
Message-ID: <1383267769.1583.8.camel@bwh-desktop.uk.level5networks.com> (sfid-20131101_020258_311102_DC9ADCCF)
Subject: Re: [PATCH NEXT V2] rtlwifi: Fix endian error in extracting packet
 type
From: Ben Hutchings <bhutchings@solarflare.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Mark Cave-Ayland" <mark.cave-ayland@ilande.co.uk>,
	<netdev@vger.kernel.org>, Stable <stable@vger.kernel.org>
Date: Fri, 1 Nov 2013 01:02:49 +0000
In-Reply-To: <1383266638-4813-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1383266638-4813-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-31 at 19:43 -0500, Larry Finger wrote:
> From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> 
> All of the rtlwifi drivers have an error in the routine that tests if
> the data is "special". If it is, the subsequant transmission will be
> at the lowest rate to enhance reliability. The 16-bit quantity is
> big-endian, but was being extracted in native CPU mode. One of the
> effects of this bug is to inhibit association under some conditions
> as the TX rate is too high.
> 
> A statement that would have made the code correct had been changed to
> a comment. Rather than just reinstating that code, the fix here passes
> sparse tests. A side effect of fixing this problem would have been to force
> all IPv6 frames to run at the lowest rate. The test for that frame type
> is removed.
> 
> The original code only checked the lower-order byte of UDP ports for BOOTP
> protocol. That is extended to the full 16-bit source and destination ports.
> 
> One of the local headers contained duplicates of some of the ETH_P_XXX
> definitions. These are deleted.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> Cc: Stable <stable@vger.kernel.org> [2.6.38+]
> ---
> 
> V2 - Addresses comments by Ben Hutchings and Bjorn Mork.
> 
>  drivers/net/wireless/rtlwifi/base.c |   15 ++++++---------
>  drivers/net/wireless/rtlwifi/wifi.h |    6 +-----
>  2 files changed, 7 insertions(+), 14 deletions(-)
> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/base.c
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/base.c
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/base.c
> @@ -1077,17 +1077,17 @@ u8 rtl_is_special_data(struct ieee80211_
>  
>  	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
>  			      SNAP_SIZE + PROTOC_TYPE_SIZE);
> -	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
> -	/*	ether_type = ntohs(ether_type); */
> +	ether_type = be16_to_cpu(*(__be16 *)((u8 *)skb->data + mac_hdr_len +
> +					     SNAP_SIZE));
>  
>  	if (ETH_P_IP == ether_type) {
>  		if (IPPROTO_UDP == ip->protocol) {
>  			struct udphdr *udp = (struct udphdr *)((u8 *) ip +
>  							       (ip->ihl << 2));
> -			if (((((u8 *) udp)[1] == 68) &&
> -			     (((u8 *) udp)[3] == 67)) ||
> -			    ((((u8 *) udp)[1] == 67) &&
> -			     (((u8 *) udp)[3] == 68))) {
> +			if (((((u16 *) udp)[0] == 68) &&
> +			     (((u16 *) udp)[2] == 67)) ||
> +			    ((((u16 *) udp)[0] == 67) &&
> +			     (((u16 *) udp)[2] == 68))) {
[...]

Now you're missing byte-swapping here, and using the wrong offset for
the dest port (4 bytes rather than 2).

If you really think this is necessary then use something like:
			if ((udp->source == htons(68) &&
			     udp->dest == htons(67)) ||
			     ...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

