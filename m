Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED9EC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 12:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEFD2146F
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 12:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbfAKMLz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 07:11:55 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:40011 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfAKMLy (ORCPT
        <rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
        Fri, 11 Jan 2019 07:11:54 -0500
Received: from ziggy.stardust ([37.223.147.38])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Fri, 11 Jan 2019 13:11:52 +0100
To:     linux-firmware@kernel.org
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        serge@raspberrypi.org, phil@raspberrypi.org, arend@broadcom.com
From:   Matthias Brugger <mbrugger@suse.com>
Subject: [GIT PULL] Add NVRAM files for bcm43455 and bcm43430
Openpgp: preference=signencrypt
Autocrypt: addr=mbrugger@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <52ec533a-bd4e-71b4-7bcd-8f2791dec564@suse.com>
Date:   Fri, 11 Jan 2019 13:11:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Josh,
Hi all,

This pull request add firmware files neede by bcm43430 for Raspberry Pi 3 Model
B and bcm43455 for Raspberry Pi 3 Model B+.

Please have a look and, if convenient, pull :)

Best regards,
Matthias

---
The following changes since commit 0f22c8527439eaaf5c3fcf87b31c89445b6fa84d:

  Revert "amdgpu: update vega10 fw for 18.50 release" (2018-12-18 15:38:53 -0500)

are available in the Git repository at:


ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/matthias.bgg/linux-firmware.git/
tags/add-rpi-fw

for you to fetch changes up to 930f276f8f1f2d83e44da6a32f4e0b2513db21a2:

  brcm: Add BCM43430 NVRAM for the Raspberry Pi 3 Model B (2019-01-11 13:04:43
+0100)

----------------------------------------------------------------
- Add NVRAM for BCM43455 used by Raspberry Pi 3 Model B+
- Add NVRAM for BCM43430 used by Raspberry Pi 3 Model B

----------------------------------------------------------------
Matthias Brugger (2):
      brcm: Add BCM43455 NVRAM for Raspberry Pi 3 B+
      brcm: Add BCM43430 NVRAM for the Raspberry Pi 3 Model B

 WHENCE                                      |   3 +
 brcm/brcmfmac43430-sdio.raspberrypi-rpi.txt |  47 ++++++++++++++++
 brcm/brcmfmac43455-sdio.clm_blob            | Bin 0 -> 14036 bytes
 brcm/brcmfmac43455-sdio.raspberrypi-rpi.txt |  82 ++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+)
 create mode 100644 brcm/brcmfmac43430-sdio.raspberrypi-rpi.txt
 create mode 100644 brcm/brcmfmac43455-sdio.clm_blob
 create mode 100644 brcm/brcmfmac43455-sdio.raspberrypi-rpi.txt
