Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649823;
	b=X06Vsq0EFzIBvYlo50ALxvuKhWF9Mdl+R29Mc/fl8Yr0wZfgyL7e1sd3d/qW+CvwQgj1
	 tjHQdODBye1evzr1zMSthNuV9uZNAeLvMY3syVuugecNCQRb9sdmYew4P42ulPAeEfZ7N
	 cX4bWDDqBc8XASaOK/dmVh2IXbTHXqMQVtqRVV+q9kjpEoxnBIXgWLpEYolu/UVVpt1/W
	 GkC0idgEgIZq5iBm5HPwdR83uSp74EM3pJifDdfInMuM6RF2+ePGDgUrHrMi7gcb0nYNN
	 L6FbEu3LeV10v2MoPUrWUwV8WjIFmc3r34SX5TfuXFAmm1CDI+pVfotA/tVhmznP/BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649823;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sJefuJOTT+32ADCOSJyFHXhfGqO6ALajK8RP+bOVKgs=;
	b=USMpY86NvaG5mvtJi3dcvRHvU/f0n1h+75VY51mkVv5WhRxwB+DmUq84WH6/9CAa+/+h
	 GWaKoVDv2FLuW4O8ixzmxJB62iFz23dE+OsSmvvtAcOeTWPgguOUWGtyJ3tz+W0+rA6fy
	 ThZ96k3YgjY7ERZ4ioHuK3jjeiwV1xKrnRRWAXQdoPC4jeq0JSc7c2WrYNvpQp+TGA7Ni
	 yYdqgBuZwDChuTSEnSEEW7HP/9sn13W4edHzPIACsajvrrbcGvDMGl55L+5b7I+uaWeGI
	 iSbTZpDh34S82nszfKqOgQGNk/P9Ajf55On3+GmNBs3LgBRDOGw3VwrgvMwiVjtx7fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AhdweSlQ;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA93606A33D
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AA93606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AhdweSlQ
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so3527483f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 12:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793649821; x=1794254621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sJefuJOTT+32ADCOSJyFHXhfGqO6ALajK8RP+bOVKgs=;
        b=AhdweSlQOnH/Y+sDrNV2/SSWEuIhvTxCEdRh4xZ17i/CyVLecFZmmiro+UbGpCgkJh
         OpCU7cpZjbc5ZgR5TNXBk3OSvOHIdW0UOwS6CMJw4fo8/VUB5hOLFZ98f7QM2Miq/32w
         Ztlz+C5TMHSBmr3dPkRz2vms9wcqJ5t02UWkENHI7YT4qbZgcn7dXJlicwuFhDSENNrW
         jNHj3lFlaJ/OkHqZJRdoddZuNnrNi3PWLgr0D0qsMArjHUyevwStpAy3DG44lSt18VsA
         pSeqa5zGy8438lwThe+mbHuDX7dNFYO/W5VqG01b6tMYTObIxnNccygZ+pATQekQUKDK
         qNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793649821; x=1794254621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sJefuJOTT+32ADCOSJyFHXhfGqO6ALajK8RP+bOVKgs=;
        b=VVWgRoHUeRptIEYIMeL/qHTMV59ZRId2D2uychMvdT9Isgj75j8OSBvdaLfCF7Y/5b
         tq2XEw/juyRce6msCMwY4KiO0rU3jlQch0i1rkY9aRHFJoHjDlVfs9eXxUKqUyVN+PmJ
         nV2wf3oocAHs14/L3ni8aJhCalb/ZxCd3kICuIFUaGIqUCIGdujfuailxddKM2+VpOfJ
         rCYdZb6nhakojQz/vYF2sim/jIBt/hVPB4mCdkdkp/GBAa7FoygmE422xP50cb7o1r8F
         msH6AE6vMGuvGj1rJrhCxAMyr5QrwXqY+RTgANdD5EmpEG66ZDsrOkDKBqxOOmbqUcb+
         pPlQ==
