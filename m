Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34157 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2G0HLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 03:11:40 -0400
Received: by weyx8 with SMTP id x8so1876605wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 00:11:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 0/2] wlcore tx rework
Date: Fri, 27 Jul 2012 10:11:31 +0300
Message-Id: <1343373093-10065-1-git-send-email-arik@wizery.com> (sfid-20120727_091143_752939_E7C3741B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get the hlid of a queued skb from driver internal info instead of the
sta inside the skb cb. Rework some functions so that the sta is passed
explicitly during op_tx.

Testd in STA + AP modes.

Johannes - would you like to take these via your tree, as a prerequisite
for Thomas' patch?

Arik Nemtsov (2):
  wlcore: don't get the hlid from a queued skb
  wlcore: op_tx: pass sta explicitly when inferring frame hlid

 drivers/net/wireless/ti/wlcore/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c   |   61 +++++++++++++++++----------------
 drivers/net/wireless/ti/wlcore/tx.h   |    4 +--
 3 files changed, 34 insertions(+), 33 deletions(-)

-- 
1.7.9.5

