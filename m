Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D628E2BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601207; cv=none; b=bfh/g7b23R1gXgVuA5da/q8zS9RA0tlOy6GEUJLI1h4xhQc8z/AD0IXStpeUSPOtjQNkB+aDCxHZBX1peTw90iIxps9itg2JxnR/KH9twHSp8HZZ/dTIg6dX2DMCpRMSMJaA92OWrfGYVlbTZCdxtrrLNq8QUYtqKL1sGuoq5iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601207; c=relaxed/simple;
	bh=IEK0ak/byIYhsO8oKuAqp8og3uJ9nwPhIklGzJfM++8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efgE+pccnbnEQWobOLKzuCtYMQUDgs4bhYJ3JdNGPE8GFn74vJMnw5hGS8B5r0wWgW23A26nHxAoaoeo0n+3P/JUEFPR1dIGotXEp5Va463gVYmowKKcLQwhG7q92osjoUm7azsr2O2KtEqBN8WSe89n1Lv49Xqtgc2yKb9zoB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-44caeb973b3so3563764fac.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601205; x=1788206005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+hQSl+XtklSbRLYOghyQhip4h8J9A/gGyo+0gJ8GivQ=;
        b=NQlm39P6HBB+6GzCLsN/RYrKpcx93QD3KCawLpYKIG7/LvxFshXt/VdP6H4lrETXv1
         GAVWRaVTbbSQiD9QKiaHQq5CSYOzbqr480GXahg+s0bRzCtBvPb+MP/5Mf4LzRHazqgU
         L4koe/N/9IxlU/r7tGe3qFUHpLfETwV+jdYy4CT1rnZY/sfB52jipPehiFHQGYsKYOY2
         3OWOmfiqd2wnlC6zx381FyAAeSQooZm5dW20b4OqurC10B+LsCwuYDMhwA0YvLdXza6G
         Js8m9wG4lMI8he4YCPwBQTToL7i7VX/DMpdPa4SP5Ll+zJrKNcoh7shJrtHBUBeV8jLD
         cB4g==
X-Gm-Message-State: AFuF++lmRVAwveInxRrkZh2WxFS0pGsk64GX9pyRpPUPdNQogw0cgNIA
	SlfY9ixg0uNo7dQkZ1HOxDW7IN0zMlXgKd2IxMaOAmZDPBupCn1dlavjBNejOGPDdDQ=
X-Gm-Gg: AR+sD11AtSSE26PWhABLemBUZswA3MRLsYior3U3yHuOuFt9DPZ5zWQrEbQ/WNW92og
	8J/xvzLo3zHPhVJnu6iNdsmgpKqWZg37PgyPmUf/ZZHqGyPQxiF2z44IAdVELWSmCw6onlHdOK+
	bZNungrtAQzKTCoKbPJeTDcXXhlaySJ7cfrzMxSNNNcHaGdRETgkXfFe8NMNING/gdZDjrVt8H/
	XsRe+8013b38D06QDlf1C2jhsJ7O5v9wtlZR7mA95pgu3LIQnhcYbwtKPUuWb8wsQkdcs4Ly35E
	tdrhsWhOqvrWQHCSMDAJtURWCIOrtn8QTDnkaHQ1BLuucSmBqaljElYCQn5oywcaF5AwSAOMcHo
	CGfJNr6XlYXv1x2i01Q9D0SLpivrIhwAf1gzQCzI60o6rjEPj2Gt0ha2tu8grZZxp+4Arl52ztA
	EBL/KFlqpHlO2H3bY9r/KKA7s+vPh/zs64iF9FLIMHMDytiApxpQou96mQGF72MxHnO4aB249vo
	nR/7VA0EIFoJ2Ipr44vZ4y8k97Nr1Iq0eqLNVq8Ctx+bG2tlp48Fkg=
X-Received: by 2002:a05:6870:6c12:b0:456:5461:11d9 with SMTP id 586e51a60fabf-46351688519mr31177819fac.12.1787601204701;
        Mon, 24 Aug 2026 12:53:24 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:24 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 09/15] wifi: mt76: mt7925: replace NAN DW end event with DW start
Date: Mon, 24 Aug 2026 14:52:21 -0500
Message-ID: <20260824195227.12589-10-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824195227.12589-1-sean.wang@kernel.org>
References: <20260824195227.12589-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stella Liu <yu-ching.liu@mediatek.com>

Handle the NAN DW start event instead of the DW end event for DW
notification. Queuing NDP action frames at the beginning of the DW
window, rather than after it ends, improves NDP handshake reliability.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 527cdb3a4ed7..fc105e48eaca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -422,7 +422,7 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		case NAN_UNI_EVENT_ID_DE_EVENT_IND:
 			mt7925_nan_mcu_handle_de_event(dev, tlv);
 			break;
-		case NAN_UNI_EVENT_REPORT_DW_END:
+		case NAN_UNI_EVENT_REPORT_DW_START:
 			mt7925_nan_handle_dw_ind(dev, tlv);
 			break;
 		default:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 8ddb0a6d73b5..b03b909a98d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -92,6 +92,7 @@ enum nan_uni_cmd_tag {
 
 enum nan_uni_event_tag {
 	NAN_UNI_EVENT_ID_DE_EVENT_IND		= 19,
+	NAN_UNI_EVENT_REPORT_DW_START		= 59,
 	NAN_UNI_EVENT_REPORT_DW_END		= 60,
 };
 
-- 
2.43.0

