Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398122;
	b=vYjrFX+JpJytyAgoQQQc6fS5bWu7Zj9V4OiMie9KdgCUSRdVa6ouroG5CQP3ckwkTlsw
	 ke4GOZc+2q+t74ow2VNM2w1IpYzkK9RDlbfJ4J63Q3NoRyCyJnwy4K0cQJzlpFIqIOHO0
	 ViiazKInC/sZiHoKWBYskdzmeXhTVP/yEdOYZ91ZZsdHUvMPBECS+Lpgi9gpWHSaxiJVl
	 NkZZuBImCtcDUJtdsKz3+/hTY7N3fn2mFdGPtlAMYPSXcYRJIqZA98FF1Bdx+CYinXeA8
	 gZ8ktdcE7Tudboz+wxjcQ/s1AxVi7iQlX7c5SeAJFmrDarNiHoedekb2aKWgAShVuJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398122;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Pye18a12Mt0GkSw7sJj+cBOXoMwNJjFwpHtVV9nHTBQ=;
	b=aQvBSQd+FTyIrR8ljw/NU6WZ/XNAUE4ajxKKGjL461g6hwG2x4TPMDqItlCQeCr86mbO
	 101gUsS5snmHhdEBq3b+6NJ+Z0uAz42uEoKYvYbIF3Itrh7ei9LFlpGmm84woeKd04lb0
	 OTO+eAZ80GZu+0YQY0My8S0mcXSRoTTa2RJIr66HSdAM+GUqW+DMJZKvTD3Rk1AP+LET5
	 CqNvSB2M4/jhQ26dYwG/FkiKXExfgRBKsprQcH4jCAp/JLMm3VKRdj62mm8qVo+GlUNuz
	 pVJCA1kF2i1Di709i6ufge42w7D11IxFRN+6tk2LsfxbLDHUmTwmvL1D0b4VVftZU/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MnmewSsL;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D405606A32D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 22:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D405606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MnmewSsL
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so7341955e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793398121; x=1794002921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pye18a12Mt0GkSw7sJj+cBOXoMwNJjFwpHtVV9nHTBQ=;
        b=MnmewSsLup4jlaPeETsaD4WcEc8i49f0eTqi+NUjJort1TS9RcvTFCS6TnaAHWFusj
         au5Lw8wH0pI2S1at1Chtr6IOZjdv82hTevEf0vHgEiVQGN8V9MIPyemJ4sTVBqRqOBZF
         r+wQvWIzQVQ9qQ+OWwlFCEB/QhZFAjMmdB9HQPjpQY7x94EQwNFOnUsSMKCoXco0nqMW
         oFFVrAm3lLLZb86wRc8hRoMTZ/MMl6NtPX1quYSovOko/Rs1+XnY4gIwVC3PWrpJKill
         XaDWvQlhk2u6t5ywP7aZ1P3gWQo5IibMMFdsYMUv5q/zd45E++Bp6sISwlSn84O1BNsd
         +82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793398121; x=1794002921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pye18a12Mt0GkSw7sJj+cBOXoMwNJjFwpHtVV9nHTBQ=;
        b=nxrFP2OdFikL08gxAoH0sBCbTwqrocK6K/mO8esPGBCMdT1G0m+RQDm4d4uqAcdatI
         uNItkgLmMv8l2PYlqj0WgIbWLDLuchQv1fEQD5I13V4hUZdnFiTzDB3pGU7y4iyDZ9bX
         +w32IR90nsvi30fYU9CJW7rEvlVGnzllOI4KScrW+xLdwH+ml1QKj2reixz8ZJSnvizc
         obIsITITcfv+AOlXzt+xWIXEJ3U4tab2bI4kOCs0XTTwL7MsNco+4e3fOmLPu2Iico+w
         1QblpkB+x4QlNzOAQ80qMERD7fnesrpm7Q19cQ1VRpuslydw6+eAC3D4ECwbMBWu8BIb
         EbFA==
X-Gm-Message-State: AFq9FYJaD/KfJ2MyZY9LdfD1GX2vbYezwQmRwpjLaT1p+25iIhr0EH29
	Fya68HfHU4RJKCtkQTfm4CD8PCOl1P3d8WTdV6+NKgmWantDsrXTnqMx
