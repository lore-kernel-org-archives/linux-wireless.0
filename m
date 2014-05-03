Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaECGPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 02:15:37 -0400
Message-ID: <1399097729.5873.2.camel@dubbel> (sfid-20140503_081547_651891_400C1DE8)
Subject: Re: [PATCH] cfg80211/mac80211: Fix warning on make xmldocs caused
 by cfg80211.h
From: Luciano Coelho <luciano.coelho@intel.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: johannes.berg@intel.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Sat, 03 May 2014 09:15:29 +0300
In-Reply-To: <1399041597-27409-2-git-send-email-standby24x7@gmail.com>
References: <1399041597-27409-1-git-send-email-standby24x7@gmail.com>
	 <1399041597-27409-2-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2014-05-02 at 23:39 +0900, Masanari Iida wrote:
> Following error messages caused by wrong description.
> 
> Warning(include/net/cfg80211.h:461): No description found
> for parameter 'nl80211_iftype'
> 
> Change "iftype" to "nl80211_iftype" fix the errors.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  include/net/cfg80211.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 7eae46c..695c562 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -452,7 +452,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
>   * cfg80211_chandef_dfs_required - checks if radar detection is required
>   * @wiphy: the wiphy to validate against
>   * @chandef: the channel definition to check
> - * @iftype: the interface type as specified in &enum nl80211_iftype
> + * @nl80211_iftype: the interface type as specified in &enum nl80211_iftype
>   * Returns:
>   *	1 if radar detection is required, 0 if it is not, < 0 on error
>   */

A better way to fix this would be to add "iftype" to the function
prototype, since we don't usually use nameless arguments:

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 43c674e..f9e7373 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -458,7 +458,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
  */
 int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
                                  const struct cfg80211_chan_def *chandef,
-                                 enum nl80211_iftype);
+                                 enum nl80211_iftype iftype);
 
 /**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel

--
Cheers,
Luca.


