Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38221 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbaEMMAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 08:00:02 -0400
Message-ID: <1399982392.4137.10.camel@jlt4.sipsolutions.net> (sfid-20140513_140013_627052_7A35910D)
Subject: Re: [PATCH] mac80211: fix suspend vs. association race
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 13 May 2014 13:59:52 +0200
In-Reply-To: <1399974849-12353-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399974849-12353-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-13 at 12:54 +0300, Emmanuel Grumbach wrote:
> If the association is in progress while we suspend, the
> stack will be in a messed up state. Clean it before we
> suspend.
> 
> This patch completes Johannes's patch:
> 
> 1a1cb744de160ee70086a77afff605bbc275d291
> Author: Johannes Berg <johannes.berg@intel.com>
> 
>     mac80211: fix suspend vs. authentication race
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  net/mac80211/mlme.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 139005d..5e4f7ea 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3600,7 +3600,7 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
>  
>  	sdata_lock(sdata);
>  
> -	if (ifmgd->auth_data) {
> +	if (ifmgd->auth_data || ifmgd->assoc_data) {

This can crash if auth_data is NULL (but we use it to build the deauth)
- I'm rolling in a fix for that.

johannes

