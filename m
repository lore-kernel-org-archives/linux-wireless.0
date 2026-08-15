Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6C439D6EC
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 10:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786790000; cv=none; b=YA0zjjeKJzgU86/AywwyMZvAaBPV6SmwXCco53zJyUajTIruMaUuH/URmBk47jcY76cDxTBEjUCoV7qye0YzUJBe4u/krX/RJs1LLXuLZkdr5OjVc0N06vf4nGzdi4ZfqliXN6GVLyfcHoaYpyYT2ilufmZAIBlWHgrMQvU7M00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786790000; c=relaxed/simple;
	bh=VzE7dHFcpp7Z1hppWUS73H1uQgBShBDQYBBo0XUsjCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CkaWNqKP1CHuuG9ipO3JDcv32Oc1CHVvDe/wUZx83kFbRTR3jQfiSkiWtlDfDEXcOs9gayrrbjP/V0qJkGoPavm6eHur6H6D5yYq2HnctdokroOIXKbeVeUdWbwbLJp6Y5oXaDLHwt1xexCqnp0N+TPpPYOedrIpqzmrxUG1RGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CjhB1Rph; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CjhB1Rph"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5aeb59d54b1so1910507e87.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 03:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786789997; x=1787394797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nnQwhiS1oK35ru3NmuwF6q+bn/KVmSxsNWaO1by97NI=;
        b=CjhB1RphM9ezo0NcPkvhuQBWNVzIVWuNWfPfNP3GjToHqK2RDZZ7PbaPw4D1M2rAy4
         mE0aBTmq9Xc6DLH2A70v8vdqtqB+Hr17KAeQqn3GFQJZ7w/do5j4rQd1WwNIWnMOIAtE
         k7zWya5wbp9OIJ80bX6Fu6jkvTbwm/ni0038E8llneHXzGl93FxTaobD28ubyzzSPfj1
         qzKe4ujO8367sFwT5m/b3LjX+LyXkwfQqQpC01uYWeTeQBegv9BTm8Of5zomTEqKKA6u
         q5QSIVTqo5miyZUc81NSOUm3VwIEj6lZ2ZhCu8T4w/FXxZiGih9m+pDIf9zfQ3uhwWv9
         3dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786789997; x=1787394797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nnQwhiS1oK35ru3NmuwF6q+bn/KVmSxsNWaO1by97NI=;
        b=aN7SqcP9NRCNxghRrnpj+XoWngm3YtB0U5N0jl23bU4ODPC+LFPfoJwhGtwEPCOIuF
         4gn59l3mU2J8uKLeoV+qfeA19B/mJOi8oYvOgt7qig8cQOVRqmxSzHbwG5kC2AXFt1St
         vZsNQo5HnQCojLvVVsC7fBuSoWEmqj5gRJ/Ov5yt9DhHW3mGFUAILz6pFo2+PnxbicF/
         ScdjzT5EnwlQGA1ky46Lqr7olF8IB1UrkmTwGQC4a3cxHrkHxN/dqAPweb5Z1ps+WSUV
         Khq0Lb+43RMnYgoo/5nJrGWeoTpUJul2XaJkFI1Y5InheU7+I/ujZ5UaFBc3oZLFvzvb
         2hgw==
X-Forwarded-Encrypted: i=1; AHgh+Rqumm9qKsVZ/WntDVXU2lPeKZ963lMx7iK/sAYqZnndq8AvwZcDLgN4dZTHbOawdE6rD3GrO0ZJ6dSBVhPQlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzzRtUxoV8vQccbUyWfy+YfuN2zpbCEwdG2peyZ6CkWC6Rf2Gkf
	tfaw4i5obY0CJzbOwvYv640meftoNToBMiHb8x3JRJArN7qBLl8oS+uBB/CDd1dP9eupmx0S
X-Gm-Gg: AR+sD10u8V2TjHB/c9qrFmDIsn4HpHED+5Bw16ZSz8iRcyPi9qlnh8k3XvWR2+SvqD/
	DvRfjHiJ2ZIdQpD37PZksl1zfCAwUb7YVjOqOFjGaEJ9pY29z9ezvcOaOz3x/YsarT5QwXrVwVz
	0/OYpQkYZexPHWqoPUi58K/LXICRlA3jwzjccJrHy+skJJSbSeBp0R2YIwsiMr/6H84Pc2Gu6oe
	kI//v4SEteCBqrbHyYtEyfPicykVDW/ZoAIZmPdTM+R3lhufu1Fo3uFKqEffICSFX2gfAohwnJs
	x/tPz1JycwPk+nuZOKrkwPi7d05pVQHZH4+61Ri9SYg3arkB4B9Y8sXLx9wjB5T/WCaDGnMrnRQ
	NWajxINuA4Ye7L4b4yzm/vFus227yQp0dd6Ch8tiUxwlAyOOmbpsDkxvMPmog2X1mwixQIMjk10
	X0BSRofIOVSkfDCD9CQBe9PodkA4ATUrAnBDW3V2kpI/7SK+un+KpGRuzi+FR51v08sdNrM52Eq
	h/+wpvqcJj0iJZ3As+f/TGOsS4uJxRHZIJIbWsquYekPv/p6/+wGmX+RWwx
