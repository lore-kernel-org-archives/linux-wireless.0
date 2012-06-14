Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2FNS5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 14:57:14 -0400
Message-ID: <1339700228.9786.11.camel@jlt3.sipsolutions.net> (sfid-20120614_205748_629041_5C921042)
Subject: Re: [PATCH] mac80211: fix the assignment of mesh element TTL
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Thu, 14 Jun 2012 20:57:08 +0200
In-Reply-To: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120614_182507_952715_CCD89317)
References: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120614_182507_952715_CCD89317)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-15 at 00:23 +0800, Chun-Yeow Yeoh wrote:
> This patch fixes the wrong assignment of mesh element TTL.

Since I haven't pushed to John yet, should I rebase and merge this with
one of the previous patches?

johannes

> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/cfg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 85ac364..43eb8d9 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1529,7 +1529,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
>  	if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
>  		conf->dot11MeshTTL = nconf->dot11MeshTTL;
>  	if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
> -		conf->dot11MeshTTL = nconf->element_ttl;
> +		conf->element_ttl = nconf->element_ttl;
>  	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
>  		conf->auto_open_plinks = nconf->auto_open_plinks;
>  	if (_chg_mesh_attr(NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR, mask))


