Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZGUBre (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 21:47:34 -0400
Subject: Re: [PATCH] cfg80211: avoid setting default_key if add_key fails
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248086067.4204.6.camel@johannes.local>
References: <1248077577-7295-1-git-send-email-yi.zhu@intel.com>
	 <1248086067.4204.6.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 09:47:33 +0800
Message-Id: <1248140853.3747.39.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-20 at 18:34 +0800, Johannes Berg wrote:
> On Mon, 2009-07-20 at 16:12 +0800, Zhu Yi wrote:
> > In cfg80211_upload_connect_keys(), we call add_key, set_default_key
> > and set_default_mgmt_key (if applicable) one by one. If one of these
> > operations fails, we should stop calling the following functions.
> > Because if the key is not added successfully, we should not set it as
> > default key anyway.
> 
> Should we even disconnect again in that case?

Yeah, if one key setting is failed, it might not be worth trying others.
This is true for iwmc3200wifi. But I cannot speak for other drivers. How
about merge this patch first? This is clearly a bug because the firmware
confused when it is told to set a key as default but never existed.

Thanks,
-yi

> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > ---
> >  net/wireless/util.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/wireless/util.c b/net/wireless/util.c
> > index 4bab380..ba387d8 100644
> > --- a/net/wireless/util.c
> > +++ b/net/wireless/util.c
> > @@ -546,13 +546,17 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
> >  		if (!wdev->connect_keys->params[i].cipher)
> >  			continue;
> >  		if (rdev->ops->add_key(wdev->wiphy, dev, i, NULL,
> > -					&wdev->connect_keys->params[i]))
> > +					&wdev->connect_keys->params[i])) {
> >  			printk(KERN_ERR "%s: failed to set key %d\n",
> >  				dev->name, i);
> > +			continue;
> > +		}
> >  		if (wdev->connect_keys->def == i)
> > -			if (rdev->ops->set_default_key(wdev->wiphy, dev, i))
> > +			if (rdev->ops->set_default_key(wdev->wiphy, dev, i)) {
> >  				printk(KERN_ERR "%s: failed to set defkey %d\n",
> >  					dev->name, i);
> > +				continue;
> > +			}
> >  		if (wdev->connect_keys->defmgmt == i)
> >  			if (rdev->ops->set_default_mgmt_key(wdev->wiphy, dev, i))
> >  				printk(KERN_ERR "%s: failed to set mgtdef %d\n",

