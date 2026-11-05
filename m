Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878471;
	b=4JNHNALjU5k/sIiEq4nrkyzwdsbHKO/ho/6tE7eyOz0gaS39DGjyYkhihldQeJvmMlXf
	 wGb19v12pLAf1H8LLndHPG0x0yghsjIGkBJooAUEclOlDKvr1lksFEww/UioauI8BXOv1
	 0uI1zHLlYFaOYGIkk5GoyumiPBPaJguOLFohq0/O0rA6RP4HjtwViaFhXzOavNsTa2EjZ
	 klmEQqtvJ73lJqZczNLrYk7Q5LzsufjiIgI9qQX0XQBaPSFZbUYPE2tR0S032JA9U39QU
	 yHYVTTmq7C+WoEycSSa+2MDsxf+LH7meejdym/m7NWzmI4H2kzlQXBGAVRWB5Zx4Ocw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=CXrtTBx+a4X/k35p2Uw2VQsDm5Z23/q5WwwDTwCTBVg=;
	b=5p1lsq2pVo4P3j53EafvzgFZ+PEs+9jiPnOckVGIVijIkKmNPpqhs9CU+OGnLvnbsVgl
	 9Ao3zxyHRUvFmUXjvGPNSX09GGpqSczmerrFzSrlU/FCYE4rPuetTeZ2FxrtATm3NqaX6
	 M+Hp0F5cxLr75ZyH2KP7Wj9sP3uDYRZ0A/Ft9z6QW7v/WQx1lv6jReFwDYZE9RaLNtKry
	 +FDWnytTQvLarXIePhE7yEtaIDBATYgPfHpQia1fys/a3HgYJ9KQLU+h0DABc8nEtU4rQ
	 iLmwNSJQBs9vE/MAtDFsf1ZNtgH5dgIOcvUQnGpVQatIhx9Jz+hpCGURaBbYWx3tDTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=An6tqgxC;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750F606A31B
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 11:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E750F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=An6tqgxC
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed1f1a7695so4844645ad.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2026 03:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793878470; x=1794483270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CXrtTBx+a4X/k35p2Uw2VQsDm5Z23/q5WwwDTwCTBVg=;
        b=An6tqgxChaEBVq7vuQ+Z/MoFFyW8/wI5Wb7tzvjEgU24XVodJklHvLHmoKgM3rq0Pm
         nRt0L9SWDioNImukqJo1qytDRxRP8EXR8sRtkRT9jqEPEJnbxha+qpuDJU8z6e5OSdna
         t+iHRTHK+rpYbuD/YSbead3Ut0s1FcvFUdPNz/Vi1VugLNeHsHmU1wNYLlQTa8nG15DU
         CkMQaDm9e9wXOjCxdLznKC6rbbsi8AQNOpJQ0u4FWCIdHKVsID1IbSG0oGsTxvA2YLl0
         QMGC4Thfiu8kIstw/cn+aNCQLGG6w6/AZzX39APUCYJgufmM0bvO3ExrW3GjiMby6atN
         21ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793878470; x=1794483270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CXrtTBx+a4X/k35p2Uw2VQsDm5Z23/q5WwwDTwCTBVg=;
        b=FPeHlaAGHNfgMxEihtnYi+r1HDvSZVaRegIrrki/n6pxVu9fJ8mFE9yMfVomO5ThMH
         oaOLB9cPsVKyE+z/xFHyXu/4jx9FN5LsKRaENiIGdsV+Vw9So30XhFc//88No1gQI9/e
         NRaIqcqMLwQn9WnXwxs+2CVOCKVAk4yu3JcXnVSf3bkYZpzgU0asNKsxpD/k0HEOfywg
         zvqf8g+WeWCmrbS6h58CATafCZNwyxHDwUiOxBxid0nv0fQPtY0JhNElsyDOD2PanRQQ
         yv9jrfZT6OhgaoQKRm6vZuzJiTi/5KToO6CyGbV/TSTBwfq2ZXoel4q0GI9ybhiDfm/N
         2VkQ==