X-Received: by 2002:a05:6512:32c5:b0:5b3:cd0:6be6 with SMTP id 2adb3069b0e04-5b45914b25cmr2126112e87.54.1786789997153;
        Sat, 15 Aug 2026 03:33:17 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458b9a964sm1109010e87.1.2026.08.15.03.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 03:33:15 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Cc: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH wireless] wifi: mt76: mt7921: fix array-index-out-of-bounds in mt7921_load_clc()
Date: Sat, 15 Aug 2026 15:33:12 +0500
Message-ID: <20260815103312.34080-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7921_load_clc() walks the CLC region of the firmware image and uses
clc->idx, a value taken straight from the blob, as an index into
phy->clc[] without validating it. The array has MT792x_CLC_MAX_NUM (3)
entries, so a firmware image carrying a section with a larger index
overruns it.

linux-firmware 20260810 does exactly that. Dumping the CLC region of
mediatek/WIFI_RAM_CODE_MT7922_1.bin before and after the update:

  20260622, region len 366448:
    idx=0 ver=1 nr_country=255 type=0 len=179384
    idx=0 ver=1 nr_country=255 type=1 len=187064

  20260810, region len 475488:
    idx=0 ver=1 nr_country=255 type=0 len=179384
    idx=0 ver=1 nr_country=255 type=1 len=187054
    idx=3 ver=1 nr_country=0   type=0 len=54520
    idx=3 ver=1 nr_country=0   type=1 len=54530

and UBSAN reports the overrun on every probe:

  UBSAN: array-index-out-of-bounds in
  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:471:15
  index 3 is out of range for type 'void *[3]'
  CPU: 19 UID: 0 PID: 261 Comm: kworker/19:1 Tainted: G     U              7.2.0-rc7-2f1baf1fc892-with-fixes-v1+ #125 PREEMPT(lazy)
  Hardware name: ASUS System Product Name/ROG STRIX B650E-I GAMING WIFI, BIOS 3854 04/03/2026
  Workqueue: events mt7921_init_work [mt7921_common]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x84/0xd0
   ubsan_epilogue+0x5/0x2b
   __ubsan_handle_out_of_bounds.cold+0x4e/0x58
   mt7921_load_clc+0x826/0xb80 [mt7921_common]
   mt7921_run_firmware+0x113/0x180 [mt7921_common]
   mt7921e_mcu_init+0xba/0x18d [mt7921e]
   mt7921_init_work+0xdb/0x3f0 [mt7921_common]
   process_one_work+0x901/0x1640
   worker_thread+0x601/0xff0
   kthread+0x36e/0x470
   ret_from_fork+0x5bf/0x910
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Both idx=3 sections are read out of bounds; UBSAN deduplicates by
source location, so only one report appears. Booting the same kernel
with linux-firmware 20260622 is clean, so the overrun is only reachable
with the newer blob, but the missing check itself predates it.

phy->clc[3] aliases phy->chip_cap, the u64 that follows the array in
struct mt792x_phy. The report above is the read in the "do not init buf
again" test. mt7921_mcu_get_nic_capability() runs before
mt7921_load_clc() and fills chip_cap in from MT_NIC_CAP_CHIP_CAP, so on
this device it is non-zero, the loop takes the continue path and no
store happens. On a device whose firmware does not report that tag
chip_cap stays zero, and the following devm_kmemdup() stores a heap
pointer into it instead, enabling whatever MT792x_CHIP_CAP_* bits that
pointer happens to have set.

Skip CLC sections whose index the driver does not know about, so that
they are ignored deliberately rather than by accident. With the
firmware above this is not a functional change: the idx=3 sections are
dropped either way. Use continue rather than break so that known
sections following an unknown one are still parsed. mt7925_load_clc()
has had an equivalent check since commit 9679ca7326e5 ("wifi: mt76:
mt7925: fix a potential array-index-out-of-bounds issue for clc").

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---

ARRAY_SIZE(phy->clc) is used rather than a named constant on purpose.
mt7921.h still carries

  enum {
	MT7921_CLC_POWER,
	MT7921_CLC_CHAN,
	MT7921_CLC_MAX_NUM,
  };

whose MT7921_CLC_MAX_NUM is 2 and does not match the array, which is
sized by MT792x_CLC_MAX_NUM (3) in mt792x.h. That enum is otherwise
unused except for MT7921_CLC_POWER, which happens to have the same
value as MT792x_CLC_POWER. Removing it is a separate cleanup.

The two idx=3 sections add roughly 109 KB of payload that the driver
now discards explicitly. If mt7921 is supposed to consume them, that
needs a MediaTek patch adding a fourth MT792x_CLC_* entry; this one
only stops the out-of-bounds access.

Tested on an MT7922 (mt7921e) on v7.2-rc7 with linux-firmware 20260810:
the UBSAN report is gone and the regulatory domain is unchanged.

 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 25b9437250f7..1b147b492b9f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -467,6 +467,9 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
 		clc = (const struct mt7921_clc *)(clc_base + offset);
 
+		if (clc->idx >= ARRAY_SIZE(phy->clc))
+			continue;
+
 		/* do not init buf again if chip reset triggered */
 		if (phy->clc[clc->idx])
 			continue;
-- 
2.55.0

