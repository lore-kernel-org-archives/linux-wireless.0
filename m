Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055D74B2031;
	Tue,  8 Sep 2026 09:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860139; cv=pass; b=q4kfQDxlaq8n6/gs687HLpT9Lryy+cI6vC9cOsNX3vVxaEeAyu/EMTogL0qlIgAFtLpTCIkokXFPEs9kCVmJREEYZQl9pJ+s14Yft3IPte1idesSRUrClwjXbbpcLqnYSkZXnbG1lkrvhEerlmRwHxl2hlSwpo3ir6B/lrJX6W0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860139; c=relaxed/simple;
	bh=CjIuEh27k1Xal8RS7CusYRx4cMVCNqvokJf2yY4eXCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FFMLmXC2Zz70M7DVCK173Msfktur6ySHWzN+I0ydG27Ul7jya0p7B7e5ZPX1COjxUPB/wyzsHyRmsC1tunW6ngLniZFNIMYRTDAvAFWRCt2us37ZY8lqhABqJN6gvRNqdmsYbJd3oqtByBIjLm7iQT2NL65qes6ONOZahXEMuig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=NiAdMkxI; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="NiAdMkxI"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJhM12z2z49QLG;
	Tue, 08 Sep 2026 12:35:31 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788860131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRs19l52ovGuAIjGa7YqoKMg2NfGlSjJwTPL4k7vc2c=;
	b=NiAdMkxIyyh3NDJprkUTuf2Q1eqFxi344Ao8crIgZwnovGK9ixUTOjC3pJBBXVQBPI/Rks
	ndnVwVTgF2OvmJvYtY4mJgONTqNKN77WaJcksfnx4LSL9bB4eQjP+cC5njyJtJLxAxb8xe
	tUPus41JipdUKflsmdtawujIJEpnTB3+AwjboMoTkNYAY/oTPIRqjIvfF0O28Ydl95SKa/
	atBjq2+8qVqi654xiTtfcMfZkq5usAoBLEwkpap436S5zVx6RSbKBT/tlvIWK6APE2oXva
	QKY/39E0KnHVh2ZfeZjxx0L26QKdXZ8TXHEx/H3v1gSL6GJKQTRouxSX1f8gUw==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788860131;
	b=pQAkl8rQAsHWpen5iLs2INnduCGReTAGSKqifshOOzkT6kHUyU5HcyPD0/k1M7PNMW9KNK
	KD2Utq93Zatn2j5kOIS91BzkWybAmkFS/B0ninJiHNHLJ3Rz9tNBJNvEpUSi3OppP8gS7B
	ZREihqJWVgzxIbGli8GGdm9xXYipoMgeLRuJ0aKP3qQtRTZPgkWGwkNDqMPntB4jYkym2y
	V2SVoj5GwLgYIr74PqHY+m46vjLSvlgJvCjsVwdJPaqvOIhz3lwXRDMw61ktbvFAxZAkVW
	tWFCyD4nZ+UUAgQBzSnCiiyb6YlZ0rfNYZGMz5YgtK4EnC2zWXKib1acFx7YQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788860131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRs19l52ovGuAIjGa7YqoKMg2NfGlSjJwTPL4k7vc2c=;
	b=Z+SYMumaDUZrM+bK91MfhU15ixQ4a/2cZVTvZSQR0Xg5cxRl7TM6jCc7od+d8CeGwsss7w
	U2caCdxD7iPUYUw/sdBxRy24cdOyeR7/1EJEoizbkDxa6nEpuVcgNzm+jFUOu+sEEM28Lg
	r2SNHNXd1AZPTu89SOdXuRm0+E+voiyg/UcGBILz52bJU3K6W1BBUSh2yLl6YraXaLcdja
	iRMr+TMcZHZoSnOqN4siTOwse+vn0zyI/3o1UMxibAQHsvj5n0dPI4v7hPjEyuTBh0vYAw
	r4YlQHEYmPAYhT7bcaxgk2GJ3dbHDfUYLewkv3pEQcyN7kb79ao9Aumk/KgCYQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	linux-wireless@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/12] wifi: ath12k: bind to QRTR endpoint ID in ath12k_qmi_init_service
Date: Tue,  8 Sep 2026 12:34:37 +0300
Message-Id: <20260908093437.2493698-5-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093437.2493698-1-juha-matti.tilli@iki.fi>
References: <20260908093437.2493698-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mihai Moldovan <ionic@ionic.de>

If possible, fetch the QRTR endpoint ID in ath12k_qmi_init_service, just
before calling qmi_handle_init, and make it available in the qmi_handle.

qmi_helpers will then automatically bind to this endpoint for us.

This finally allows using multiple ath12k-based cards with the same QRTR
node/port combination to work simultanenous (and, for that matter, at
all), including combinations of ath11k-based and ath12k-based cards.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Old-version-tested-by: Mihai Moldovan <ionic@ionic.de>
Old-version-tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index 50082505c882d..3611d0eff22b3 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -9,11 +9,13 @@
 #include "qmi.h"
 #include "core.h"
 #include "debug.h"
+#include "hif.h"
 #include <linux/of.h>
 #include <linux/firmware.h>
 #include <linux/of_address.h>
 #include <linux/ioport.h>
 #include <linux/of_reserved_mem.h>
+#include <net/sock.h>
 
 #define SLEEP_CLOCK_SELECT_INTERNAL_BIT	0x02
 #define HOST_CSTATE_BIT			0x04
@@ -4075,6 +4077,13 @@ int ath12k_qmi_init_service(struct ath12k_base *ab)
 	ab->qmi.ab = ab;
 
 	ab->qmi.target_mem_mode = ab->target_mem_mode;
+
+	ret = ath12k_hif_set_qrtr_endpoint_id(ab);
+	if (ret) {
+		ath12k_warn(ab, "failed to set QRTR endpoint ID: %d\n", ret);
+		ath12k_warn(ab, "only one device per system will be supported\n");
+	}
+
 	ret = qmi_handle_init(&ab->qmi.handle, ATH12K_QMI_RESP_LEN_MAX,
 			      &ath12k_qmi_ops, ath12k_qmi_msg_handlers);
 	if (ret < 0) {
-- 
2.34.1