X-Gm-Message-State: APuU4Z/zuHxeYY7lo6luXCncb4rEasGTMBxXRDFwgSQGwwPkjW5IouDB
	B74sL9CYCaluau+SnPs+YLr7h/bQelzT4dJ+EkQ/P6YCdvC1xKLWM3qr
X-Gm-Gg: AYBFou3ppwM/+ZfL+YS5YhUszrC4RVR4LtgLxBhfJa953aulI4hQwiSCooZM1ENvLhG
	f3kqdJMFKHpVsiyxPnceRc1vl5EaOyu0xXIvtGomKKOfSPlAi4KmnKgka4lLE5nzGHxx+5hXZhS
	eapqLgFlbvK+55O5FdMmK9/sYzQVkDDWsjHrqUZ65Q8qS/uz/eoRCoehhIkv8Kja/o7zvsDf+gS
	IPpMbduExAGOC3VcB0rY3ggr5c+fRZ58FpjMhciXelWzLFQwNQGeZJnKnDJEvo2MTp25lLbuEoc
	WuXQ9aw0xZp9L7BR+DUV1UWrDb4ZSTmLdQY31/fsjKvJVRkQu1Z2JvLUqkwoPphi9KJNz6SsUEq
	dCKp8u/p6/wGXh7y+tUxmtaJv3pj56yV37hV7ETgx3Dl+VBemMu7l0qbXWSP5OOmpyYH5dfcYd8
	vRN7D/Ko6eruaVMjio9AUu4Nfq6vmveGorgYckqP7XKrSXGkB/gr/mmhdaAmNytIP/YI6e05sMN
	Aw5R8jOhejlbtJnCBZuB1R0XNibMeD/4DWNDEeldFgXibmIsyn+RkGOnTqfXDhIGXCrCIXe7avB
	teClC3vDb/6XkPhhhqgtTSiCswLJPGvUUZWPn+TDcLXWe5NxTbIYrV6j3RyvtD8pZSVaOiK7+NE
	7E8Ri9a1gWmVBByfq1tAC1CvtosN90jDbQGQ0Oa74g3IQBcfb1kXWLH/JrAgnK8Py0/SHRuCX5A
	4N1NTAxEkQw8g=
X-Received: by 2002:a5d:5f56:0:b0:48e:60ed:b017 with SMTP id ffacd0b85a97d-48e6e302ab0mr23631665f8f.20.1793649820578;
        Mon, 02 Nov 2026 12:03:40 -0800 (PST)
