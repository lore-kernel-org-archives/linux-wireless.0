Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2LTNHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 08:07:32 -0500
Message-ID: <1356008873.10029.13.camel@jlt4.sipsolutions.net> (sfid-20121220_140735_848841_13A63502)
Subject: Re: [RFC] mac80211: Fix MAX MTU Calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya <chaitanyatk@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Dec 2012 14:07:53 +0100
In-Reply-To: <50D307FD.9010508@posedge.com>
References: <201212201236.qBKCakFZ011657@chaitanya-desktop>
	 <50D307FD.9010508@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 18:13 +0530, Chaitanya wrote:
> Fix the MTU calculation, we should check for data_len+ mesh hdr len
> and shouldn't include any header lengths.
> 
> ToDo: Get the MAX_DATA_LEN based on driver's AMSDU capability.
> 
> Signed-off-by: T Krishna Chaitanya <chaitanyatk@posedge.com>
> 
> ---
> 
>  net/mac80211/iface.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 54fb7f9..da74ef9 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -214,8 +214,23 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
>  
>  	/* FIX: what would be proper limits for MTU?
>  	 * This interface uses 802.3 frames. */
> +	/* Fixed: MTU needn't worry about headers*/
> +
> +	/* 802.11-2012: 8.2.3: The maximum frame body size is determined by
> +	1. The maximum MSDU size (2304 octets),
> +	2. plus the length of the Mesh Control field (6, 12, or 18 octets)
> +		if present,
> +	3. the maximum unencrypted MMPDU size excluding the MAC header and
> +		FCS (2304 octets) or
> +	4. the maximum A- MSDU size (3839 or 7935 octets),
> +		plus any overhead from security encapsulation.
> +	Note1: IEEE80211_MAX_DATA_LEN doesnt include any headers (2304),
> +		so it can be used directly+ Mesh HDR Len
> +	Note2: In Other places (like skb_alloc) its handled properly.
> +	 */
> +

ok so the comment style is wrong, you shouldn't list changelog-type
things in comments ("Fixed: ...") etc.

I also don't understand why we should add the mesh length? It seems that
this is really just the maximum MSDU size, i.e. 2304 octets.

johannes

