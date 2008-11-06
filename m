Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28762 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKFUp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 15:45:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 12:45:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/3] cfg80211/mac80211: Add 802.11d support
Date: Thu, 6 Nov 2008 12:45:24 -0800
Message-ID: <1226004327-10290-1-git-send-email-lrodriguez@atheros.com> (sfid-20081106_214535_923087_8308E06A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK this is a respin of the missing patches taking into consideration
Johannes' comments. I've also added environmental checks now and
also changed the behaviour to always respect the first AP when
using 11d.

I've tested this with iwlagn, and with ath9k (with the beacon
filter enabled), with OLD_REG and without it set and with CRDA
present and without it. I also tested the combo:

iwlagn first, then ath9k
ath9k first, then iwlagn

Users can hint their own country before or after the 11d country IE
is parsed, but nothing more. The only case I think we can add some
more code for later is handling the case where the user gets an 11d
country IE in the US, suspends, flies to the FR and then gets an 11d
country IE there. But we can add that as we go :)

This new series changes the 11d code to mac80211 to only be 7 lines.
All the bulk work is now done in cfg80211 as we pass the country
IE and length to cfg80211 directly.

The only bug I hit was a WARN but this is not related to this code:

http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703

Oh and for the record, checkpatch will complain about the space
usage suggested in my last series but I still went with it.

11dv4/0002-cfg80211-mark-regdomains-with-NL80211_MAX_SUPP_RE.patch has no obvious style problems and is ready for submission.
ERROR: code indent should use tabs where possible
#155: FILE: include/net/wireless.h:389:
+^I^I^I        u8 *country_ie,$

ERROR: code indent should use tabs where possible
#156: FILE: include/net/wireless.h:390:
+^I^I^I        u8 country_ie_len);$


  Luis
