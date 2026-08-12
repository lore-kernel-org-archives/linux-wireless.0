Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90482367293
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786561570; cv=none; b=Zcgx9o6cN+R31lQFDfmtbzuu/YhKUmxDLtMcj+QSb84bYTWu0Z44TK2ZwFV22Z5cMLB+sNfGzudTP//+00O0DpS+hH9py75i3EpnhyXOIxzRccGVeh0ev4qixTSe4DW6TpnQIDMw4OK2lgjupTeE/m2+FsljaL1GIeAjb+1vvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786561570; c=relaxed/simple;
	bh=T3sPnoq0RTs0uG8HPlVWHRGrVSNIKWFyaLvT/6yrFPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3xMgDcxeXeNajXP3oupEC/uktd6WMSyJuK2sc/ir2DRV+smdrcC1p+Ftr4wpjulBOivYUSQAQFWL6dfcdhvvDV/qWXYFav+SHyyb4OwkNss5KrQM5Cb+c16+UFcilQbEAe1VUkLaH9whLksqDCJfePVU3wykfM1OCzISY3YsPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XXQC3PK3; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXQC3PK3"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso13852525e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 12:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786561567; x=1787166367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jw5hnegB1m/L5wmsBBcHwaBQGgRjAN6McFTUJSuZSpc=;
        b=XXQC3PK3c6w2rexY4dXeMslJdD5bFihF0Bx3NXelxugdDn0Yu5z9yK5IS0Im3OXpcQ
         qLQTSAUGUl0SUAkS05b7yqbd0j1PKt44rGDk4FkFTuu+qJCW2cZx5sQyT+6au8UZlN3A
         xth5o+Lx9YGdfl3bszCwMGZ8TSqiecsCaGapwUULvLYoXVIFHRtMcOIw7IwmSBYwxrbR
         S7qfYsgqXnTjvLpBo9zDynZwh8vn9VobxQYFBX9017/aL9bxyL5xufBsRwhOCyk00/L9
         V3bpjKuI2WlDbIPL3SRaGy/0/3vhwOCZmJWvB+DiLQh+yZn0YEIxDFgZ7o5PK4C3PrOH
         XzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786561567; x=1787166367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jw5hnegB1m/L5wmsBBcHwaBQGgRjAN6McFTUJSuZSpc=;
        b=erQsGo689s+S+MFx6cR8DWvsEQ4Zr7omLJtAg/oY9qfLKhIhjEo9eqb93G3eRpuskJ
         A2+w8Bg5CFzBdNR51eApWAlrA63u/ydhlgyLMq3YB4VcltqmGRARWHSp7tMKsspPBdPs
         K0lnaijLFWjHjb8npb4JN8YfAIz/JzIt9yRCXXfnTTM35PDpuq+h8iZFp5nTsR1MUK1z
         c86YobGdX1gL5HAzBoMuMeskrK/l2BiDEf6c7I4QTaLVKZaMPClllHjcEb/iMhuY08qm
         qHu691/0WaMflJdswAovwnrbySrphkSIWpmoys7gcsC9hey39VCDfyntUJTnQnt5dH6c
         LoZQ==
X-Forwarded-Encrypted: i=1; AHgh+RpuwP8Av395nqpligP9oqaQyU31TWwr+q9a/3xgWXQeujPxIWxY5/FQNCA5cBlcI8mO1FTm8r+AarKAwjIIVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkEDtvNupANKnC29cYjS280S6gsL8X8NjqNvo7TFX+xyqHfYNH
	9vvzaB7mJgVw9PC5WqIjhCyhEop+UX088uiIDnsiWzvA3z9fPFeQfCBX
X-Gm-Gg: AR+sD11HrQLzXzG1jYI7G4Q/0vIGHXvyW1xzcCWzJj3sU8XC0amrGpVYEmsotnrQXND
	+KsYX4szNT+RV2o71ztUzlA8vaQ8iJJ9J7ZK1Z275DCGXKYE0P+12AyIYczXc2C2dC7B89VRr4l
	q2D7cxDAD8tytbdCz+IiWlvJmqmatc+bqJXP9FYs0Wu9a5tDaOliIHkzbkr8pd4c6ccoYFhi2B9
	r8+iRawVTKHjLuAw7fVW7WQ6ewhi8fnf9iDH/ivYe6iy2WUFY2okPK9H5yB5Ln0noWCYtjVgtxI
	aVmA+x3Nm2HJSVRJuOHyHEEeRyUBMxd15y0weZ941mEc1NSkwvIPFRexPR7g9tY2oHOdNHrnJEM
	opdkNONqO5M4uszgq6ZhnlgNI39GnUHmfLDvfqgs3JinCpgcL7n7jPrbCQsE9fgSJCAdg5tspDY
	mK1Hv1FqONqkeWi8JzI3gK3OCo/BlqKMlUHjW9ZOqIJ6OfyogZf2RVjChFEO8jZgIRVe8/nKuk7
	e2yxmz760mO8s5KfPv5q2WVqBwJjO44OZgWTHFprGMDKJDovLpA3rioSNqXj5tR2+qu0N5jBUGl
	X3ThIw==
