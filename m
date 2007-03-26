Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42645
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXCZL2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 07:28:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
Date: Mon, 26 Mar 2007 13:28:27 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>, Daniel Drake <dsd@gentoo.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
References: <20070325231817.9C5887B409F@zog.reactivated.net> <1174903199.1536.4.camel@johannes.berg> <46079CEC.5030207@warmcat.com>
In-Reply-To: <46079CEC.5030207@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703261328.28156.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 March 2007 12:14, Andy Green wrote:
> Johannes Berg wrote:
> 
> > bcm43xx doesn't tell you when the CRC failed, nor does it tell you when
> > the PLCP CRC failed (if you want to see those frames). Hence, we'd have
> > to recheck the CRC(s).
> 
> FWIW I can definitely use the broken frames despite the overhead and 
> would welcome being able to get them via a config option.


We currently have two module parameters in bcm43xx-mac80211 for this:

static int modparam_mon_keep_bad;
module_param_named(mon_keep_bad, modparam_mon_keep_bad, int, 0444);
MODULE_PARM_DESC(mon_keep_bad, "Keep bad frames in monitor mode");

static int modparam_mon_keep_badplcp;
module_param_named(mon_keep_badplcp, modparam_mon_keep_bad, int, 0444);
MODULE_PARM_DESC(mon_keep_badplcp, "Keep frames with bad PLCP in monitor mode");

Of course, it might be desired to have that knob in mac80211 and cfg80211, somehow.

-- 
Greetings Michael.
