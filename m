Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EEB30567F
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 20:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788726069; cv=pass; b=ZO5m/nIogN7uNHFSYfgNSmbt5FVC/JSe4svJ4SB1syECmx107dTvL1jrKWt7wD3W2DaQYZM/WrfdmdJSj7J9rlFLZJfBAwP64ddHWw1dyVbVrlUywkSnFp4j4EElTApPW/2KW+XT7PmTD8ihqGll2xPDlXZ4xyGKOH4lpGDu17k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788726069; c=relaxed/simple;
	bh=oA1X1GChFEvuacw+9iNRsJvQJTnj8ElVyU5ZaQ1I8As=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=PfILLTsnTwBW5HEF0Nwn+zyFbsmpU1iFzbHG/KOod3ZpyArEDcc9SGUqIHvOQT/TKeTGCq4Hlspn4AL99Kctptdn9dYBzuoGwkwRJTA70Jo9PgUQubNyyV/mY5uiymxmPVlqn3x7Df+tUy8I0ScYRfT41Qo4psh/YwjowpK4ybY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p7nVUel8; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p7nVUel8"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a601ba6870so4001573a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 13:21:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788726066; cv=none;
        d=google.com; s=arc-20260327;
        b=sPuWskFNEOVPqmtQ9OzHWq0mBuXSKjSaRlWKbBPEbHXf+7RSoMjNhNli5Z1b1eZlWW
         rVqPuBbmUpfu2cr8goQBEzKWllUiC/4BDR1QykfJOZJlAXSNZMy2UxP2rcNmLMuXsrD3
         oGCIAL1LuvkzwV+nrfXYsv4sZJxifOFDqmgfdpYX9N4O/WumQiFgNvDTXrEF7lx6V84Q
         2y/LmbvjLvO5UWb6RrxiwQ+BE3YyQn8efpXwq9osvcqPxMFqB2z4a7Nv4tx/SLq/sXbu
         SJVSO867rHtJ793wNZKW5fiOKBlHU5E39QkDzBUkke0dz5CdlbNBrDc+k2UiE+RFsNtb
         wxxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=2wB8dZ34VBQ+EkfGi+YkoTYGW9KuX/Rd9YQ2zPOuFxc=;
        fh=Ar1qZA4AnoPx1NMYA/f+bLtOXvWC3iKuzAdiCMBHCD8=;
        b=TkpiK+x6mTO1p4Sg1bSuJiKm11NzlGa9ud3zAtsoHDE3Xf0h8CmhGah/WpBOmTA+Ot
         uBF3HTvKuZX12dyIuHCrFOd5RspZ2fZlWQXsNzPXS6gGWnOW/sPhk+ldTc6uWHi404ou
         52JkRuocwJ/gEX2TtwbnhCXjHtpn0Ji3scRBMvFrWDP3Y5P5+A37aqNBXjsdeHEEPZDr
         QHDjcfrbJ1Apc2KvFrFXgnu3MBtRWX+hMb2MEjepZZZFRb73OLZJxXCU3O87kEeaOgN/
         w523U9apaPpMUzaCxpVlR1Nnwmsm2erkVA3YeMqT0uoBGsyq4JFc/K2CFxXxzji/KwV9
         2gFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788726066; x=1789330866; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2wB8dZ34VBQ+EkfGi+YkoTYGW9KuX/Rd9YQ2zPOuFxc=;
        b=p7nVUel8PccVWgQKHDFjImpJhy8yWmMV6A59htYnyesEJsT0CoSlENNsj8YmStLHDG
         KTBCHvX86g/6Vf71yvDxNLYEfqsWO5LCYyYvmYR6zG4Cnd7z8odtC9XRbTeZY7qi6Zm3
         aDjjO3L0fxv/SEi7eJfuAL07YaW87brWpsYM6mHmcdaBYL8UFCsOnb8x/cD5EW0oXh7U
         W6KGOp7GqV1Brb48y5vmvl7t2HDy/TeG1lVRA6l909bgsUqpMPdCqNqZBKmMtf7UX16F
         wsoq6fIQErXZgL9IBY6ON062zK2ieX/8H40JvAYJH5j+QPjai+kKhhytynMGBio26rmF
         ERuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788726066; x=1789330866;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2wB8dZ34VBQ+EkfGi+YkoTYGW9KuX/Rd9YQ2zPOuFxc=;
        b=N7EXQT2pCwqCRoO25eV3dzVQyI3vAd/RuAg1zHBD9OCW7SqfdYnhTdYksmWawYtlOG
         L8vK8GkGX2V/GHsu36ZlpAVzsl0uGJAgRONkWp/33YjNgbZHDL4Ozga4gU3bBDYJnnNb
         XCUA1Djd69Zp0LZvlF3yIJT30iSI+2Ec7nqGxpWnRriGWEaxLhGGdCkUrMHiPFxZn51A
         zhxOOToQDK5TGRxgYIKeFmU+6RHUdP88k40ou6IQXdkm2daqo8x9NHVpEQ+mM13cd8ye
         UN7MMt+t1mqhSkErJp29RxRKmdQIkrXcyPQfMnIWTMNiO2GcusycWOidpnfbbvGTn/sf
         1CwA==
