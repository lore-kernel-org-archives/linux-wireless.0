Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38398 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHDQPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 12:15:38 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <99AFB2EC-AECE-419A-B014-8391E45DF6C4@holtmann.org> (sfid-20080804_181542_204244_354C7612)
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1217853236.4721.32.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v928.1)
Subject: Re: [RFC] cfg80211: add PM hooks
Date: Mon, 4 Aug 2008 18:15:33 +0200
References: <1217853236.4721.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> This should help implement suspend/resume in mac80211, these
> hooks will be run before the device is suspended and after it
> resumes. Therefore, they can touch the hardware as much as
> they want to.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This should help whoever wants to implement suspend/resume for  
> mac80211.
> I don't intend to, at the moment, but I think these hooks should be
> used.
>
> include/net/cfg80211.h |    6 ++++++
> net/wireless/sysfs.c   |   30 ++++++++++++++++++++++++++++++
> 2 files changed, 36 insertions(+)
>
> --- everything.orig/include/net/cfg80211.h	2008-08-04  
> 14:22:39.000000000 +0200
> +++ everything/include/net/cfg80211.h	2008-08-04 14:26:31.000000000  
> +0200
> @@ -285,6 +285,9 @@ struct wiphy;
>  * wireless extensions but this is subject to reevaluation as soon  
> as this
>  * code is used more widely and we have a first user without wext.
>  *
> + * @suspend: wiphy device needs to be suspended
> + * @resume: wiphy device needs to be resumed
> + *
>  * @add_virtual_intf: create a new virtual interface with the given  
> name
>  *
>  * @del_virtual_intf: remove the virtual interface determined by  
> ifindex.
> @@ -320,6 +323,9 @@ struct wiphy;
>  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
>  */
> struct cfg80211_ops {
> +	int	(*suspend)(struct wiphy *wiphy);
> +	int	(*resume)(struct wiphy *wiphy);
> +
> 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
> 				    enum nl80211_iftype type, u32 *flags,
> 				    struct vif_params *params);
> --- everything.orig/net/wireless/sysfs.c	2008-08-04  
> 14:22:39.000000000 +0200
> +++ everything/net/wireless/sysfs.c	2008-08-04 14:31:58.000000000  
> +0200
> @@ -60,6 +60,34 @@ static int wiphy_uevent(struct device *d
> }
> #endif
>
> +static int wiphy_suspend(struct device *dev, pm_message_t state)
> +{
> +	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
> +	int ret = 0;
> +
> +	if (rdev->ops->suspend) {
> +		rtnl_lock();
> +		ret = rdev->ops->suspend(&rdev->wiphy);
> +		rtnl_unlock();
> +	}
> +
> +	return ret;
> +}
> +
> +static int wiphy_resume(struct device *dev)
> +{
> +	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
> +	int ret = 0;
> +
> +	if (rdev->ops->resume) {
> +		rtnl_lock();
> +		ret = rdev->ops->suspend(&rdev->wiphy);
> +		rtnl_unlock();
> +	}
> +
> +	return ret;
> +}
> +
> struct class ieee80211_class = {
> 	.name = "ieee80211",
> 	.owner = THIS_MODULE,
> @@ -68,6 +96,8 @@ struct class ieee80211_class = {
> #ifdef CONFIG_HOTPLUG
> 	.dev_uevent = wiphy_uevent,
> #endif
> +	.suspend = wiphy_suspend,
> +	.resume = wiphy_resume,
> };

this needs to be wrapped into CONFIG_PM, because otherwise the build  
will fail when CONFIG_PM is not enabled.

Regards

Marcel

