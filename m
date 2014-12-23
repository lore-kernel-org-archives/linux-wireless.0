Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38916 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbaLWOxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 09:53:31 -0500
Message-ID: <1419346405.6091.6.camel@sipsolutions.net> (sfid-20141223_155334_784728_B2EDDDCC)
Subject: Re: [PATCH] cfg80211: check for carrier state only when offchanel
 CAC supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
	cluo@marvell.com, janusz.dziedzic@tieto.com,
	Arend van Spriel <arend@broadcom.com>
Date: Tue, 23 Dec 2014 15:53:25 +0100
In-Reply-To: <1419365159-6577-1-git-send-email-patila@marvell.com>
References: <1419365159-6577-1-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-24 at 01:35 +0530, Avinash Patil wrote:
> Checking for carrier state during start_radar_detection is needed
> only for devices which support offchannel CAC.
> This patch adds one more condition while checking for carrier state
> to see if offchanel CAC is supported, else we need not check carrier
> state.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> ---
>  include/net/cfg80211.h | 2 ++
>  net/wireless/nl80211.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 4ebb816..1b80302 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2740,6 +2740,7 @@ struct cfg80211_ops {
>   * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
>   * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
>   *	beaconing mode (AP, IBSS, Mesh, ...).
> + * @WIPHY_FLAG_OFFCHAN_CAC: Device supports offchannel CAC.

I think this should be an nl80211 feature flag, so that userspace can
also know whether or not this is supported.

However, we've run out of nl80211 feature flags. Arend is working on
adding more, see here:
http://mid.gmane.org/1418935344-22159-1-git-send-email-arend@broadcom.com
(ignore the 4-way-HS offload bit he's defining)

I'm not sure how to proceed here - in a sense your feature flag is far
less controversial and work-intensive than Arend's (who needs a lot more
than just that patch) so I guess you could pick up his patch, but I
expect him to also have fixed already. He's probably also on vacation
for about the same time though...

johannes

