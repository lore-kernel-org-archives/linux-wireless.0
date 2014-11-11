Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:47777 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaKKFhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 00:37:18 -0500
Received: by mail-la0-f52.google.com with SMTP id pv20so9040560lab.11
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 21:37:17 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 10 Nov 2014 21:37:16 -0800
Message-ID: <CANUX_P2Q31DLtiZJ-GNcnME3LDXE2vWLN61QqNOxsjqxgfb4Gg@mail.gmail.com> (sfid-20141111_063723_284143_429E2A45)
Subject: pull request: iwlwifi 2014-11-10
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is a pull request for 3.18. More details below.
Please pull - thanks!

The following changes since commit 31b8b343e019e0a0c57ca9c13520a87f9cab884b:

  iwlwifi: fix RFkill while calibrating (2014-11-03 15:29:17 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
tags/iwlwifi-for-john-2014-11-10

for you to fetch changes up to 87dd634ae72bb8f6d0dd12f1cbbc67c7da6dba3b:

  iwlwifi: pcie: fix prph dump length (2014-11-11 07:24:57 +0200)

----------------------------------------------------------------
Two fixes here - we weren't updating mac80211 if a scan
was cut short by RFKILL which confused cfg80211. As a
result, the latter wouldn't allow to run another scan.
Liad fixes a small bug in the firmware dump.

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: abort scan upon RFKILL

Liad Kaufman (1):
      iwlwifi: pcie: fix prph dump length

 drivers/net/wireless/iwlwifi/mvm/scan.c   | 20 ++++++++++----------
 drivers/net/wireless/iwlwifi/pcie/trans.c |  3 +--
 2 files changed, 11 insertions(+), 12 deletions(-)