X-Forwarded-Encrypted: i=1; AKwUvBxk3v/15iT8jcigZDlVAHjw3GYSKcfZW5CemCkTMRcMBFhuAlm9Y52sz4G4Dyj/EDQ1FHgZBXHYY2GXQSEeOA==@vger.kernel.org
X-Gm-Message-State: AFuF++k7HOAx/Cnl1uTwiwT+p8UwOPT4f04Sl0wAo7T6DIAqAnVXy8Oh
	3zUlx1aknHb2Vsl7v7qiY/s6N0cTK514lmX+K0fB6TfhgBAz2YuFcUblc0f2PN+uweKiynoV9aT
	2YDKurDtEkIQn1K1DEURYxSTnfIrv2bc=
X-Gm-Gg: AYBFou2VbWw742QVeFZtW2iWp7y0qVkt25Pj4790aTXbLNrV0AgNVSMeJ/foYOutrwh
	8Cnvtnebo0Hxyz4bJxaSr091cxPei2m4nAyze1l3O2pWQ8MuXr1F+xmcozYahbgNMGMWPJHutxt
	lE9dAekG2IRrhBc5KeKy286b6CBIvsQeLGZQa0vD0ZZep7t6pGoIxILLIGHFrurCNszMf+nVKOl
	VRH0ZTXhYRVWIci7Hkp44DixnsMdfFfjP0OMN1VJzv+jp/9GuuXaKFjCFcax0hdspF8uXn7iN6o
	/RM7E0QCuzgWMozWeDg01FPMtb7Q6hMboRc6XrJCqJonn2eqWvOGEQAqUtN0R8nLX0kR9PXBdpE
	sTp08ssKUlXPFnMOOQ2KN
X-Received: by 2002:a05:6402:a0db:b0:6a5:ed9e:b490 with SMTP id
 4fb4d7f45d1cf-6a7e8d94c7fmr6429567a12.14.1788726065413; Sun, 06 Sep 2026
 13:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Herman Semenoff <germanaizek0@gmail.com>
Date: Sun, 6 Sep 2026 23:20:59 +0300
X-Gm-Features: AcwNN1UPxIFsHwDXU8hiGJkF5a7BpL6rW2bIEFZM53U-6Zkk-RDF2UtnB5YSwWU
Message-ID: <CAMnMt5aJwVXEVKyBR7MvVBd=qCn7fNijMC+O_cZn82zGuNPc3A@mail.gmail.com>
Subject: [PATCH wireless-next] wifi: mt7601u: add vnd_reset parameter to fix
 probe failure on Tenda U2
