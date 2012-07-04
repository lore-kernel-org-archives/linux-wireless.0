Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2GDLNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:13:01 -0400
Message-ID: <1341400378.12432.4.camel@jlt3.sipsolutions.net> (sfid-20120704_131306_010478_4A0DA490)
Subject: Re: [PATCH 06/13] cfg80211: track monitor interfaces count
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Date: Wed, 04 Jul 2012 13:12:58 +0200
In-Reply-To: <1340966828-22874-7-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
	 <1340966828-22874-7-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

A few people noticed that these patches cause deadlocks. I think the
reason is that it's not allowed to lock the device here:

>  	case NETDEV_DOWN:
>  		dev_hold(dev);
> +		cfg80211_lock_rdev(rdev);

This causes a deadlock since the interface is set down inside mac80211
when inside a handler from cfg80211 already, or so.

johannes

