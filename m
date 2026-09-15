Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CAD3876CC;
	Tue, 15 Sep 2026 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458405; cv=pass; b=bp/yVilX6fBgl5BL/bYK4oj+Eh1oRuQjd5Xq/hOWcg3WEIbqvtRx1HEUsygxmyb/3HeavKUxvAHsfCXfpbP14sZIGbqRHqlnw5GrQjoBncaERwDPoovZ1xHHsEcoxYbbEIGWZGrG/OwuyRlAgErILLQzfY/ZABE2DUM29Fe/iXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458405; c=relaxed/simple;
	bh=CjIuEh27k1Xal8RS7CusYRx4cMVCNqvokJf2yY4eXCU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sEQPQwFas1nhvsg8dGE9ZTcFv2b0TW9FIhoRv7A8+TaFJybjYAHdH9QeXXsj1WvFoN/t09aHIgndcan9IZ2Jq/i3Sn5hzYBjGQIJLfVolbtYv7l/PgrcN+UkIMUBY9udR8dvxcGDEubppUZChM07zBnfQb4pOE/6c2xwoWL06cI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=OqNGYX7v; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="OqNGYX7v"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkYxT3qlZzySb;
	Tue, 15 Sep 2026 10:46:37 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789458397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRs19l52ovGuAIjGa7YqoKMg2NfGlSjJwTPL4k7vc2c=;
	b=OqNGYX7vVbvIxmsjtk2iQWRf8dbYFihlNE89E8lbUVn7GPXTxHKhx9rEZduo3om+1v6KJR
	LG07Ihot+saV2Mnj5N6DksBKYcVoX9PkMIjs5cvGfd1p6EzyFsMyjRP4d+GezG/iJIvsUY
	P118wN8WCBkY7dViRsPQbn2lhp1t5jc=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789458397;
	b=oggymuq6kYnCD9ygbnfq5pW2izEpq/HMDNiT8xlKY8NWS088zm19ixvqM3dWW3yWQrJ2SK
	AsPM/clBPb83G8I4zNv6M8YaQ8CrY0QIEpT7u2h7bCiI6aDJA0VE5F1yIvTQgN1jLEynNQ
	YPfiB68/TscZLuN3RixRNXAJahCaELg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789458397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRs19l52ovGuAIjGa7YqoKMg2NfGlSjJwTPL4k7vc2c=;
	b=fax/XSqyVU8LzgedToyLxUTctI5UAwgECN+5d1KbxtWPNGFmjzQYWPHDpWCCOiGoUKUf4k
	Mmj7uPTrxtFm8X2kkh/SrOFSQT8rSJ3a0iZzbhWcrrwRGuOx4faPha9xUtLG7tUVoxkVWN
	7iqeCFgqnMB+a7sHjS1PALni7QuZNjc=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v4 12/12] wifi: ath12k: bind to QRTR endpoint ID in ath12k_qmi_init_service
Date: Tue, 15 Sep 2026 10:41:35 +0300
Message-Id: <20260915074135.2567411-13-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
References: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
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

