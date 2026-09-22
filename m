Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DCD388E72
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790100173; cv=none; b=F/snmMsxCB4QmI9eNZLGj5Uz4TbEcH95vHxjmBoMeMb47omHHBlrGtVYUpSjtyN7rogVdqHfZis48ImIkmc0VlPtThuzf4i+C/RsGb7W9KoS17+1vljtduA303PRKEVBSB2s9u97vi3sIHBsTw+orkZACK7HmXWCKUBIBZpkgow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790100173; c=relaxed/simple;
	bh=f4gc6NL/IAXUZyeAjSJZyyxTjzimmJM0MZdfzBMjr8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESLwj6YIcYTmy2fsD+Sr0gzFOvfi1IdkAOs76jm34Sg30C0vw7NJ5cOlelY9VroVxjMXsMqSdf2VQqKz1aNeKif6O1R5DdsHllvWPj3NHxGPO7jtuoPvDo3+4rBRZ7AwNhSI4gecnvULim6ytv2ZC5x7+khUPJrvc9WgYsSIL4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=BLRN+dYp; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="BLRN+dYp"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccafb751so149864a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790100171; x=1790704971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Skm9oBUFwichZa2wYt/07iDX4MVAS8c7WKeyWN7nUwg=;
        b=BLRN+dYpoq0t1LfMrKpMnFgAAvjl3fWVNuRzZ7CKUm2qj4aw49hE16nwTwujstmNOV
         wDq3TTPi/yjiDSvYElUz5kB5kJ37WOnVTC9nXgJu/NLNPdSjfM0mov3qUDTicxTsNy36
         mOKTiEp3RPCqufPJz2FmA9fehPiHjiguaODcfa6+SdltAs3CVU1PPlyZP6DOX4E5g4C5
         MJWidSGMRKeGDRDsVZ/fVNaNcXK95a8JgyeAqnJEbELUcTi5nJYw0Ro7GgZ5H++Fs9K7
         GJFTeVtWLQBuw9uO58VK/jWOMF27bh0UyYp02k23SzZfDsJmV5adj2R+/TctnjlETte+
         K4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790100171; x=1790704971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Skm9oBUFwichZa2wYt/07iDX4MVAS8c7WKeyWN7nUwg=;
        b=cdOWa//SqVO4zdMf+UvdkgNkjTXOMj/xHJVdkmHwZPQick4xWHA5LZFP97Y1qrE/+q
         7J7bH7BSpz7AXiR9o/vH7KbbwoTPciLsr2pst1wLJMJrSU3B/RjvFnVREXhYHj5zWfus
         CZpF9YeJPTV6a2J5wtrN20lN+RQGCHinBNKWh3pMt0G0HuyDDKUEdFZAAkhuvN4BsOiH
         5osCYTQiQMGK/+jlJDpEyjZGZahDI90YwRl0E7hTS7lC+g77v/mbNT7O4BEWMj+t/IyG
         RmpYHEKt5ml/bc/MckThOJKtFPOh9neZQSedDNM5heV6OZsYZBE3TvsoOVQXcfAeJGln
         8sHg==
X-Gm-Message-State: AFuF++nGB15TC4e9tGcBxrdkGmhJfB0vvWxf7tv37JRV99PGmC3zKbLf
	Sr7bPGaYMrt+A3i6HiJTxai4NjZTxV0glSCIKLuhVavXpIqcvYaNSyPf4i1ZCAmiFpu2Eyxlugu
	LsLBhU1OU
X-Gm-Gg: AYBFou3TN20N6LfrpdmOgdSKDvqOs57KTraCjPn5OVfws8KatgnySw1yaN7jJ2Y/dMe
	rz8d3U9iTAejXPMOxbvk7vvOx2kpg9XoOFjim9F2+cqqLct5CKos/5dXKBfE1dACt3EWUZqD3ju
	yRB+p/u4WokYqsRUjzgPlGtf39awPBqPRRh/aA707x2YW/MVvCrpccdjYGWUNKkVZFeKDDjQhTa
	5ZA14FvOBYxuEVu084ZyBBxbtTSD/AcmLw7cQNsjSeQtKU8GVdZpXiHdzJ+3FSvuH+mTr/yfb33
	LoQfN+2zo37UdIgvaYgf/dTtLo6czUfV8P8Aeb/6i/iKS6NgsuqnD+b+aMupUC48a6vfizsq2V/
	29o5FtCausaWAxpeVenuoDL7qrkhO/aT72X4ckKVpBu16ipLtkhCzKEKuX6n67lc7oKifcaB99w
	NCsTuqt8+hxu0HDfXye+ku8FzRWJ0UDvM9nf8/kXiLJNJSBaSUC5JHriGmgNxd7qXVe/xZOt074
	CPjB8MW
X-Received: by 2002:a17:90b:3842:b0:3a0:309d:5549 with SMTP id 98e67ed59e1d1-3a07e54f450mr216670a91.8.1790100171491;
        Tue, 22 Sep 2026 11:02:51 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07d9978c4sm621117a91.0.2026.09.22.11.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:02:51 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	michael-cy.lee@mediatek.com,
	vega@nebusec.ai,
	caoruide123@gmail.com,
	weir@nebusec.ai
Subject: [PATCH 1/1] wifi: mac80211: reject invalid 320 MHz CSA bandwidth
Date: Wed, 23 Sep 2026 02:02:23 +0800
Message-ID: <bd68e360e06135c750397cb6be003a01a834a179.1787222001.git.vega.cover-letter@nebusec.ai>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787222001.git.vega.cover-letter@nebusec.ai>
References: <cover.1787222001.git.vega.cover-letter@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ruide Cao <caoruide123@gmail.com>

The HT/VHT channel definition validator can receive a 320 MHz
bandwidth indication from a received CSA frame on a non-6 GHz link.
It warns for this unsupported width but continues with an uninitialized
vht_operation.chan_width, which is then read by
ieee80211_chandef_vht_oper(). With panic_on_warn enabled, this lets a
received frame panic the kernel.

Reject the channel definition before entering the VHT operation
conversion. This preserves the existing CSA fallback while avoiding
both the warning and the uninitialized read.

Fixes: 21c3f8f95554 ("wifi: mac80211: refactor STA CSA parsing flows")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
 net/mac80211/spectmgmt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index ec622750e1c9..a70ddb83106b 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -111,8 +111,8 @@ validate_chandef_by_ht_vht_oper(struct ieee80211_sub_if_data *sdata,
 
 	switch (chan_width) {
 	case NL80211_CHAN_WIDTH_320:
-		WARN_ON(1);
-		break;
+		chandef->chan = NULL;
+		return;
 	case NL80211_CHAN_WIDTH_160:
 		vht_oper.chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
 		vht_oper.center_freq_seg1_idx = vht_oper.center_freq_seg0_idx;
-- 
2.47.3