X-Received: by 2002:a05:600c:46c6:b0:498:ee7:e407 with SMTP id 5b1f17b1804b1-4997c1649f5mr87009305e9.17.1786561566686;
        Wed, 12 Aug 2026 12:06:06 -0700 (PDT)
Received: from Mac.home ([95.35.242.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150d5eb2csm9179875f8f.30.2026.08.12.12.06.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Aug 2026 12:06:06 -0700 (PDT)
From: Shmulik Cohen <anuk909@gmail.com>
To: stas.yakovlev@gmail.com
Cc: johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shmulik Cohen <anuk909@gmail.com>
Subject: [PATCH 3/3] wifi: ipw2x00: bound management frame length to the receive buffer
Date: Wed, 12 Aug 2026 22:04:12 +0300
Message-ID: <20260812190412.18333-4-anuk909@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260812190412.18333-1-anuk909@gmail.com>
References: <20260812190412.18333-1-anuk909@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both management receive paths establish a lower bound on the frame
length and no upper bound, even though the length originates from the
device.

ipw2100_corruption_check() returns 0 without inspecting frame_size for
management frames, and __ipw2100_rx_process() only rejects a frame
smaller than the three-address header, so any reported size up to the
u32 limit reaches libipw_rx_mgt() against a receive allocation of
IPW_RX_NIC_BUFFER_LENGTH bytes.  Check frame_size itself rather than
stats.len, which is a u16: a size of 65566 truncates to 30 on
assignment and would pass a check made afterwards.

ipw_rx() likewise only rejects a frame shorter than the header length.
Bound it against the DMA mapped receive buffer.  The size passed to
alloc_skb() is rounded up by the allocator, so skb_tailroom() can
exceed IPW_RX_BUF_SIZE and is not a usable bound here; the existing
uses of that idiom in the data paths are too permissive for the same
reason.

libipw then hands the remainder to libipw_parse_info_param(), which
walks information elements for as long as the length allows, so an
over-long reported length reads past the receive buffer without any
wraparound being involved.

The length is device-reported, so per
Documentation/process/threat-model.rst this is a robustness fix rather
than a vulnerability.

Found by an AI-assisted review of length arithmetic in management frame
parsers.  Compile-tested only for these two hunks; I do not have the
hardware, so they are not tested on a real device.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Shmulik Cohen <anuk909@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 4 +++-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 9 +++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 2b8a23865bfb..43b4e432956b 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -2712,7 +2712,9 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 				break;
 			}
 #endif
-			if (stats.len < sizeof(struct libipw_hdr_3addr))
+			if (sq->drv[i].frame_size <
+				    sizeof(struct libipw_hdr_3addr) ||
+			    sq->drv[i].frame_size > IPW_RX_NIC_BUFFER_LENGTH)
 				break;
 			switch (WLAN_FC_GET_TYPE(le16_to_cpu(u->rx_data.header.frame_ctl))) {
 			case IEEE80211_FTYPE_MGMT:
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 4bc9bb406e8e..8249d493ee22 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -8322,6 +8322,15 @@ static void ipw_rx(struct ipw_priv *priv)
 					break;
 				}
 
+				if (unlikely(le16_to_cpu(pkt->u.frame.length) >
+					     IPW_RX_BUF_SIZE -
+					     IPW_RX_FRAME_SIZE)) {
+					IPW_DEBUG_DROP("Received oversized packet. Dropping.\n");
+					priv->net_dev->stats.rx_errors++;
+					priv->wstats.discard.misc++;
+					break;
+				}
+
 				switch (WLAN_FC_GET_TYPE
 					(le16_to_cpu(header->frame_ctl))) {
 
-- 
2.50.1 (Apple Git-155)

