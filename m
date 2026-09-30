Received: from e3i606.smtp2go.com (e3i606.smtp2go.com [158.120.86.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1712C476CE6
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=158.120.86.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760110; cv=none; b=cr2DbScqaVAVv3lbUBuhp5rdCxS5CxFppQvQNScRxcC8cvoKWjTwdgNjL0GVS4QVruMtCIjf74LgKCe8UPuWgh0DRTCfM5S8l0CJySLn10qzSolnIK11b7QCv7iYNYzPIzAonvJqdWwKl4QXsoQg2Mijz5YEFhDR1M40BjUoAsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760110; c=relaxed/simple;
	bh=+3jvQTT5vdJhXYkEIxp2WFF2mukSvY5JKAAYNtgivtc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EGRGnVnIc0rigEvEMScg6A5IAM+30oktwciXdrijGUt8zkdpnegpwopR6Ly+I6NID2VY/dZaMfmjSjmp3ksIv8duNOQXp2c7x5KEmGW5EcypQJMhn5DRr471oq6pm3f8p0Ubedo7rCPN7+AU4omKITOwMfvNPTN+j6etFyPFgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=frumar.it; spf=pass smtp.mailfrom=em856510.frumar.it; dkim=pass (2048-bit key) header.d=frumar.it header.i=@frumar.it header.b=k2kFPDUt; arc=none smtp.client-ip=158.120.86.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=frumar.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em856510.frumar.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=frumar.it header.i=@frumar.it header.b="k2kFPDUt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=frumar.it;
 i=@frumar.it; q=dns/txt; s=s856510; t=1790760104; h=from : subject :
 to : message-id : date : list-unsubscribe : list-unsubscribe-post;
 bh=VcLzYdI+bcl/9bs5nLlyou7ncxVkKv4i1VIVfRZG4kE=;
 b=k2kFPDUtd1N7eznM3wx3jyfYux28M6rsv4GT88JYjHqwOQLN7atOU1GsezQAFeom5Dgwv
 TPTyK9aDSF2zEMY8JhFHnkcR4vBwfxuWpcmpIaw/gkz7H/P0pIqAuRf1YGwATb97oWco0GD
 EYFhXAWE7fS2wfIv8oOFRak5a0/+esPJAjaGumViWJQNIjuzNbDFh8CfmYKaTs40LdzNDte
 +Ncf5/xVIsNwOf+FQLs7Lw7U0e0TXg/lzIpgkGLbDRnARafwlC6gxk4YpZ1Fr7Og+pO0az+
 QlTv5nbH+okAZRGz7F0mYHh8QfI9QKINcWRYDB+oDhnDsbaRqwaagVT8bRKw==
Received: from [10.104.244.142] (helo=frumar.it)
	by smtpcorp.com with esmtpsa (TLS1.2:ECDHE_SECP256R1__RSA_SHA512__AES_256_GCM:256:SECP256R1)
	(Exim 4.100.1)
	(envelope-from <pierluigi.frullani@frumar.it>)
	id 1xBqVR-FnQW0hPl4w4-nrA6
	for linux-wireless@vger.kernel.org;
	Wed, 30 Sep 2026 09:21:41 +0000
Received: (qmail 18088 invoked from network); 30 Sep 2026 09:21:37 -0000
Received: (simscan 1.4.6 ppid 18082 pid 18084 t 0.0412s)
 (scanners:  attach: 1.4.6 clamav: 1.4.2/m:63/d:28138); 30 Sep 0126 09:21:37 -0000
Received: from 93-39-211-185.ip77.fastwebnet.it (HELO topolinux.localnet) (pigi@93.39.211.185)
  by frumar.it with ESMTPA; 30 Sep 2026 09:21:37 -0000
From: PierluigiFrullani <pierluigi.frullani@frumar.it>
To: linux-wireless@vger.kernel.org
Subject: Problems with rtw89 on 5Ghz wlans.
Date: Wed, 30 Sep 2026 11:21:36 +0200
Message-ID: <10543730.tdPhlSkOF2@topolinux>
Organization: Frumar
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Report-Abuse: Please forward a copy of this message, including all headers, to <abuse-report@smtp2go.com>
Feedback-ID: 856510m:856510aMebZ-d:856510syQkgwy6sU
X-smtpcorp-track: rXOilee4b8sb.GKU7npYj-3yV.fSpATARC7bU

Hello all,
    I'm using Linux Mint 22.1 with kernel 7.0.0-34-generic and a 
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8852BE PCIe 802.11ax Wireless Network Controller [1T1R] [10ec:b85b] 
that has lot of issues with the 5Ghz wlan.
The problem is that has a very low sensitivity and can detect, in linux, these wlans only when I'm a few feet from access point.


I've then swapped the driver with https://github.com/morrownr/rtw89 and found the same behaviour.
I've then opened an issue there :
 https://github.com/morrownr/rtw89/issues/128 and the peoples there managed to find the culprit and patch his driver that now works perfectly.
For my understanding the problem was that my card ( may card model ? ) ( rfe_type 41 ) has only one antenna and is not correctly selected b y the driver.

Looking into the https://github.com/pkshih/rtw/blob/rtw-next/drivers/net/wireless/realtek/rtw89  code I can see that is really similar so then patche applied in the morrownr could possibly apply  also to the vanilla kernel driver.


Patch is rather easy and with this patch allied and this driver loaded now the 5Ghz is perfectly working.


Would you be interessed in pushing this patch also here ?


In case, this is the patch ( also with the comments to verify that the driver loaded is the one that is patched ) :
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index df396fbfca26..81a4be7a593d 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3244,6 +3244,14 @@ static int rtw89_mac_setup_phycap_part0(struct rtw89_dev *rtwdev)
     tx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_TX_NUM);
     rx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_RX_NUM);
 
+    if (chip->chip_id == RTL8852B && efuse->rfe_type == 41 &&
+        tx_nss == 1 && tx_ant == 2 && rx_nss == 1 && rx_ant == 2) {
+        tx_ant = 1;
+        rx_ant = 1;
+
+        rtw89_warn(rtwdev, "fix more stuff for RFE 41\n");
+    }
+
     hal->tx_nss = tx_nss ? min_t(u8, tx_nss, chip->tx_nss) : chip->tx_nss;
     hal->rx_nss = rx_nss ? min_t(u8, rx_nss, chip->rx_nss) : chip->rx_nss;
 
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index 356623341f65..c9ee3c76cfc9 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -771,6 +771,15 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
     } else {
         md->ant.type = BTC_ANT_SHARED;
         md->bt0_pos = BTC_BT_BTG;
+
+        if (md->rfe_type == 41) {
+            md->ant.num = 1;
+            md->ant.single_pos = RF_PATH_B;
+            md->ant.btg_pos = RF_PATH_B;
+            md->ant.stream_cnt = 1;
+
+            rtw89_warn(rtwdev, "fix stuff for RFE 41\n");
+        }
     }
     rtwdev->btc.btg_pos = md->ant.btg_pos;
     rtwdev->btc.ant_type = md->ant.type;



All credits must absolutelly go to  dubhater (   https://github.com/dubhater ) that did all troubleshooting and wrote the patch.
 
My interest in this is only to have a (vanilla) kernel version of this driver that works correctly as lot of problems are reported by peoples using the same chip.



Thanks


Pierluigi 


