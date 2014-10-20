Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58027 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaJTNKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 09:10:14 -0400
Received: by mail-lb0-f172.google.com with SMTP id b6so3861140lbj.17
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 06:10:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] ath10k: add support for new wmi-tlv backend
Date: Mon, 20 Oct 2014 14:58:38 +0200
Message-Id: <1413809925-4352-1-git-send-email-michal.kazior@tieto.com> (sfid-20141020_151021_836022_D3858C2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First 2 patches are simple fixes. Patch 3 isn't
strictly related to wmi-tlv but I decided to
include it anyway. Other patches gradually
implement wmi-tlv.

There's a bunch of false-positive checkpatch
warnings regarding `CHECK: No space is necessary
after a cast`.

There's also a bunch of `WARNING: line over 80
characters`. I'm not sure how to deal with this in
a sane way. Most wmi-tlv enum names are horribly
long. Renaming them is an option but I'd like to
keep them unchanged wrt their original names.


Michal Kazior (7):
  ath10k: fix wmi svc bitmap dbg print
  ath10k: add sanity checks for service bmap parsing
  ath10k: make wmi service bitmap non-debug
  ath10k: implement intermediate event args
  ath10k: introduce wmi ops
  ath10k: make some wmi functions public
  ath10k: implement wmi-tlv backend

 drivers/net/wireless/ath/ath10k/Makefile   |    1 +
 drivers/net/wireless/ath/ath10k/ce.c       |    2 +
 drivers/net/wireless/ath/ath10k/core.c     |    1 +
 drivers/net/wireless/ath/ath10k/core.h     |    6 +-
 drivers/net/wireless/ath/ath10k/debug.c    |   12 +-
 drivers/net/wireless/ath/ath10k/debug.h    |    9 -
 drivers/net/wireless/ath/ath10k/hw.h       |    3 +
 drivers/net/wireless/ath/ath10k/mac.c      |   47 +
 drivers/net/wireless/ath/ath10k/spectral.c |    1 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h  |  820 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c  | 2156 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h  | 1270 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c      | 1359 +++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h      |  383 +++--
 14 files changed, 5409 insertions(+), 661 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-ops.h
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-tlv.c
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi-tlv.h

-- 
1.8.5.3

