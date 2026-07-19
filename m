Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758323B14C7
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484054; cv=none; b=KDYTAm/VYE25+g43lfx7yb86NAEZ4ex0EtjWOqvvbc8kUKcOM6eCZZPljiKkg+yq4VDuu22YtmEzfteA3TpWkdKA6LCG1ATrghj2jHtbhrKXekNnJeayNy2n/ntEDpvDWsznsppFQwaTXDcsagWRarBRAmLK6jKItZ7k81Mwvo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484054; c=relaxed/simple;
	bh=G3XTMawG4mmnQYczrpaA3wH+5U16UOYFHdL/VtiAcQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNeRYt3zwzZ4bm9Fjqd8ZSq82s4ouezGWBev4H+TagmDJA+lxSHyLjij0klKZ2sYhjsTZ7S+XAJu94nr3vZImn7KSLJicL41JD1Ib5h3ZhGfcQh/Yylv4ChCZFm5/q/9cQ5tvnOv2CORynBogoQXs9YlawvEB6+5R+GL6C2461A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZZXkg8us; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZZXkg8us"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784484038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8ocgJyJLsoxhXvM3KkfhNJ00LhsSmtx5q8OdKXpYbDA=;
	b=ZZXkg8usUtHTlT/ibXeUvmQsuq+lgHz/FCgXKx1waFHFSUeX0K1QUWQ6YdHd+a9V5s/Lvt
	DUtaxPgRhqZKcrnBGT8nOS2qk11GUcRlAkWWBnJNs+/svhlhtGoinVxUS/gS6WPNvOOtBI
	Q4r8U4pIbhAYBiT1bgAPR1BA5HLwz0E=
From: luka.gejak@linux.dev
To: linux-firmware@kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	luka.gejak@linux.dev
Subject: [PATCH] rtw88: add firmware v41.0.0 for RTL8723B
Date: Sun, 19 Jul 2026 20:00:33 +0200
Message-ID: <20260719180033.66867-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

Add the RTL8723B NIC firmware image used by the rtw88 driver. Support for
the RTL8723BS (SDIO) device that uses it is being added to the mainline
rtw88 driver.

The image was extracted from the Realtek "rtl8723bs" vendor driver,
version v5.2.17.1_26955.20180307_COEX20180201-6f52, from the C array
array_mp_8723b_fw_nic[] in hal/rtl8723b/hal8723b_fw.c, using the
convert_firmware.c tool. A public copy of that vendor driver is at
https://github.com/MocLG/rtl8723bs-5.2.17

The image reports version 41.0.0 and is covered by the existing Realtek
redistribution licence (LICENCE.rtlwifi_firmware.txt).

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 WHENCE                |   1 +
 rtw88/rtw8723b_fw.bin | Bin 0 -> 32272 bytes
 2 files changed, 1 insertion(+)
 create mode 100644 rtw88/rtw8723b_fw.bin

diff --git a/WHENCE b/WHENCE
index 6cfe142d4e91..b4b7e6acda1c 100644
--- a/WHENCE
+++ b/WHENCE
@@ -3352,6 +3352,7 @@ File: rtw88/rtw8822c_fw.bin
 File: rtw88/rtw8822c_wow_fw.bin
 File: rtw88/README
 File: rtw88/rtw8723d_fw.bin
+File: rtw88/rtw8723b_fw.bin
 File: rtw88/rtw8821c_fw.bin
 File: rtw88/rtw8703b_fw.bin
 File: rtw88/rtw8703b_wow_fw.bin
diff --git a/rtw88/rtw8723b_fw.bin b/rtw88/rtw8723b_fw.bin
new file mode 100644
index 0000000000000000000000000000000000000000..2058fda105c4b8ec86c2836267e7ec817847f404
GIT binary patch
literal 32272
zcmV+re(!++QxE_t00007B@{#OeE<L&H2?qr000000000000002Mk)e;EdT%j00000
z000000007kPXGV_00000000000007jVE_OC000000000000000000000000000000
z0007jhyVZp0007q=Kufz0007z1RwDK4*&oF5AY8F0000F@c$10000m04*&oF01)v1
z4*&oF5bzHG0002>4*&oF008h00000001W^D000005b*#10000G@IL?m000ID2nh-c
z3=IwrGBPAGGDAy4OG8UpGBQI;LrYm&GBPAGGDAy4OG8UpSXfwCSXfwCQd3k_Q&d$}
zS6EqER##YAT3cLQ00001000320RjR8009930RjR80RaI40RjUA1qKHQ0RjUA1qKHQ
z0t5&U5EK|393UVd5EK|393UVd0R#dB1Op5N3<CfF0RjO50s{mF2nhiK0|W*L2?`ko
z1OfmU000000000000000000000000000000000000000000000000000000000000
z00000000000000000000000000000000000000000000000000000000000000000
z00000000000000000000000000000000000000000000000000000000000000000
z00000000000000000000000000000000000000000000000000000000000000000
z00000000000000000000000000000000000000000000000000000000000000000
z00000000000000000000000000000000000000000000000000000000000000000
z000000000000000000000002OuYmqC5<--P&<l0Y2&&-1jOB_XXZ4EZj5K-mjM9wk
zB!~FsyaEDr|HGAmv_Jqr&UpiPfEMNma0|k(<}l#{L>TtcuL#-g>Wk1K<qZELB!T!3
z2nfFe1b+Z{f#xve@&M%w!=F$f1q^hCB@FoH{icBk=B^CB0s?gZ&G_hTVBiSmz~F%P
z<qXrGKquu4B!~Fst_;2c0(AfV80O9R<$-Nr2GHR47=ZQV3?zog_7x0()8z~!B!T#U
z1j4W8FyI3a;tYQPFyRL<;{<;QRP<DQ#?r4;fI<f%c!s8dbOK-o{|I*f-}`?9<amJg
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

literal 0
KcmV+b0RR6000031

-- 
2.55.0

