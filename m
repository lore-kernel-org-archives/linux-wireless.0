Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63383 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaBSAKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 19:10:17 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so17438770pbc.12
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 16:10:16 -0800 (PST)
Date: Tue, 18 Feb 2014 16:10:12 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v3 5/6] cfg80211: Enable GO operation on indoor channels
Message-ID: <20140219001010.GE14296@garbanzo.do-not-panic.com> (sfid-20140219_011022_260640_5D0F8D25)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-6-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390818118-27261-6-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 27, 2014 at 12:21:57PM +0200, Ilan Peer wrote:
> Allow GO operation on a channel marked with IEEE80211_CHAN_INDOOR_ONLY
> iff there is a user hint indicating that the platform is operating in
> an indoor environment, i.e., the platform is a printer or media center
> device.
> 
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> ---
>  net/wireless/chan.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 87a9d0e..4ae3cd0 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -611,14 +611,20 @@ EXPORT_SYMBOL(cfg80211_chandef_usable);
>   * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
>   * associated to an AP on the same channel or on the same UNII band
>   * (assuming that the AP is an authorized master).
> + * In addition allow the GO to operate on a channel on which indoor operation is
> + * allowed, iff we are currently operating in an indoor environment.
>   */
>  static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
>  					struct ieee80211_channel *chan)
>  {
>  	struct wireless_dev *wdev_iter;
> +	struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
>  
>  	ASSERT_RTNL();
>  
> +	if (regulatory_ir_allowed(wiphy, chan))
> +		return true;
> +
>  	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
>  		return false;

Looks good.

  Luis
