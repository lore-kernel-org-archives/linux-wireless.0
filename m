Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39835 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYIJGT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 02:19:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v6] New regulatory infrastructure for cfg80211 and drivers
Date: Tue, 9 Sep 2008 23:19:47 -0700
Message-ID: <1221027589-19203-1-git-send-email-lrodriguez@atheros.com> (sfid-20080910_082000_331016_CF4EFAA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds the new regulatory infrastructure for
cfg80211. Since it has not been merged yet and there were
a few more pending comments I've taken the time to address them
but also do one *big* review over this and scrubbed it a bit,
enhanced documentation even more and even tested corner cases
I wasn't considering yet.

The more important changes:

 * New Documentation/networking/regulatory.txt
   This provides driver developers with examples of how to use this
   new infrastructure.
 * Actually made use of old static regdomains via
   CONFIG_WIRELESS_OLD_REGULATORY, and addressed a few updates in the
   regulatory code path for it. Also if you enable this option we
   disable the use of a world regulatory domain as it becomes pointless.
 * Use bool
 * Instead of REGDOM_SET_BY_80211D use REGDOM_SET_BY_COUNTRY_IE
 * Allow drivers to use REG_RULE() macro helper should they need it.
   Also fix REG_RULE() by putting values in parenthesis, this lets you
   pass values such as 2412+20.
 * Our reg_rule now has _khz suffix to clarify its not the usual MHz
   we're used to dealing with in the wireless code.
 * If the *built* regulatory domain supplied by driver is unknown
   have the driver set the alpha2 to "99" so we can treat it as such
   in the regulatory code
 * removed cfg80211_reg_mutex, turns out its existance was just a
   waste of electrons as we can easily just lock over cfg80211_drv_mutex
   as we end up needing to lock over it anyway when we update regulatory
   domains. This made it possible to simplify the code and makes, it should
   be a lot easier to follow now.
 * __regulatory_hint() no longer calls set_regdom() in the case where
   a built regulatory domain was passed, instead we now leave that to the
   caller. Right now this means regulatory_hint() now calls set_regdom()
   when a built regulatory domain is passed. It is expected Country IE
   parsing code will do something similar in the future.

The only thing I'm not too proud of is how clumsy ignore_request() 
looks but we can fix this as we go.

  Luis
