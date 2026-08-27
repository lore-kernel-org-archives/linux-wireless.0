Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDAB1632E7
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 05:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787809845; cv=none; b=hMwif+kIgCifclEGTndv55Bm0qlWjyYIZlou5XTO9lVq9/DeFtfQHbZfUkFk5cVwsjufzocafAZO0OCZzN4Imd7lfJzOaephbsvjP7U0qUE/rNpzCxlNGqkQhUK3+Djn2udVTSKtu7urzq6EJ3/5zQuJTUiOJY3xlQLXR1JuPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787809845; c=relaxed/simple;
	bh=IM/lfhf+9mjV0i/YqjuP53U8MHQP7sBmjM6ypdVKMg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCfu8PvWzd3+BMumqkuiZbp2r8NfVd1KRH9nn9VAgialt1PfAIvmEXxhqannV4tjSoijAq9osoCU5vjcgKih4vxTI/5wvru5Gp7zzsNMJE18AzYpR6Er4YBHVu4+IIXpkCs32fZVdzCk/S5kNW5kaOLVGExAInHzCmquuLM36jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=wZnqckf6; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="wZnqckf6"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc1cc97b84bso295887a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 22:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1787809844; x=1788414644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xfynFv2SMwYnUk0M4IAEemAi4hR6mIGHrqfM2qqM/Nw=;
        b=wZnqckf6Z+U1oKc3/Rk+OPcI6Gmo2pLiH+GOHaGcbOQUehsF9TC9xQtvxTGlZJLIsP
         giKaGGhD15kSToPddGJo2B8EmMTt9jgMpi5f+QxlHUsLa960fZaIE6/DhCa2bVlaRupd
         TcGtNO5SoAjw8DhtSQZ3lRRZJYrDCE4JymzSD/kmT+07zjxhN9PJfSQntL9Ce4sFVZfo
         iRa1jPJKw+O89nSr6CIjmHbqnN9VDs2sn+sMpOcROPPtyknR0MLromlFDURw7a/Jo3Oh
         c7V0DWjbOBCi1MsnAvegtCnuUSPNNVfRAdDO6kc7RmiisqrFojiRUW39v1zQAP8eGch/
         pPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787809844; x=1788414644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xfynFv2SMwYnUk0M4IAEemAi4hR6mIGHrqfM2qqM/Nw=;
        b=ayGvdpK09HLwtYGf9gsSPfM7wEmxBqeJVlsygSAywhv+n7JLQ/1HBAXcp8/gr6ZzpT
         CRPVi7Vem2jMi/Ejoc35C/cKHOCl4aNgT7Dri43i5ZWj5VQj/I6OL1cVmTN7WGtAgRXN
         XGI5fV9v52i8Xz9M7F2dcHdsd5X94OM19GVn1RuKiL4ig1taMFHWmc1LbZ3iUKz+Vjpu
         HFGLAy6ks0vmhWOWHsJNPE3wmnwA1qdHwYToz8GPT3Phvo7SM69zCWvRj241V7Vmx3wx
         VID3ugV8s7E0qB+O2x9WsKuQGZoCyn8mZ13cos3m97+PxyRgXZOMtAmobAlPjwJ8yxOX
         E3yg==
X-Gm-Message-State: AFuF++mLUzW2f8igQaAcQ/Aqv4tQ0EKoNO+UrovPiZ+ZWJM3oM5g95P3
	GzICEU2PDzQKVAEwqRQ2gqIm9XdvWtd23GNAt1ssRYgFXtgcDYIzmT+23kbDKW82HNU=
X-Gm-Gg: AR+sD115OMPxruOsKaw2dszBG3v8qdEQzsdMlkYUMTxVCmVlWFsdaHGvikRsKLrRqnI
	OJg1ww/OQq5eeBZtVm1nwEamz/KxrnIVROGv4mICcUH0QkoBaXTYKH4KHDhyjFidLhAnfU8E8uA
	1yuoie3hNCUy1TF/Wz6naJttVQtq1S94XJN50ED/11UD0JKGBGgLmsrvPXTt8BX9InNRd44HDs1
	xQ6Uy8ElSjK1kHPnfRxVa2bbHu6KyMM7nY1DKrcmFNn9WDicVZl3AtYHxSiEnWS9b0/d78SwInB
	kIbe9llrvAm4TSskf6WKvY3ODLinLc+dL/WMhUNm4FY9AgUgylU7L0unX7Y+x/9vxqMNGYJjnwd
	kyHhFYNHvRJfMpXiD9lmDb9eJBOGAlvQDeb0qNV9+i6rcMzpTTlVNnQ8ijqiw+QkIpWyWHxWzJ2
	63wDvoisA/5CpaHFvdyN46wQP58xhKclMiTDM10wO4rirQdnzRBgUmaV2qjrukqbAF+h6ihcaiz
	TVGWyufnddDMV0yLVgCQ4eyryM7YP2SRsJuCMHsHgEl88qcB1Sl2QiRTX7F4GroXvq0BNqLzoMZ
X-Received: by 2002:a05:6a20:cfa1:b0:3c3:875d:7053 with SMTP id adf61e73a8af0-3cf830394a4mr25566298637.8.1787809843788;
        Wed, 26 Aug 2026 22:50:43 -0700 (PDT)
Received: from localhost.localdomain (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1beae5b51sm1732274a12.3.2026.08.26.22.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 22:50:43 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com
Subject: [PATCH wireless-next 8/8] wifi: mm81x: tx multicast frames from AP at primary width
Date: Thu, 27 Aug 2026 15:49:17 +1000
Message-ID: <20260827054917.255584-9-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
References: <20260827054917.255584-1-lachlan.hodges@morsemicro.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If an AP has stations that are operating on a sub-primary (i.e using
the 4MHz primary of the 8MHz operating) multicast frames sent on the
operating width will be lost. Make sure we tx them on the primary width
to ensure all stations are capabile of receiving them.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index d77df6e9af85..4485748518b4 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -1257,6 +1257,15 @@ static int mm81x_tx_h_get_bw(struct mm81x *mors, struct ieee80211_sta *sta,
 	if (is_mgmt || info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)
 		return cfg80211_chandef_s1g_pri_width(&mors->chandef);
 
+	/*
+	 * In AP mode group addressed frames go out at the primary width so
+	 * that every associated STA can receive them, including any that
+	 * cannot support the operating width.
+	 */
+	if (info->control.vif->type == NL80211_IFTYPE_AP &&
+	    is_multicast_ether_addr(ieee80211_get_DA(hdr)))
+		return cfg80211_chandef_s1g_pri_width(&mors->chandef);
+
 	if (sta)
 		mors_sta = (struct mm81x_sta *)sta->drv_priv;
 
-- 
2.43.0

