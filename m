Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463633093A6
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785600604; cv=none; b=BAHyEzY3lK1DT58KbT1PJPxzX1pxM7riZIUXXua+y3I7u4Qzj1S4KVnm9LekNPVKR4vdh0qrAcZJVUNSGaBfASmjlku39FghQRHTVXgs7JX9m4cPr2I3He9InFWyP13fF09x00Ys1hv16hiLgeAFTu4S2AINqiPvs3Yt84S9VHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785600604; c=relaxed/simple;
	bh=mU48XutIQu9U1nnENybcXBIpxpVHt7bqkhtI9Dgsmno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEEetXf/2QYyf0oyn6TkAwLfNSsgYvVFBYXpfSM4ccYyrKEDiRoOmyc+r4Rpd6l6Qm15y2oYfYtsNhz/V60nhOQtvr7BsYamMnq9sVRzywhKelo2xbJh+06/Ur21sN7w20Au42r5UFap5o3RkGMsFO5jxTpjr6lKSr2QvBNLE/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VnZNBdju; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnZNBdju"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so1632486a12.2
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 09:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785600603; x=1786205403; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OAH0aaBcNE5pbI6Vh/1tSYyGZ49sfz+qqIld0AASCLE=;
        b=VnZNBdju8HWOmD7XPxiU5qxMou2erA4FI8NgQICinuLx77n7euqIFch/n5KeGRq1K3
         4yxrBli9nQeKH6b7LCwLkJPL+WNY6erfG6tlmbzNZHrx7N7sUp4kyj4NT2fshC3KRFa6
         XZx+5aaui+uMwA2WREjg2m1O7kQtOMUwL8K1FbkWGDbsLBahU9Qj0py9Jr9C/7a0cIpd
         LbmDHNl9cJJLLr2QOPNWcuX62g2zcgVrehEnT2+iY8KlfrYFO59aKe1aqzjPwgQ3ccQs
         fnOYI9V8x70xPjjZaWRFbpuMEmxnxB+rtfRLMZxThO/9lY7LUSJlulaTfFmW0JqQSn/W
         IyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785600603; x=1786205403;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OAH0aaBcNE5pbI6Vh/1tSYyGZ49sfz+qqIld0AASCLE=;
        b=qLALKceFZGIXWqBqhJKYcgNGIyFttlO6SGrqbDPJ4yfhx15u2RhJUvS5u66U33RPK0
         A+5uGPJs6NK3GYyqy0s4Bo5H77inIZfghV1+a+wf+lPXrhmhL8Ix3hTeFpUeXIBAkTFg
         hJj+hPyBQzKqFYD2LzFXtJIP8rahDP+NZCfjIBsLe2P2n45qOkABZhmXZZdQdDbQHHql
         WkSoR30oKDh6OWRN1sT3EjsQPV6AkksfUE/gxRnWAyOhSed0L0MB6eiI/znst9WRiyZ3
         DEE/WUgkbBCQytvCqByzO6KUpU+MRbSSFkk0w/3uXZSY7r1p+Z441KmEyysHIAhz7LAh
         QDKQ==
X-Gm-Message-State: AOJu0Yypr+3j8uRXew7pVBEchB5POypVvf8lvgra7YwsnwaCcO9cpjLy
	S28ktNT1SDtzg9s5BSUJMqU4aQRfEaJYf4kJNtZhhDTLg60wbgdE8Vl7a7gv1x1G
X-Gm-Gg: AR+sD12kmldZMlBDTRpmbNRBmTf5g41ok/ZbKQy5o3GCnk0kf9zGzkROTyZrJRwewvQ
	YnuTOOUbPjs2Mbc3cPUW7ir9b8f18JfQnjHGNS2qfp0vID5+1SkPjALz6S5x2xf1fELRmYQB4i1
	R7mA0xMBxyCi8eEx26kkJGGL4FqextzMxzfYNbxAYpM0S97tk23amdEhf4emIqujiT2tH5UXGYs
	TAcqPg16Kjk03exzxjnq/7h8ZJkdj3AQJekU7oeMyURGIHqmCzcl/AUTkyxsBvu2igM2HjDDRy1
	I05TBqisIfGcMpZHJPnlZMDvBIV5Whqukji33eDOnTG0MSVdljYA6IjycRnTxSNWzfLxcj+rplQ
	Wb9876EXQ2hUU6Mg4wnpMELcdVYYSzt3zQkEFFawUw8rJqj2wDNvmImUJEZlz9Y839JooexNM22
	1MDmnFvXU0RjYXhU/c4q8WSPEH4mIsAhcqpEKE0UqcqaSqYpY5o6yFEMmjvrtDlRMixntnqDXAr
	H48kZGsXjMno6tNkh4YCv6pWN/o
