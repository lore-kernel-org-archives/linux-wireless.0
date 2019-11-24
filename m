Return-Path: <SRS0=7RDh=ZQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SUBJ_WIPE_DEBT,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C960C432C3
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Nov 2019 10:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECA92073F
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Nov 2019 10:36:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=goldelico.com header.i=@goldelico.com header.b="ZtAYDcZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKXKgA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Nov 2019 05:36:00 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:29826 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfKXKgA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Nov 2019 05:36:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574591757;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=7/Su7LIUFXCMYAAUJpgUrh1IyPiKuKgf6Y9rKoiIpQI=;
        b=ZtAYDcZCbtMSahR0IGQlOWDCDHAnVXCAV4WJXpaxKDyN8EevX+VnTnN7xOdcxbUiEV
        k2fVGFvORRbEHm090jvcj3ltaerMsuXcaKjR25xlMyKxvrQSiSG+rwWT0KUZGPgM8iFS
        Ip2AHCK9FsME/sGVXYusb7v4CeCGR6BT7nr5wo2vHrjrkCnVr7zXsWZ2dlWpotaIWp7f
        95jsLden61E5HZYQh5pm4BsFGfoJKiKq0PF3Bsh05uyI+tZygnUYFrqVN80paA5NRDaW
        VacvKJrFoJS0/f1zcyeupttcn15OBULpG16JFcnG8URQbCLUntQSj1xJshftvCkvlX5C
        fF/A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH4HEaKeuIV"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vAOAZlw8u
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sun, 24 Nov 2019 11:35:47 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: [PATCH 0/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
Date:   Sun, 24 Nov 2019 11:35:44 +0100
Message-Id: <cover.1574591746.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The driver has been updated to use the mmc/sdio core
which does full power control. So we do no longer need
the power control gipo.

Note that it is still needed for the SPI based interface
(N900).

Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
Tested by: H. Nikolaus Schaller <hns@goldelico.com> # OpenPandora 600MHz

H. Nikolaus Schaller (2):
  DTS: bindings: wl1251: mark ti,power-gpio as optional
  net: wireless: ti: wl1251: sdio: remove ti,power-gpio

 .../bindings/net/wireless/ti,wl1251.txt       |  3 +-
 drivers/net/wireless/ti/wl1251/sdio.c         | 30 -------------------
 2 files changed, 2 insertions(+), 31 deletions(-)

-- 
2.23.0

