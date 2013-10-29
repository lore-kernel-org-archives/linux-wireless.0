Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:26905 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3J2AHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 20:07:30 -0400
Message-ID: <1383005246.3779.61.camel@bwh-desktop.uk.level5networks.com> (sfid-20131029_010740_690137_9601FF6A)
Subject: Re: [PATCH NEXT] rtlwifi: Fix endian error in extracting packet type
From: Ben Hutchings <bhutchings@solarflare.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Mark Cave-Ayland" <mark.cave-ayland@ilande.co.uk>,
	<netdev@vger.kernel.org>, Stable <stable@vger.kernel.org>
Date: Tue, 29 Oct 2013 00:07:26 +0000
In-Reply-To: <1383002903-8746-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1383002903-8746-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 18:28 -0500, Larry Finger wrote:
> From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> 
> All of the rtlwifi drivers have an error in the routine that tests if
> the received data is "special". The 16-bit quantity is big-endian, but
> was being extracted in native CPU mode. One of the effects of this bug
> is to inhibit association under some conditions.
> 
> A statement that would have made the code correct had been changed to
> a comment. Rather than just reinstating that code, the fix here passes
> sparse tests.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> Cc: Stable <stable@vger.kernel.org> [2.6.38+]
> ---
>  drivers/net/wireless/rtlwifi/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
> index 9a78e3d..1efde7f 100644
> --- a/drivers/net/wireless/rtlwifi/base.c
> +++ b/drivers/net/wireless/rtlwifi/base.c
> @@ -1077,8 +1077,8 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
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

This crazy function also says that *all* IPv6 frames are special, which
apparently means that on TX they should get sent at the lowest possible
bit rate.  So I think this is going to cause a regression for IPv6
throughput unless you remove that case.

The DHCP case is also not validating IP and UDP header lengths against
the packet length, though this may be harmless in practice.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