X-Received: by 2002:a05:6a21:99a3:b0:3c3:7dfd:22be with SMTP id adf61e73a8af0-3c92a826d43mr3747998637.53.1785600602441;
        Sat, 01 Aug 2026 09:10:02 -0700 (PDT)
Received: from localhost ([2409:40c4:18:70ff:d54f:b0c4:6a9f:71d7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e5b0sm17212440eec.1.2026.08.01.09.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 09:10:01 -0700 (PDT)
Date: Sat, 1 Aug 2026 21:39:58 +0530
From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
To: Snake Pilot <snakepilot10@gmail.com>
Cc: linux-wireless@vger.kernel.org, pkshih@realtek.com, 
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] rtw88_8723de: Wi-Fi and Bluetooth fail after warm reboot
Message-ID: <am4JYI-tXa-rK7Hq@eggarch>
References: <CA+fxq6gPCQOYr6mh+_1ReOGzaiTULzMazXhs5q0PXc8PsjRJEQ@mail.gmail.com>
 <amnGXPlG6nKUdEl7@eggarch>
 <CA+fxq6i05RW5G289EL9V_uUgidQhDOpUhiy_J++pDDwqLwJp0Q@mail.gmail.com>
 <am0AOC9ZmP81kGcT@eggarch>
 <CA+fxq6hD-duO3g1gEEQL5o+_S-y8dfFDerD58=scNsd9WfdU5Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="glh5jd5gyccenl4p"
Content-Disposition: inline
In-Reply-To: <CA+fxq6hD-duO3g1gEEQL5o+_S-y8dfFDerD58=scNsd9WfdU5Q@mail.gmail.com>


--glh5jd5gyccenl4p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thanks for testing, 

On Sat, Aug 01, 2026 at 02:00:12AM -0600, Snake Pilot wrote:
> This explains the missing btusb shutdown log, although it does not by itself
> explain or fix the retained hardware state. I can test a corrected diagnostic
> or a specific USB reset/shutdown sequence if useful.
I didn't notice this, I'll fix it in updated patch.

I'm adding some logging in pci.c around rtw_pci_shutdown(),
maybe the chip's power or reset state is just stuck before rtw88*
reaches it and USB for some reason leaves it that way. Let's see if the 
PCIe function even reaches D3hot transition.

Could you redo a warm reboot with only the updated patch and attach the
previous and current logging same as before?
Could you also attach your acpidump? I'd like to see if D3cold state is
possible which may be a possible fix.

Regards,
Lovekesh

--glh5jd5gyccenl4p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="diag2.patch"

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 7f54d2d2d13a..b78feb7ddde8 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1402,6 +1402,8 @@ int btrtl_shutdown_realtek(struct hci_dev *hdev)
 	struct sk_buff *skb;
 	int ret;
 
+	bt_dev_info(hdev, "diag: btrtl_shutdown_realtek: sending HCI_OP_RESET");
+
 	/* According to the vendor driver, BT must be reset on close to avoid
 	 * firmware crash.
 	 */
@@ -1411,6 +1413,7 @@ int btrtl_shutdown_realtek(struct hci_dev *hdev)
 		bt_dev_err(hdev, "HCI reset during shutdown failed");
 		return ret;
 	}
+	bt_dev_info(hdev, "diag: btrtl_shutdown_realtek: HCI_OP_RESET completed OK");
 	kfree_skb(skb);
 
 	return 0;
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 184e95c1625e..2369ca69af9c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2005-2008  Marcel Holtmann <marcel@holtmann.org>
  */
 
+#include "linux/bitops.h"
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/usb.h>
@@ -4470,6 +4471,8 @@ static void btusb_disconnect(struct usb_interface *intf)
 	struct btusb_data *data = usb_get_intfdata(intf);
 	struct hci_dev *hdev;
 
+	bt_dev_info(data ? data->hdev : NULL, "diag: btusb_disconnect called for intf %p", intf);
+
 	BT_DBG("intf %p", intf);
 
 	if (!data)
@@ -4682,10 +4685,21 @@ static void btusb_coredump(struct device *dev)
 }
 #endif
 
