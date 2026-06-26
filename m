Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362953EB0FB
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 09:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782467826; cv=none; b=U67/whwMp5zQCnzeQy7Sr2ooBIUe6Nnq+iwpnFITKdTx9gitkLA/vih35CdQ+ndpZQ7T3YcBstcmLSY46ha6s+s8TQ7ztdDnfuvTx1Jez0/HqxuQHVl9ihDg8SDQfCxf1A9UiKJ9GxxGiz1g52/C64o99X+jU76zLfShE0n+GKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782467826; c=relaxed/simple;
	bh=zepRcPhgTUOLQNEJOkeBPOZR/WJlUAxAtysGwOAHljk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5t5peXMNoI0KisfbQZm/02t61QjwBwEhroedg/F7+0Ne3WssQoR5VsCnNrGV594YVj3mwDILncyOBzDWjin+bmOCPr6Da4vixZO6U5MbMKwG0zAfefdKfa9mlBM2P1k9qBsQE6Q/5jG9w1AYNabTpYTM7l/prr0lbj+vWOj6CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MvnF6QbO; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvnF6QbO"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-697edb1bf6eso1111684a12.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 02:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782467823; x=1783072623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2lPa+Apa+qlyNhAmUOrN3iYqKzl046XVoB47HCRS+E=;
        b=MvnF6QbODTLuSkgRfVtoww0/+/0blDl5DWaKKH7q1UcOOhczzpj9MVHxAJoXKpRWZh
         cv458A4JnVHeIThMs50V3jkDKsU+CRsJJIxZ3acn2tV4GedWd2DJ7Bmq4wOKZl0fM8rZ
         ZRcAsg8Rlsa5AXQmrLgpBfwM2Gyd6zLRIrLyg1HZhgYW02++JbS4Qwf/PZYrt49A4SHk
         5Ad48Tj8eRZdNtXcl/7s4zKq1br6jxYxprQErm/tQsogmWtyV+7TaSkBGQtI+B6nOAtN
         87603N64ZL248HMR3ptvui9FBlSmmQPr5pYkfBywRzWI9g1rzNDmtkOwXhByKz8CINXt
         HDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782467823; x=1783072623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k2lPa+Apa+qlyNhAmUOrN3iYqKzl046XVoB47HCRS+E=;
        b=eNJ9HrOiOmJmVNIBR3vyro8VT4TWWmqBsItPAxPpH7/4/VeGSL/WM2rUB382Q3oByh
         4B9IxTcZXbes/REAvxmhwpEmskr/UygsEOAP07kV/ZB3G+vuOH+T15aIrvTM7PfXUaag
         LwQ6XLFXipQZDo03FHriob5Chlp+BKZ0RISIRwKudNCuFv+alwPxNENbq+pMu3Ps+6bf
         uSMCFn7Dn6xHIsfpgwo7YXaK6t/JgQ1OHdH9d5I5227QybIGVXzDnevQu/9ASdGJadGy
         10icsc38XrevpUct3ekplK0urlH7/gb50GDgcNXzBC5o/wExiDR6s6LGYQ/eMZTp5ViP
         ruRQ==
X-Gm-Message-State: AOJu0Yw5XguiWmclDW7xqFOcidFm3hwdYBsH8GYmspYmNy5slWwI8oes
	/EUVoKzDG3CGhl3QpdRj5Zay+Cr8lC6N0BfeftA9U2//JJft+pF6dgz2
X-Gm-Gg: AfdE7ckMYk7Jbs0HBhMdXpVaiz/Iw6Wn9OOXFkJ3s1P+cRnWdqBGBeCjwWhCkNxno/E
	G4UblcPUnkYKUplLR1L+9nN4Jb2k2g+/MnPXUhr9ubZBUS6a8aBvmon0oWAbJIPQsWYkQGRzMCS
	/EDxhlyjWkdEEYxMokeMAmZKKmv/btrQRoYrKcYkaGlrgR24HO0QjhuDTTeW3GUESV2Bp2Zu6SO
	1rESN0aGE7H9nJRiduYKXIbNDWHgIlHJUJB3jPev9OWyqLpEbbjEAA9GMRSG8/n+ZGr3EHyKQkv
	e+TFoFGmzlcZ13FU7zVDfzHkKsm21aE5f9Y49DYNr80wq3MVHiUx/TxcJfOSisnt64LN/9hksoV
	3V9Ki7eOW9emNBt0nQcK5wT5N3oYgHD1Sv7Ev6s/YotRo8hXX+YYszUijx4WlheO153k9zHwuQ2
	Nk10VeiH4/NshR/Z5sZcpKpHA=
X-Received: by 2002:a17:906:fd83:b0:c12:30dd:de2 with SMTP id a640c23a62f3a-c1230dd138bmr30240466b.16.1782467823278;
        Fri, 26 Jun 2026 02:57:03 -0700 (PDT)
Received: from localhost ([80.208.66.169])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbba677csm313022566b.11.2026.06.26.02.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 02:57:02 -0700 (PDT)
From: William Hansen-Baird <william.hansen.baird@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	William Hansen-Baird <william.hansen.baird@gmail.com>
Subject: [PATCH rtw-next v3 3/3] wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 17aa:b736
Date: Fri, 26 Jun 2026 11:56:48 +0200
Message-ID: <20260626095648.1124924-4-william.hansen.baird@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626095648.1124924-1-william.hansen.baird@gmail.com>
References: <20260626095648.1124924-1-william.hansen.baird@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RTL8723BE outputs a large amount of PCIe AER errors during and
after boot, even before probe and when driver is never loaded.
This causes significant system slowdown.

The errors are the same as reported by
commit 77a6407c6ab2 ("wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723")

Add the RTL8723BE with subsystem ID 17aa:b736 to the rtl_aspm_quirks
table to stop the AER errors. AER errors can still be present prior to
pci probe, as the device by default may have ASPM enabled.

Testing on a Razer Blade 14 2017 which shipped from the
OEM equipped with an RTL8723BE card with this subsystem ID
confirms that this patch resolves the AER flood and allows the
wireless card to function normally once the driver takes over.

Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 44121203671c..b5611c5a2cd5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -34,6 +34,8 @@ static const u8 ac_to_hwq[] = {
 static const struct pci_device_id rtl_aspm_quirks[] = {
 	/* ASUSTek F441U/X555UQ */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REALTEK, 0xb723, 0x11ad, 0x1723) },
+	/* Razer Blade 14 2017 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REALTEK, 0xb723, 0x17aa, 0xb736) },
 	{ }
 };
 
-- 
2.54.0

