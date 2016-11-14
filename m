Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35588 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932297AbcKNQf0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:26 -0500
Received: by mail-lf0-f68.google.com with SMTP id p100so7512449lfg.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:25 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 00/12] ath10k sdio support
Date: Mon, 14 Nov 2016 17:33:30 +0100
Message-Id: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173536_875382_03748614)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds sdio support to ath10k.

Some of the patches affect the existing pcie/ahb code as well.
Those are patches 3 and 4 in the series.

Overview:
A new HIF layer: sdio/mailbox.
The current HIF ops are unaltered even though some ops
are not applicable for sdio.

The HTC layer has only suffered minor modifications:
- A few new functions for handling the mailbox specific
  RX trailers (lookahead reports)
- Some minor refactorization of the existing code
  (patches 3 and 4)

This is not included in this patch series:

- HTT High latency RX and TX support
- Full integration in core.c

The following basic tests have been made so far:

BMI fw load and firmware startup (all the steps in ath10k_core_start).
This means:

- HTT service connect
- WMI control service connect
- WMI unified init

The above mentioned bullets where verified with a QCA6584 chipset.

I have not been able to test the patch series together with
ath10k pcie hardware, but I will do so as soon as I can get
my hands on some hardware.

The patches have been built and tested against the ath tree:
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
branch/tag: master/ath-201611090123

Erik Stromdahl (12):
  ath10k: htc: made static function public
  ath10k: htc: rx trailer lookahead support
  ath10k: htc: Changed order of wait target and ep connect
  ath10k: htc: refactorization
  ath10k: htc: Added ATH10K_HTC_FLAG_BUNDLE_LSB
  ath10k: bmi: Added SOC reg read/write functions
  ath10k: Added SDIO dbg masks
  ath10k: Added ATH10K_BUS_SDIO enum
  ath10k: Mailbox address definitions
  ath10k: Added QCA65XX hw definition
  ath10k: Added more host_interest members
  ath10k: Added sdio support

 drivers/net/wireless/ath/ath10k/Kconfig     |    6 +
 drivers/net/wireless/ath/ath10k/Makefile    |    3 +
 drivers/net/wireless/ath/ath10k/bmi.c       |   79 +-
 drivers/net/wireless/ath/ath10k/bmi.h       |    4 +
 drivers/net/wireless/ath/ath10k/core.h      |    3 +
 drivers/net/wireless/ath/ath10k/debug.h     |    2 +
 drivers/net/wireless/ath/ath10k/htc.c       |  208 ++-
 drivers/net/wireless/ath/ath10k/htc.h       |   36 +-
 drivers/net/wireless/ath/ath10k/hw.h        |   54 +
 drivers/net/wireless/ath/ath10k/sdio.c      | 1855 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/sdio.h      |  276 ++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |   24 +
 12 files changed, 2484 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath10k/sdio.h

-- 
1.7.9.5