+static void btusb_shutdown(struct usb_interface *intf)
+{
+	struct btusb_data *data = usb_get_intfdata(intf);
+
+	bt_dev_info(data ? data->hdev : NULL,
+	     "diag: btusb_shutdown() reached intf %p, hdev up=%d",
+	     intf, data && data->hdev ? test_bit(HCI_UP, &data->hdev->flags) : -1);
+
+}
+
 static struct usb_driver btusb_driver = {
 	.name		= "btusb",
 	.probe		= btusb_probe,
 	.disconnect	= btusb_disconnect,
+	.shutdown	= btusb_shutdown,
 	.suspend	= pm_ptr(btusb_suspend),
 	.resume		= pm_ptr(btusb_resume),
 	.id_table	= btusb_table,
diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index eaa928bab240..f6c548681e45 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include "hci.h"
 #include "main.h"
 #include "mac.h"
 #include "reg.h"
@@ -166,6 +167,10 @@ static int rtw_pwr_cmd_polling(struct rtw_dev *rtwdev,
 
 	/* if PCIE, toggle BIT_PFM_WOWL and try again */
 	value = rtw_read8(rtwdev, REG_SYS_PW_CTRL);
+
+	rtw_info(rtwdev, "diag: pre-toggle REG_SYS_PW_CTRL=0x%02x, poll offset = 0x%x want=0x%x\n",
+	  value, offset, cmd->value & cmd->mask);
+
 	if (rtwdev->chip->id == RTW_CHIP_TYPE_8723D)
 		rtw_write8(rtwdev, REG_SYS_PW_CTRL, value & ~BIT_PFM_WOWL);
 	rtw_write8(rtwdev, REG_SYS_PW_CTRL, value | BIT_PFM_WOWL);
@@ -173,6 +178,9 @@ static int rtw_pwr_cmd_polling(struct rtw_dev *rtwdev,
 	if (rtwdev->chip->id == RTW_CHIP_TYPE_8723D)
 		rtw_write8(rtwdev, REG_SYS_PW_CTRL, value | BIT_PFM_WOWL);
 
+	rtw_info(rtwdev, "diag: post-toggle REG_SYS_PW_CTRL=0x%02x, retry poll read=0x%02x\n",
+	  rtw_read8(rtwdev, REG_SYS_PW_CTRL), rtw_read8(rtwdev, offset));
+
 	if (do_pwr_poll_cmd(rtwdev, offset, cmd->mask, cmd->value))
 		return 0;
 
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a30467228912..e80cfa738262 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include "linux/pci_regs.h"
 #include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -1909,6 +1910,10 @@ void rtw_pci_shutdown(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct rtw_dev *rtwdev;
 	const struct rtw_chip_info *chip;
+	int pm_cap;
+	u16 pmcsr = 0xffff;
+
+	dev_info(&pdev->dev, "diag: rtw_pci_shutdown: entry, hw=%p\n", hw);
 
 	if (!hw)
 		return;
@@ -1919,7 +1924,23 @@ void rtw_pci_shutdown(struct pci_dev *pdev)
 	if (chip->ops->shutdown)
 		chip->ops->shutdown(rtwdev);
 
+	pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
+
+	if(pm_cap) {
+		pci_read_config_word(pdev, pm_cap + PCI_PM_CTRL, &pmcsr);
+		dev_info(&pdev->dev, "diag: pre-D3hot PMCSR=0x%04x (state=D%d)\n",
+	   pmcsr, pmcsr & PCI_PM_CTRL_STATE_MASK);
+	} else {
+		dev_info(&pdev->dev, "diag: no PCI PM capability found\n");
+	}
+
 	pci_set_power_state(pdev, PCI_D3hot);
+
+	if(pm_cap){
+		pci_read_config_word(pdev, pm_cap + PCI_PM_CTRL, &pmcsr);
+		dev_info(&pdev->dev, "diag: post-D3hot PMCSR=0x%04x (state=D%d)\n",
+	   pmcsr, pmcsr & PCI_PM_CTRL_STATE_MASK);
+	}
 }
 EXPORT_SYMBOL(rtw_pci_shutdown);
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c8d14128c363..2d170801196e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6,6 +6,7 @@
  * Copyright 2023 NXP
  */
 
+#include "net/bluetooth/hci.h"
 #include <linux/property.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -5416,11 +5417,20 @@ static int hci_dev_shutdown(struct hci_dev *hdev)
 	bool was_userchannel =
 		hci_dev_test_and_clear_flag(hdev, HCI_USER_CHANNEL);
 
+	bt_dev_info(hdev, "diag: hci_dev_shtudown: HCI_UP=%d HCI_UNREGISTER=%d shutdown_cb=%ps",
+	     test_bit(HCI_UP, &hdev->flags),
+	     hci_dev_test_flag(hdev, HCI_UNREGISTER),
+	     hdev->shutdown);
+
 	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
 	    test_bit(HCI_UP, &hdev->flags)) {
 		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
+		if (hdev->shutdown) {
+			bt_dev_info(hdev, "diag: calling vendor shutdown callback");
 			err = hdev->shutdown(hdev);
+			bt_dev_info(hdev, "diag: vendor shutdown returned %d", err);
+
+		}
 	}
 
 	if (was_userchannel)

--glh5jd5gyccenl4p--