To: kuba@kernel.org, kvalo@kernel.org, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From c03d73d37df440d0046d68406fde2aa1f62fe0d1 Mon Sep 17 00:00:00 2001
From: Herman Semenoff <GermanAizek@aizekgroup.ru>
Date: Thu, 3 Sep 2026 07:14:32 +0300
Subject: [PATCH wireless-next] wifi: mt7601u: add vnd_reset parameter
to fix probe failure on Tenda U2

On certain MT7601U adapters, such as Tenda U2 and other newer hardware
revisions, driver initialization consistently fails during probe with
vendor request timeouts (-110 / -ETIMEDOUT):

    mt7601u 3-14:1.0: ASIC revision: 76010001 MAC revision: 76010500
    mt7601u 3-14:1.0: Firmware Version: 0.1.00 Build: 7640
    mt7601u 3-14:1.0: Vendor request req:07 off:09a8 failed:-110
    mt7601u 3-14:1.0: Vendor request req:02 off:09a8 failed:-110
    mt7601u 3-14:1.0: Vendor request req:07 off:0734 failed:-110
    mt7601u 3-14:1.0: Vendor request req:42 off:0230 failed:-110
    mt7601u 3-14:1.0: probe with driver mt7601u failed with error -110

The failure occurs because mt7601u_load_firmware() unconditionally calls
mt7601u_vendor_reset() (MT_VEND_DEV_MODE_RESET) before uploading firmware
chunks. On these devices, issuing this vendor reset leaves the internal
MCU / FCE DMA engine in an unresponsive state after the first firmware
URB is submitted. As a result, reading MT_TX_CPU_FROM_FCE_CPU_DESC_IDX
(0x09a8) immediately times out.

Introduce a boolean module parameter 'vnd_reset' (default: false) to
make this vendor reset optional. When the vendor reset is skipped,
firmware upload succeeds and the wireless interface initializes normally.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1716301
Link: https://www.opena.tv/viewtopic.php?t=63919
Link: https://askubuntu.com/questions/1418850/the-problem-with-wi-fi-u2
Link: https://bbs.archlinux.org/viewtopic.php?id=224859
Link: https://reddit.com/r/archlinux/comments/1d6dfv5/mt7601u_usb_wifi_not_working/
Signed-off-by: Herman Semenoff <GermanAizek@aizekgroup.ru>
---
This patch is based on linux-next (tag: next-20260904, commit af5f12805e5c)
and targets the wireless-next tree.

Note: Alternatively, if maintainers prefer to avoid adding a module
parameter and can confirm that mt7601u_vendor_reset() is not required
on any supported hardware, the vendor reset call could instead be dropped
entirely.

 drivers/net/wireless/mediatek/mt7601u/mcu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index bad6ca821400..c7c5bd9bb9df 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/usb.h>
 #include <linux/skbuff.h>
+#include <linux/moduleparam.h>

 #include "mt7601u.h"
 #include "dma.h"
@@ -21,6 +22,10 @@
 #define MCU_FW_URB_SIZE (MCU_FW_URB_MAX_PAYLOAD + 12)
 #define MCU_RESP_URB_SIZE 1024

+static bool vnd_reset;
+module_param(vnd_reset, bool, 0644);
+MODULE_PARM_DESC(vnd_reset, "Perform vendor reset during firmware
upload (default: false)");
+
 static inline int firmware_running(struct mt7601u_dev *dev)
 {
  return mt7601u_rr(dev, MT_MCU_COM_REG0) == 1;
@@ -459,8 +464,10 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
  mt7601u_wr(dev, 0x94c, 0);
  mt7601u_wr(dev, MT_FCE_PSE_CTRL, 0);

- mt7601u_vendor_reset(dev);
- msleep(5);
+ if (vnd_reset) {
+ mt7601u_vendor_reset(dev);
+ usleep_range(5000, 10000);
+ }

  mt7601u_wr(dev, 0xa44, 0);
  mt7601u_wr(dev, 0x230, 0x84210);
-- 
2.55.0

base-commit: af5f12805e5cefa4fe68d6127c7e1fb78cd5535c
