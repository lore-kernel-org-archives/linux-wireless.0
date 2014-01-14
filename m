Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35614 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaANR3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:29:47 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so4102269eae.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:29:46 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 0/5] Implement DFS CAC time as regulatory param
Date: Tue, 14 Jan 2014 18:29:25 +0100
Message-Id: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182950_692362_02657532)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement DFS CAC time inside regulatory.
Currently tested with internal regdb.

Changed way we check rule is correct in first patch - check
more rules if they are continous.
Added parsing DFS CAC to genregdb.awk script. 
Last patch is only an example I tested for PL regd.
Implemented also iw patches for iw get regd/iw list

CRDA/wireless-regdb - this is still missing.
Please review.

Janusz Dziedzic (5):
  cfg80211: regulatory rules, fix bw checking
  cfg80211: regulatory, introduce DFS CAC time
  cfg80211: parse DFS CAC time for internal regdb option
  nl80211: add DFS CAC time option
  cfg80211: setup CAC time in db.txt for PL

 include/net/cfg80211.h       |    2 +
 include/net/regulatory.h     |   12 +++++
 include/uapi/linux/nl80211.h |    5 +++
 net/wireless/db.txt          |    6 ++-
 net/wireless/genregdb.awk    |    8 +++-
 net/wireless/nl80211.c       |   13 +++++-
 net/wireless/reg.c           |  100 ++++++++++++++++++++++++++++++++++++------
 7 files changed, 128 insertions(+), 18 deletions(-)

-- 
1.7.9.5

