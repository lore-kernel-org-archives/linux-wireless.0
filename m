Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7F4C28CF8
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 15:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69C5420831
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 15:22:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O2UlmeKn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I3h+jHWB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69C5420831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbeKUBvw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 20:51:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbeKUBvv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 20:51:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 247586086B; Tue, 20 Nov 2018 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542727332;
        bh=2+48KDKmTX/Cbi6XjBcZLxn8flE8CLF8tnCI195Gcyg=;
        h=From:To:Cc:Subject:Date:From;
        b=O2UlmeKnDMo3sfJ/IXDUgIoxNoSLXAJlsOZuzs9BbR1WZdqXP5uneLKWq72/ZOhIS
         DhGBTxQBfhS/9NaCtMqejEzbzdH8wfc5ZViM0gFzmXq3mOwd6xJFUzp6q30G3W4Llj
         HzrhT5N8ZbU6mCvuyXU5EcB91pqixYEMo0GHl8o0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 167E2604BE;
        Tue, 20 Nov 2018 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542727331;
        bh=2+48KDKmTX/Cbi6XjBcZLxn8flE8CLF8tnCI195Gcyg=;
        h=From:To:Cc:Subject:Date:From;
        b=I3h+jHWBTi1vzT959luWrB1D63DdKuci4PaGkqPCVPvxF4HERTmHfHweHQB4GkCK+
         WWyR6KBlDWFEEfS7oeY9dOIIlsadutvLfyO6/I05QcYy9DVbrka1/zYwx7e6axfF2o
         nG9agPW4aDrTJvqOb3TxhBFaQIFPhddX6CRnzh34=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 167E2604BE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-11-20
Date:   Tue, 20 Nov 2018 17:22:07 +0200
Message-ID: <87k1l7bwps.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a pull request to net tree for 4.20, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 651022382c7f8da46cb4872a545ee1da6d097d2a:

  Linux 4.20-rc1 (2018-11-04 15:37:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git =
tags/wireless-drivers-for-davem-2018-11-20

for you to fetch changes up to 1770f0fa978ed691a454fa9d3ba903d5a70630cc:

  mt76: fix uninitialized mutex access setting rts threshold (2018-11-16 15=
:15:49 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.20

First set of fixes for 4.20, this time we have quite a few them but
all very small.

ath9k

* fix a locking regression found by a static checker

wlcore

* fix a crash which was a regression with wakeirq handling

brcm80211

* yet another fix for 160 MHz channel handling

mt76

* fix a longstaning build problem when CONFIG_LEDS_CLASS is disabled

* don't use uninitialised mutex

iwlwifi

* do note that the iwlwifi merge tag (commit 4ec321c14693) seems to
  contain wrong list of changes so ignore that

* fix ACPI data handling, a memory leak and other smaller fixes

ath10k

* fix a crash during suspend which was a recent regression

----------------------------------------------------------------
Arnd Bergmann (1):
      mt76: fix building without CONFIG_LEDS_CLASS

Brian Norris (1):
      ath10k: don't assume 'vif' is non-NULL in flush()

Dan Carpenter (1):
      ath9k: Fix a locking bug in ath9k_add_interface()

Emmanuel Grumbach (2):
      iwlwifi: mvm: support sta_statistics() even on older firmware
      iwlwifi: mvm: fix regulatory domain update when the firmware starts

John Stultz (1):
      wlcore: Fixup "Add support for optional wakeirq"

Kalle Valo (1):
      Merge tag 'iwlwifi-for-kalle-2018-11-15' of git://git.kernel.org/.../=
iwlwifi/iwlwifi-next

Lorenzo Bianconi (1):
      mt76: fix uninitialized mutex access setting rts threshold

Luca Coelho (1):
      iwlwifi: mvm: don't use SAR Geo if basic SAR is not used

Matt Chen (1):
      iwlwifi: fix wrong WGDS_WIFI_DATA_SIZE

Rafa=C5=82 Mi=C5=82ecki (2):
      brcmutil: really fix decoding channel info for 160 MHz bandwidth
      brcmfmac: fix reporting support for 160 MHz channels

Shahar S Matityahu (1):
      iwlwifi: fix D3 debug data buffer memory leak

 drivers/net/wireless/ath/ath10k/mac.c              |  2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  3 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  3 +-
 .../net/wireless/broadcom/brcm80211/brcmutil/d11.c |  3 ++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |  4 ++-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |  6 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 38 +++++++++++++++++-=
----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 12 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  5 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  2 ++
 drivers/net/wireless/mediatek/mt76/Kconfig         |  6 ++++
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  8 +++--
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  1 -
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |  6 ++--
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |  4 +--
 drivers/net/wireless/ti/wlcore/sdio.c              | 17 ++++++----
 16 files changed, 82 insertions(+), 38 deletions(-)
