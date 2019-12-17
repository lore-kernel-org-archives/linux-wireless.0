Return-Path: <SRS0=hdaX=2H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	TVD_SUBJ_WIPE_DEBT,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6376C2D0D1
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 18:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2572082E
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Dec 2019 18:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=goldelico.com header.i=@goldelico.com header.b="Dt/CIMZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfLQSHP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Dec 2019 13:07:15 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:27127 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbfLQSHO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Dec 2019 13:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1576606032;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=zx0YDlR/trXt7d035s0fPd4tf/CdkjzXq0uVaRx8Chg=;
        b=Dt/CIMZE09JpjmIAhOV68Cp6d2OwzPfeSEvP9a5x9YjWI0+ni+5TYu2nurtabiPvKM
        0rSDkjL2F0ERvUyBSn9Zbnos3qaSlTy6r4f7VEWWy3X6fw0xQqqpq7IG7QAvgDtIe2s0
        jBk/6ReFPKGnstlkFNKLYSTc+yGJ2YjGS+kaEZ8lxu2gXj5ZNPRsiB56dUS5w3gsPt8G
        TQ7mo1/hOBvbZDRS2pdLqana0YsFdA2t8w8N1mhwMW5a9NyhW/7nE48OZQ1ZYT/kO8O3
        edFmBUYLctd2MspeOx4Y35/m/aH1tovqicGmfbGjN8pXOjdEjmIAHA3RRwNd0XJqNw4p
        i/iA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH5Hd8HaSCa"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 46.0.7 DYNA|AUTH)
        with ESMTPSA id q020e2vBHI712eS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 17 Dec 2019 19:07:01 +0100 (CET)
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
Subject: [PATCH v2 0/2] wl1251: remove ti,power-gpio for sdio mode
Date:   Tue, 17 Dec 2019 19:06:58 +0100
Message-Id: <cover.1576606020.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* use just "wl1251: " as title prefix - by Kalle Valo <kvalo@codeaurora.org>
* fix error handling: we still have to check for wl->irq returning -EPROBE_DEFER

PATCH V1 2019-11-24 11:35:48:
The driver has been updated to use the mmc/sdio core
which does full power control. So we do no longer need
the power control gipo.

Note that it is still needed for the SPI based interface
(N900).

Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
Tested by: H. Nikolaus Schaller <hns@goldelico.com> # OpenPandora 600MHz

H. Nikolaus Schaller (2):
  DTS: bindings: wl1251: mark ti,power-gpio as optional
  wl1251: remove ti,power-gpio for SDIO mode

 .../bindings/net/wireless/ti,wl1251.txt       |  3 +-
 drivers/net/wireless/ti/wl1251/sdio.c         | 32 ++-----------------
 2 files changed, 4 insertions(+), 31 deletions(-)

-- 
2.23.0

