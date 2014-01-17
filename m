Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49744 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQIcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 03:32:16 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so1587307eak.39
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:32:14 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 0/5] Regulatory, change maximum bandwidth checking
Date: Fri, 17 Jan 2014 09:31:59 +0100
Message-Id: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093219_814883_F5FA07B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce new way to calculate maximum available bandwidth.
Before we get this form regulatory rule.
Currently we calculate this from contiguous rules and base
on such calculation we set correct channel BW flags (40, 80, 160MHz).

In case someone will need to use bandwidth defined in regulatory
database only I also introduce new regulatory rule flag STRICT-BW.
In such case maximum bandwidth from regulatory database will be
used.

Tested with hwsim.

Janusz Dziedzic (5):
  cfg80211: don't check regulatory bandwidth
  cfg80211: add helper reg_get_regdomain() function
  cfg80211: fix maximum bandwidth calculation
  cfg80211: introduce strict bandwidth regulatory flag
  cfg80211: parse STRICT-BW flag for insternal regdb option

 include/uapi/linux/nl80211.h |    2 +
 net/wireless/genregdb.awk    |    2 +
 net/wireless/reg.c           |  107 ++++++++++++++++++++++++++++++++++++------
 3 files changed, 96 insertions(+), 15 deletions(-)

-- 
1.7.9.5

