Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIIrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:47:01 -0400
Message-ID: <1339231619.4539.32.camel@jlt3.sipsolutions.net> (sfid-20120609_104706_623046_299144F9)
Subject: Re: [PATCH v2 4/4] mac80211: invoke the timer only with correct
 dot11MeshHWMPRootMode value
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:46:59 +0200
In-Reply-To: <1339043963-2043-5-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063956_923873_CB0AB0B8)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-5-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120607_063956_923873_CB0AB0B8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:39 +0800, Chun-Yeow Yeoh wrote:
> mesh_path_root_timer is invoked once the dot11MeshHWMPRootMode is larger than 1. This patch
> also adds the backward compatible to the previous setting on dot11MeshHWMPRootMode. If the
> user configures as follow, it will still trigger the proactive RANN with Gate Announcement.
> 
> iw mesh0 set mesh_param mesh_hwmp_rootmode 1
> iw mesh0 set mesh_param mesh_gate_announcements 1
> 
> similar to the following setting:
> 
> iw mesh0 set mesh_param mesh_hwmp_rootmode 4
> iw mesh0 set mesh_param mesh_gate_announcements 1
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
> v2: use constant for dot11MeshHWMPRootMode assignment (Johannes)
> 
>  net/mac80211/cfg.c  |    4 ++--
>  net/mac80211/mesh.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 38e743f..85c6601 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1564,8 +1564,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
>  		 * announcements, so require this ifmsh to also be a root node
>  		 * */
>  		if (nconf->dot11MeshGateAnnouncementProtocol &&
> -		    !conf->dot11MeshHWMPRootMode) {
> -			conf->dot11MeshHWMPRootMode = 1;
> +		    !(conf->dot11MeshHWMPRootMode > 1)) {
> +			conf->dot11MeshHWMPRootMode = IEEE80211_PROACTIVE_RANN;

so, humm, there's still the same constant here.


> -	if (ifmsh->mshcfg.dot11MeshHWMPRootMode)
> +	if (ifmsh->mshcfg.dot11MeshHWMPRootMode > 1)

and here.


johannes

