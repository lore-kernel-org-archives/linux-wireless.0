Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35531 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbbJFNm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 09:42:56 -0400
Message-ID: <1444138971.1976.0.camel@sipsolutions.net> (sfid-20151006_154300_917862_12BA573B)
Subject: Re: Deadlock in mac80211 running 3.18.11 + compat-wireless
 2015-03-09
From: Johannes Berg <johannes@sipsolutions.net>
To: projekt-wlan@fem.tu-ilmenau.de, linux-wireless@vger.kernel.org
Date: Tue, 06 Oct 2015 15:42:51 +0200
In-Reply-To: <b2436c41bd887b5970dfa3bd0368d8a7@fami-braun.de>
References: <b2436c41bd887b5970dfa3bd0368d8a7@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 2c158887f1185e04b3763ae346da9f71fcbc4429
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Mar 12 19:28:31 2015 +0100

    mac80211: agg-tx: avoid sending DelBA with sta->lock held
    
    The rate control locking caused a potential deadlock here due to
the
    locks being acquired in different orders, so that change cannot yet
    be applied. However, there's no fundamental reason for this code to
    hold the sta->lock while transmitting frames.
    
    Clearly it's better not to hold the lock for longer periods of
time,
    which can happen here since we call all the way down to the driver.
    Change the code a bit to not hold it while doing that.
    
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

