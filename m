Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1K0HXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 02:23:52 -0500
Received: by iage36 with SMTP id e36so7031615iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Nov 2011 23:23:52 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH] mac80211: fix race condition caused by late addBA resp
Date: Sun, 27 Nov 2011 02:23:40 -0500
Message-Id: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com> (sfid-20111127_082402_226667_DE3FCE0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently if addBA respones comes in just after addba_resp_timer has
expired we still accept addBA response and (try to) open agg
session. This patch fixes this race condition and makes sure that if
addba_resp_timer has expired addBA response is not longer accepted and
we do not try to open half-closed session.

  It looks like this is related to discussion of iwlagn being
'shaky'. I have intel wifi 5300 and experienced complete system locks
from time to time. And sometimes I get the following in logs
(i.e. this is the last thing which gets into log before system freezes):

Nov 26 23:50:09 kolya-laptop kernel: [147253.552830] Open BA session requested for 00:14:d1:53:50:2d tid 0
Nov 26 23:50:09 kolya-laptop kernel: [147253.564129] activated addBA response timer on tid 0
Nov 26 23:50:10 kolya-laptop kernel: [147254.564025] addBA response timer expired on tid 0
Nov 26 23:50:10 kolya-laptop kernel: [147254.564048] Tx BA session stop requested for 00:14:d1:53:50:2d tid 0
Nov 26 23:50:13 kolya-laptop kernel: [147257.089647] switched off addBA timer for tid 0
Nov 26 23:50:13 kolya-laptop kernel: [147257.089653] Aggregation is on for tid 0
Nov 26 23:50:13 kolya-laptop kernel: [147257.089817] iwlwifi 0000:0b:00.0: Tx aggregation enabled on ra = 00:14:d1:53:50:2d tid = 0
Nov 26 23:50:13 kolya-laptop kernel: [147257.089829] ------------[ cut here ]------------
Nov 26 23:50:13 kolya-laptop kernel: [147257.089849] WARNING: at /home/kolya/projects/wireless/compat-wireless/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:1106 iwl_trans_pcie_tx+0x9d2/0x9e0 [iwlwifi]()
... part of stack trace which got to disk before lock ...

  It can be seen here that session response timer gets expired which
brings agg session down. Shorty after addba resp arrives which tries to bring
that same session up. And it looks like this causes driver confusion and
subsequent system freeze.
  This patch seems to fix the problem for me. Didn't have system
freezes since I've applied it couple of days ago.

  All comments and suggestions are really appreciated.
  Thanks.

Nikolay Martynov (1):
  mac80211: fix race condition caused by late addBA resp

 net/mac80211/agg-tx.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

-- 
1.7.4.1