X-Gm-Message-State: APuU4Z86tk8fIP7UdNTHWb3NN6y54DK1y7EcmyocyXkh5/A3Mtx7W2eS
	0mEHm4HbT7qxG0HKwZor8BkW/BJQnJLHE+bf3+9LjoP3m0aqFTB4VZLBusHhkw==
X-Gm-Gg: AYBFou20cehQ1HqKHB6EeOxjXS3N9lqbDzSo6npxV4xCjUBzqxbUOJsGuMG5TvKq1w5
	t3ubHvWNx9x+5SHCXMzV0zbme3QdIzcYTN6Tss5kjWgwtJQMNn3ZRoo2WhZ7eOdo2LpOM/iNB/o
	9oZp69A+s2DC8gknt6NjqgxKj+aDqL/H3Ya3R1Bd9SLZ5/Y3y27S5DYl/5DwKWXzAnPFID/7KAd
	NIV4/N3GKr2G+04RiXzq8g6tBcJMO5VyUeDPF9ZNoAioyxdovNHn60BgtAhehCHCEw/oOEslgd5
	T3JiQO+CKFcIEhdW1aMybZssXxW76s+wM0njNE+0Kd5QdSozS4G/u3+L4wqlfBfy8lNQPrAZnm3
	PLY8dbeGbhSXvC+T0U5NcxxSvPJlSR9uM7pUmLJIpodzPdUR+LdHVaj60J3vOAiSq67B6ijpmDz
	YL5yIuNjVf1hAXf0ew9sCgVVxdTPDnPnJq1u/A8tTwJ8qDaymKEE9/t/U++hXxY1SFWCSsSMxVv
	WPakRqjXtgRQqQ8FMcSa6vniJBqYGeO8J259a5GVfg8u1oqV8E1RR/nMSbQF7NEAvYcvaZAegod
	NHf2C3+XibuMAKd0xHm785UGD1Zl3HwNO7ngS97mlukbnaSTM9CtaOQYNn2N9BW9IMu2Rtvp4P2
	T1rE0vt2U7h527Ao4dmFZuxevRMuuvA==
X-Received: by 2002:a17:903:3c43:b0:2e9:5eee:e078 with SMTP id d9443c01a7336-2eb363961f4mr159600355ad.3.1793878470038;
        Thu, 05 Nov 2026 03:34:30 -0800 (PST)
Received: from localhost.localdomain ([2401:f40:1397:9:1002:2bec:4a9e:c463])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed183dcf6csm12111645ad.38.2026.11.05.03.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:34:29 -0800 (PST)
From: Zeshan Ahmed Nobin <zeshanahmednobin@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH rtw-next] wifi: rtw88: 8822c: fix out-of-bounds access in cck_pd_set
Date: Thu,  5 Nov 2026 17:34:14 +0600
Message-ID: <20261105113415.73184-1-zeshanahmednobin@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw8822c_phy_cck_pd_set() reads the current bandwidth from a 2-bit
register field (0x9b0[3:2]) and uses it as the first index into
dm_info->cck_pd_lv[2][RTW_RF_PATH_MAX]. CCK PD only runs on 2.4 GHz,
where the bandwidth is 20 or 40 MHz, so the array has two entries.

When the chip stops responding on the PCIe bus, register reads return
all ones and bw becomes 3. The function then reads cck_pd_lv[3][nrx]
three times. rtw8822c_phy_cck_pd_set_reg() rejects bw with WARN_ON()
and returns, but the caller still writes new_lvl to cck_pd_lv[3][nrx],
past the end of the array, into the fields that follow it in struct
rtw_dm_info. Depending on the byte read back, pd_lvl[cur_lvl] and
cs_lvl[cur_lvl] can also read past the end of the on-stack arrays.

