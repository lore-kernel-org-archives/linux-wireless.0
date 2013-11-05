Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33692 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3KERRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:13 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so2828524bkh.20
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:11 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 00/19] cfg80211: regulatory updates
Date: Tue,  5 Nov 2013 09:17:58 -0800
Message-Id: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181718_595092_EDFAA2DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series deals with 3 things:

  a) Three enhancements for regulatory
  b) Make reg_process_hint() easier to follow
  c) Make set_regdom() easier to follow

The enhancements in a) are to help ensure a combination of
custom and strict regulatory settings are respected but also
address original design consideations but that we had overlooked.
The third enhancement helps avoid possible abuse on memory
pressure by userspace by invalidating requests early.

The work on b) and c) come from the realization that while the
existing code works its really hard to follow as you have to
consider two different state machine consideration at once.
I've decided to create a compromise on making the code easier
to follow by increasing code size by splitting up each case
into its own path, this lets the reader only focus on each
individual type of request individually. Code is still shared
when possible.

I've tested all these changes with mac80211_hwsim regtest for
all regtetest options before and after applying these changes.
I'm pretty confident on these changes, I suspect this actually
also ends up addressing a few corner cases previously not
covered.

Luis R. Rodriguez (19):
  cfg80211: enforce disabling channels by custom or strict settings
  cfg80211: force WIPHY_FLAG_CUSTOM_REGULATORY on
    wiphy_apply_custom_regulatory()
  cfg80211: check regulatory request alpha2 early
  cfg80211: remove second argument from reg_process_hint()
  cfg80211: processing core regulatory hints on its own
  cfg80211: process user regulatory requests on its own
  cfg80211: process driver regulatory requests on its own
  cfg80211: process country IE regulatory requests on their own
  cfg80211: process non country IE conflicting first
  cfg80211: add helper for kfree'ing last_request
  cfg80211: add helper for kfree'ing and assigning last_request
  cfg80211: add helper for calling CRDA
  cfg80211: allow only the core to request to update the world regdom
  cfg80211: move core reg_notfier() check to source
  cfg80211: pass the last_request to __set_regdom()
  cfg80211: set core regulatory updates on its own
  cfg80211: set user regulatory updates on its own
  cfg80211: set driver regulatory updates on its own
  cfg80211: rename __set_regdom() to reg_set_rd_country_ie()

 include/net/cfg80211.h |   7 +-
 net/wireless/nl80211.c |   3 +
 net/wireless/reg.c     | 681 ++++++++++++++++++++++++++++++-------------------
 net/wireless/reg.h     |   1 +
 4 files changed, 422 insertions(+), 270 deletions(-)

-- 
1.8.4.rc3