X-Gm-Gg: AYBFou125VbOLZ+Ok9UWjz/GUEob8z8iqDIjgXIPzz2jfFb9JUGm/swQHw1GvX0awYn
	nqK/9mmpBe+ykwZ/B0Jsf9wvW1wpyLiCWg5MczuukYeZCffV3Zq5uLgLcjnb8JO1OeUcHygE0av
	KCzwjLjutGOwdnjDodjGjlR4sA3JjRpXPKtY3jPxaxN8UtKbUWYmCAY/0811kZ6GL1fDcNGZT1T
	ILUOiBVYqiXOVLGgbKPDztQot09Sf0isJ4VfNe9PGPLlR8rCGSHUtju1Dy37cS16ZIFIILeJmhz
	EorIgWZqJITIGxfrNtcny1kfS/lzGA5IW8s6FtgAOSTuAc7ktDkrpt+HhZlsJ5XnMLi0SEmu7e/
	3sk52RjUdi3ix5CteixFPbQUJFOH2hz90BdOdlTqnKAWGg/g5A5gI1Bql63yX0qmceQUZ6BdjUc
	Ep3KDojxL0uYM07Q/1zpQTh+Lcr9DJq+gzNBxGDvLAKkHuxkc6FNjeVahKFh6qEQEuDC8EzDHKp
	iyEYjcZgYsl8UQRknawGp7PeECMsRbqLPnAVo1uarR2I1glAia2qVsbpbppOiIXla88Xs8GStja
	6nKXtVlGsckHRIsj1t7m5uEhy4pPHu5mH/EyEALXLcbGz46PHjQnYWClxXOAK3M7hGUkpYR2OFI
	3j480dVgF8mB+1FLW+ODmsJd6h54DDFbTtsyjsuW8TbajBZeCbopcqoBk5Q==
X-Received: by 2002:a05:600c:3b1a:b0:4a8:b8b4:6226 with SMTP id 5b1f17b1804b1-4ac18c73d17mr79226395e9.28.1793398120539;
        Fri, 30 Oct 2026 15:08:40 -0700 (PDT)
Received: from u1804.home.lan (152-43.dsl.iskon.hr. [89.164.152.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abe7706516sm56230305e9.0.2026.10.30.15.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 15:08:40 -0700 (PDT)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH ath-next 2/3] wifi: ath12k: skip unknown direct buffer ring module IDs
Date: Fri, 30 Oct 2026 23:08:23 +0100
Message-ID: <20261030220824.915760-3-gsustek@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030220824.915760-1-gsustek@gmail.com>
References: <20261030220824.915760-1-gsustek@gmail.com>
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

Newer firmware may advertise direct buffer rings for modules the
driver does not know. QCN9274 firmware WLAN.WBE.1.6-01243 lists
module 2, and ath12k_wmi_dma_ring_caps() treats it as fatal:

  ath12k_wifi7_pci 0000:06:00.0: Invalid module id 2
  ath12k_wifi7_pci 0000:06:00.0: failed to parse tlv -22

It frees the capabilities stored so far and aborts the parse of the
rest of the service ready ext event. Initialisation continues only
because the service ready ext2 event completes it.

Skip unknown module IDs with a debug message instead; the driver only
sets up rings for the modules it implements. Store the accepted
entries contiguously and set num_db_cap to the number actually stored:
ath12k_wmi_alloc_dbring_caps() zero-fills the array, so a hole left at
the index of a skipped entry would read as a spectral ring with zero
sizes.

Tested as part of the series.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Signed-off-by: Goran Sustek <gsustek@gmail.com>
---
 drivers/net/wireless/ath/ath12k/wmi.c |   43 +++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index d5160af60e00..4d4f8e9caf07 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4938,8 +4938,8 @@ static int ath12k_wmi_dma_ring_caps(struct ath12k_base *ab,
 	struct ath12k_wmi_dma_ring_caps_parse *dma_caps_parse = data;
 	struct ath12k_wmi_dma_ring_caps_params *dma_caps;
 	struct ath12k_dbring_cap *dir_buff_caps;
+	u32 i, n = 0, module_id;
 	int ret;
-	u32 i;
 
 	dma_caps_parse->n_dma_ring_caps = 0;
 	dma_caps = (struct ath12k_wmi_dma_ring_caps_params *)ptr;
@@ -4965,26 +4965,39 @@ static int ath12k_wmi_dma_ring_caps(struct ath12k_base *ab,
 
 	dir_buff_caps = ab->db_caps;
 	for (i = 0; i < dma_caps_parse->n_dma_ring_caps; i++) {
-		if (le32_to_cpu(dma_caps[i].module_id) >= WMI_DIRECT_BUF_MAX) {
-			ath12k_warn(ab, "Invalid module id %d\n",
-				    le32_to_cpu(dma_caps[i].module_id));
-			ret = -EINVAL;
-			goto free_dir_buff;
+		module_id = le32_to_cpu(dma_caps[i].module_id);
+
+		/* Newer firmware may advertise rings for modules this driver
+		 * does not know yet. Skip them; the driver only sets up rings
+		 * for the modules it implements.
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
2.47.0
