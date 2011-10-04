Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34933 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab1JDXrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 19:47:53 -0400
Received: by pzk1 with SMTP id 1so2684409pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 16:47:52 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 0/8] wireless: add DFS master support
Date: Tue,  4 Oct 2011 16:47:39 -0700
Message-Id: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111005_014756_976694_CC6C210F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This set of 8 patches adds DFS master support to the Linux wireless subsystem.
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

Luis R. Rodriguez (8):
  wireless-regdb: Add master DFS region support
  wireless-regdb: add FCC as the DFS region for US
  crda: synch up nl80211.h
  crda: add support to send DFS master region
  cfg80211: process regulatory DFS region for countries
  cfg80211: pass DFS region to drivers through reg_notifier()
  iw: synch nl80211.h
  iw: add DFS region parsing support

wireless-regdb:

 db.txt     |    2 +-
 db2bin.py  |    2 +-
 dbparse.py |   25 ++++++++++++++++++++-----
 3 files changed, 22 insertions(+), 7 deletions(-)

crda:

 crda.c    |    1 +
 nl80211.h |   21 +++++++++++++++++++++
 regdb.h   |    3 ++-
 3 files changed, 24 insertions(+), 1 deletions(-)

kernel:

 include/linux/nl80211.h  |   21 +++++++++++++++++++++
 include/net/regulatory.h |    6 ++++++
 net/wireless/nl80211.c   |   15 +++++++++++++++
 net/wireless/reg.c       |   39 +++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h       |    1 +
 5 files changed, 82 insertions(+), 0 deletions(-)

iw:

 nl80211.h |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 reg.c     |   31 +++++++++++
 2 files changed, 197 insertions(+), 2 deletions(-)

-- 
1.7.4.15.g7811d
