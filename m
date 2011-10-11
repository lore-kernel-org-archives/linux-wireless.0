Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34834 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab1JKR7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 13:59:18 -0400
Received: by gyg10 with SMTP id 10so6790986gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 10:59:18 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH v2 0/7] wireless: add DFS master support
Date: Tue, 11 Oct 2011 10:58:57 -0700
Message-Id: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111011_195922_693746_253A8A0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is v2 of my DFS master support patches. The v2 addresses only 2 bits
on the wireless-regdb and leaves open what we do for the rest of the 6 bits.
The nl80211 interface remains the same but I also fixed a typo I had made in
my previous patches for the dfs region enums. I also throw in the fix for CRDA
for the odd behaviour observed on the last pad byte.

This set of 7 patches adds DFS master support to the Linux wireless subsystem.
I've reviewed future possible changes to DFS master regions and it seems that
we are not going to be having multiple DFS regions for one country, instead
we'll always have one DFS region for one country.

The changes here are spread out throughout wireless-regdb, crda the kernel and
lastly iw. The changes made allow for older verions of CRDA to work with new
wireless-regdb files with DFS region support. If you want DFS master region
support you'll need to upgrade your CRDA, your kernel and then hope someone
implements DFS master support for your respective driver.

This patch series does not have specific driver changes, although some seem to
be backing in the oven right now.

Luis R. Rodriguez (6):
  wireless-regdb: Add master DFS region support
  wireless-regdb: add FCC as the DFS region for US
  crda: fix null string assumption for alpha2
  crda: add support to send DFS master region
  cfg80211: process regulatory DFS region for countries
  cfg80211: pass DFS region to drivers through reg_notifier()
  iw: add DFS region parsing support

 db.txt     |    2 +-
 db2bin.py  |    2 +-
 dbparse.py |   25 ++++++++++++++++++++-----
 3 files changed, 22 insertions(+), 7 deletions(-)

 crda.c    |    5 +++--
 nl80211.h |   21 +++++++++++++++++++++
 regdb.h   |    3 ++-
 reglib.h  |   13 -------------
 4 files changed, 26 insertions(+), 16 deletions(-)

 include/linux/nl80211.h  |   21 +++++++++++++++++++++
 include/net/regulatory.h |    6 ++++++
 net/wireless/nl80211.c   |   15 +++++++++++++++
 net/wireless/reg.c       |   39 +++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h       |    1 +
 5 files changed, 82 insertions(+), 0 deletions(-)

 nl80211.h |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 reg.c     |   31 +++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 0 deletions(-)

-- 
1.7.4.15.g7811d