On Ubuntu's 7.0.0-42 kernel, whose line numbers here are three lower
than in mainline, each chip failure seen so far logged one report for
each of the three reads, then the WARN_ON(), then one for the write:

  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4407:21
  index 3 is out of range for type 'u8 [2][4]'
  Workqueue: phy0 rtw_watch_dog_work [rtw88_core]
  Call Trace:
   <TASK>
   __ubsan_handle_out_of_bounds+0xdd/0x120
   rtw8822c_phy_cck_pd_set+0x33c/0x510 [rtw88_8822c]
   rtw_phy_dynamic_mechanism+0x310/0x330 [rtw88_core]
   rtw_watch_dog_work+0x217/0x330 [rtw88_core]
  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4410:24
  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4413:30
  WARNING: .../rtw88/rtw8822c.c:4364 at rtw8822c_phy_cck_pd_set+0x322
  UBSAN: array-index-out-of-bounds in .../rtw88/rtw8822c.c:4422:20

Return early when bw is out of range. nrx comes from a 2-bit field and
always fits the second dimension; it is checked as well so that both
indices are validated before use. The chip is already unusable at that
point; this only stops the driver from corrupting its own state.

On the machine below, every boot with a chip failure logged these
reports together with the WARN_ON(): 17 boots between 2026-10-18 and
2026-11-02 on Ubuntu's 6.8.0-147 kernel, and 3 boots on 2026-11-04/05
on 7.0.0-42. Boots without a chip failure logged neither. With this
patch applied to 6.8.0-147, 5 boots with chip failures logged no UBSAN
report and no WARN_ON().

Seen on an RTL8822CE in an ASUS TUF Gaming A15 FA506IU whose chip
intermittently drops off the PCIe bus.

The problem was found from the UBSAN reports above. The analysis, the
fix and this message were written with the help of an AI coding
assistant (Claude Opus 5.5 by Anthropic), then reviewed and tested by
the submitter as described above.

Fixes: 479c4ee931a6 ("rtw88: add dynamic cck pd mechanism")
Cc: stable@vger.kernel.org
Signed-off-by: Zeshan Ahmed Nobin <zeshanahmednobin@gmail.com>
---

Notes:
    Tested only on Ubuntu's 6.8.0-147 kernel with this change applied. On
    rtw-next (dc16902cad9c) it is build-tested only: rtw8822c.o compiles
    with W=1 and no warnings, before and after the patch.
    
    On the AI assistance: I asked an AI coding assistant to help find out
    why the RTL8822CE in this laptop keeps failing. Over several sessions it
    analyzed the kernel logs, found this out-of-bounds access in the UBSAN
    reports, wrote the fix and drafted the commit message. It also checked
    the code against rtw-next and recounted the numbers above from the saved
    logs. I reviewed the patch and the message before sending.

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 09315d23e2c4..a29611ff248d 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -4406,6 +4406,13 @@ static void rtw8822c_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
 	nrx = (u8)rtw_read32_mask(rtwdev, 0x1a2c, 0x60000);
 	bw = (u8)rtw_read32_mask(rtwdev, 0x9b0, 0xc);
 
+	/* cck_pd_lv[] only has entries for 20 and 40 MHz. A chip that stops
+	 * responding on the bus reads back as all ones, giving bw = 3.
+	 */
+	if (bw >= ARRAY_SIZE(dm_info->cck_pd_lv) ||
+	    nrx >= ARRAY_SIZE(dm_info->cck_pd_lv[0]))
+		return;
+
 	rtw_dbg(rtwdev, RTW_DBG_PHY, "lv: (%d) -> (%d) bw=%d nr=%d cck_fa_avg=%d\n",
 		dm_info->cck_pd_lv[bw][nrx], new_lvl, bw, nrx,
 		dm_info->cck_fa_avg);

base-commit: dc16902cad9c6b08df9395a510c7be44fbab545d
-- 
2.43.0

