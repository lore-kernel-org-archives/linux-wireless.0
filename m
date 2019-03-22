Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01736C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEBC8218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfCVOht (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:37:49 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54539 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbfCVOhs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:37:48 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M9Frj-1h2eTO01nr-006Q9h; Fri, 22 Mar 2019 15:37:29 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arnd Bergmann <arnd@arndb.de>, Priit Laes <plaes@plaes.org>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] b43: shut up clang -Wuninitialized variable warning
Date:   Fri, 22 Mar 2019 15:37:02 +0100
Message-Id: <20190322143725.1332353-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:l+2T80ShE+wTWiEe+c8OHlmyzj8CU42buJBkcKsGPQOBxWGYPTf
 j/kcjAHihwKHFlPM4ljM8JZXYhEDR8dXTSxF5mUQuY0mVyiUic/PNez3JVahn7vM0Na7my3
 EO66dIl54ScqGvgQD0uCaahAnvsomdz2pKqPiovsPdi+ocCU/do4ml5ccxYH5yb3Dr5586N
 Wio0ucP310IyvrzrbStXQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CpQElZp5ItQ=:dYDfuQLB5Am3TDLWwGF4Dv
 NsQDuDbjPx7JRa+zfg2KJBJY2pxX6rWTo559vCkechEZ+1rw/77kY6Kzjz4xmqjulx72bq7JH
 7+TENnWyzsNlhbdo5GBMCexG9J7qc8xLlJPIzAysfskt88QzH/53w8WMjtVn0NVaSRTPOfSdg
 p4+CC9llH72WrAAzkrUVoi+EKTiixPqAFT8Fj/VfYmIrDxPtv3OoJPq2FYKCdEkC2ac+ehWD8
 DT2Fn2Du5o4HHPd3lqy22GDReq1RFnnPunXfFx5mLbD7XIJFwyeflIqzUZYwoPdmpJ6ayDLHu
 ttDtJJttQjGSyIBtVq9fHRgUJqAkQLxYe5y/5JSSu3i2FIu+e1rd11eYIddCKEcl55EpJZaUO
 H+ffaIx0E4vcBzDpnRYmmXo6hZwFS7MG4SeD5KaLVANrfjpIDSGeEVqDiwX1WbJDFEARV0Kiq
 th4ViD5AHDkH0joOsp2H5DmR71U4nRtPmVTGmcPoUZoxtP+5irMVQHOu86roksLmslPrcvx1G
 9lPkh/eZ+5tKibfxwIrsI5f2+pvfM96YUEKwLoEK3NLJOcZ829hnrBC5juJI+f1ukYlV2MWV3
 k4qybbTu5kz1wyLtEjSHA5YbD7Tpd85ngmXmoK6jonUglGzCi5reeiGH6jKomJDfuEEYvoUrv
 7qq5fgdG7obk4m44tbAbhtiDCEEN4ANta2k4dhe8AvHDE/JCjDdoUl/sp5EqDL0KBgU3LQV+g
 9di8dKRIEomqLKeqoj2d2cy7Z6doER1HiDv/HA==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clang warns about what is clearly a case of passing an uninitalized
variable into a static function:

drivers/net/wireless/broadcom/b43/phy_lp.c:1852:23: error: variable 'gains' is uninitialized when used here
      [-Werror,-Wuninitialized]
                lpphy_papd_cal(dev, gains, 0, 1, 30);
                                    ^~~~~
drivers/net/wireless/broadcom/b43/phy_lp.c:1838:2: note: variable 'gains' is declared here
        struct lpphy_tx_gains gains, oldgains;
        ^
1 error generated.

However, this function is empty, and its arguments are never evaluated,
so gcc in contrast does not warn here. Both compilers behave in a
reasonable way as far as I can tell, so we should change the code
to avoid the warning everywhere.

We could just eliminate the lpphy_papd_cal() function entirely,
given that it has had the TODO comment in it for 10 years now
and is rather unlikely to ever get done. I'm doing a simpler
change here, and just pass the 'oldgains' variable in that has
been initialized, based on the guess that this is what was
originally meant.

Fixes: 2c0d6100da3e ("b43: LP-PHY: Begin implementing calibration & software RFKILL support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/broadcom/b43/phy_lp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_lp.c b/drivers/net/wireless/broadcom/b43/phy_lp.c
index 46408a560814..aedee026c5e2 100644
--- a/drivers/net/wireless/broadcom/b43/phy_lp.c
+++ b/drivers/net/wireless/broadcom/b43/phy_lp.c
@@ -1835,7 +1835,7 @@ static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
 static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct lpphy_tx_gains gains, oldgains;
+	struct lpphy_tx_gains oldgains;
 	int old_txpctl, old_afe_ovr, old_rf, old_bbmult;
 
 	lpphy_read_tx_pctl_mode_from_hardware(dev);
@@ -1849,9 +1849,9 @@ static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
 
 	if (dev->dev->chip_id == 0x4325 && dev->dev->chip_rev == 0)
-		lpphy_papd_cal(dev, gains, 0, 1, 30);
+		lpphy_papd_cal(dev, oldgains, 0, 1, 30);
 	else
-		lpphy_papd_cal(dev, gains, 0, 1, 65);
+		lpphy_papd_cal(dev, oldgains, 0, 1, 65);
 
 	if (old_afe_ovr)
 		lpphy_set_tx_gains(dev, oldgains);
-- 
2.20.0

