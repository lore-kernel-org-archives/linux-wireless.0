Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:33325 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab0DVIER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 04:04:17 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1O4rOQ-00020p-S1
	for linux-wireless@vger.kernel.org; Thu, 22 Apr 2010 10:04:14 +0200
Received: from proxyext.iabg.de ([proxyext.iabg.de])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 10:04:14 +0200
Received: from pommnitz by proxyext.iabg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 10:04:14 +0200
To: linux-wireless@vger.kernel.org
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [RFC] mac80211: sample survey implementation for mac80211 &amp; hwsim
Date: Thu, 22 Apr 2010 08:04:07 +0000 (UTC)
Message-ID: <loom.20100422T100127-458@post.gmane.org>
References: <201004191023.57987.holgerschurig@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <holgerschurig@...> writes:

> 
> +static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
> +				 int idx, struct survey_info *survey)
> +{
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +
> +	if (!local->ops->get_survey)
> +		return -EOPNOTSUPP;

The check for the function is duplicated in drv_get_survey. I think the
wrapper should be called unconditionally.

> +
> +	return drv_get_survey(local, idx, survey);
> +}
> +