Received: from ADM-D9YH122JTV.home.lan (158-199.dsl.iskon.hr. [89.164.158.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm21191574f8f.47.2026.11.02.12.03.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 12:03:40 -0800 (PST)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: [PATCH ath-next v2 2/2] wifi: ath12k: skip unknown direct buffer ring module IDs
Date: Mon,  2 Nov 2026 21:02:35 +0100
Message-ID: <20261102200235.48973-3-gsustek@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102200235.48973-1-gsustek@gmail.com>
References: <20261102200235.48973-1-gsustek@gmail.com>
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

QCN9274 firmware WLAN.WBE.1.6-01243 advertises direct buffer rings for
module IDs 2 (CV upload) and 3 (Wi-Fi radar), one entry per radio.
ath12k_wmi_dma_ring_caps() treats any ID at or above
WMI_DIRECT_BUF_MAX as fatal:

  ath12k_wifi7_pci 0000:06:00.0: Invalid module id 2
  ath12k_wifi7_pci 0000:06:00.0: failed to parse tlv -22

It frees the capabilities stored so far and aborts the parse of the
rest of the service ready ext event. Initialisation continues only
because the service ready ext2 event completes it.

An unknown ID is not an error. The firmware uses a direct buffer ring
only after the host configures it with WMI_PDEV_DMA_RING_CFG_REQ_CMDID,
and the host does that only for a feature it implements. Skip unknown
module IDs with a debug message instead.

Store the accepted entries contiguously and set num_db_cap to the
number actually stored. ath12k_wmi_alloc_dbring_caps() zero-fills the
array, so a skipped entry left in place would read as a spectral ring
with zero sizes. No code reads db_caps today, but a future spectral
user would.

This follows Nazar Mokrynskyi's earlier version, with the separate
count of stored entries that Jeff Johnson suggested in its review.

Link: https://lore.kernel.org/linux-wireless/20260505172415.566328-3-nazar@mokrynskyi.com/
Suggested-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Signed-off-by: Goran Sustek <gsustek@gmail.com>
---
v2: commit message reworded (firmware behaviour, credits); code
    comment corrected.

 drivers/net/wireless/ath/ath12k/wmi.c | 43 +++++++++++++++++----------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index f41138a7c68e..c5ff5b4d9141 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4988,8 +4988,8 @@ static int ath12k_wmi_dma_ring_caps(struct ath12k_base *ab,
 	struct ath12k_wmi_dma_ring_caps_parse *dma_caps_parse = data;
 	struct ath12k_wmi_dma_ring_caps_params *dma_caps;
 	struct ath12k_dbring_cap *dir_buff_caps;
+	u32 i, n = 0, module_id;
 	int ret;
-	u32 i;
 
 	dma_caps_parse->n_dma_ring_caps = 0;
 	dma_caps = (struct ath12k_wmi_dma_ring_caps_params *)ptr;
@@ -5015,26 +5015,39 @@ static int ath12k_wmi_dma_ring_caps(struct ath12k_base *ab,
 
 	dir_buff_caps = ab->db_caps;
 	for (i = 0; i < dma_caps_parse->n_dma_ring_caps; i++) {
-		if (le32_to_cpu(dma_caps[i].module_id) >= WMI_DIRECT_BUF_MAX) {
-			ath12k_warn(ab, "Invalid module id %d\n",
-				    le32_to_cpu(dma_caps[i].module_id));
-			ret = -EINVAL;
-			goto free_dir_buff;
+		module_id = le32_to_cpu(dma_caps[i].module_id);
+
+		/* Firmware may advertise rings for modules this driver
+		 * does not implement. It uses a ring only after the host
+		 * configures it, so skipping the entry is safe.
+		 */
+		if (module_id >= WMI_DIRECT_BUF_MAX) {
+			ath12k_dbg(ab, ATH12K_DBG_WMI,
+				   "skipping dma ring caps of unknown module id %u\n",
+				   module_id);
+			continue;
 		}
 
-		dir_buff_caps[i].id = le32_to_cpu(dma_caps[i].module_id);
-		dir_buff_caps[i].pdev_id =
+		dir_buff_caps[n].id = module_id;
+		dir_buff_caps[n].pdev_id =
 			DP_HW2SW_MACID(le32_to_cpu(dma_caps[i].pdev_id));
-		dir_buff_caps[i].min_elem = le32_to_cpu(dma_caps[i].min_elem);
-		dir_buff_caps[i].min_buf_sz = le32_to_cpu(dma_caps[i].min_buf_sz);
-		dir_buff_caps[i].min_buf_align = le32_to_cpu(dma_caps[i].min_buf_align);
+		dir_buff_caps[n].min_elem = le32_to_cpu(dma_caps[i].min_elem);
+		dir_buff_caps[n].min_buf_sz = le32_to_cpu(dma_caps[i].min_buf_sz);
+		dir_buff_caps[n].min_buf_align = le32_to_cpu(dma_caps[i].min_buf_align);
+		n++;
 	}
 
-	return 0;
+	if (!n) {
+		ath12k_wmi_free_dbring_caps(ab);
+		return 0;
+	}
 
-free_dir_buff:
-	ath12k_wmi_free_dbring_caps(ab);
-	return ret;
+	/* count only the entries stored, so no zeroed entry looks like
+	 * a spectral ring
+	 */
+	ab->num_db_cap = n;
+
+	return 0;
 }
 
 static void
-- 
2.56.0

