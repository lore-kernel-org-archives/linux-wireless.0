Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab3GKJ42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 05:56:28 -0400
Message-ID: <1373536580.8201.9.camel@jlt4.sipsolutions.net> (sfid-20130711_115630_978021_AF4CDB6E)
Subject: Re: [PATCH] nl80211: fix the setting of RSSI threshold value for
 mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Thu, 11 Jul 2013 11:56:20 +0200
In-Reply-To: <1373534615-17270-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130711_113049_434357_3B7B1B57)
References: <1373534615-17270-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130711_113049_434357_3B7B1B57)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 17:23 +0800, Chun-Yeow Yeoh wrote:
> RSSI threshold value used for mesh peering should be in
> negative value. After range checks to mesh parameters is
> introduced, this is not allowed. Fix this.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/wireless/nl80211.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index a9444cd..e6164ab 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -4803,9 +4803,9 @@ do {									    \
>  	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding, 0, 1,
>  				  mask, NL80211_MESHCONF_FORWARDING,
>  				  nla_get_u8);
> -	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, 1, 255,
> -				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
> -				  nla_get_u32);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold,
> +				  0x80000000, 0xFFFFFFFF, mask,
> +				  NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);

Maybe use nla_get_s32() instead?

johannes

