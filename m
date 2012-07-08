Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GHLLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 07:11:34 -0400
Message-ID: <1341745890.4987.6.camel@jlt3.sipsolutions.net> (sfid-20120708_131137_452912_05B20AFA)
Subject: Re: [PATCH] Fix oops when set_monitor_enabled() not defined in the
 struct cfg80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Sun, 08 Jul 2012 13:11:30 +0200
In-Reply-To: <1341745690-12574-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341745690-12574-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 14:08 +0300, Vladimir Kondratiev wrote:
> Quick fix for method being invoked without checking its existence
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  net/wireless/core.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index eb60410..e42a97b 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -774,8 +774,9 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
>  
>  	has_monitors_only_new = cfg80211_has_monitors_only(rdev);
>  	if (has_monitors_only_new != has_monitors_only_old) {
> -		rdev->ops->set_monitor_enabled(&rdev->wiphy,
> -					       has_monitors_only_new);
> +		if (rdev->ops->set_monitor_enabled)
> +			rdev->ops->set_monitor_enabled(&rdev->wiphy,
> +						       has_monitors_only_new);

Oh, good catch, applied

johannes

