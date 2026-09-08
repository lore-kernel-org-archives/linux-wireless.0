Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD85F509EF9;
	Tue,  8 Sep 2026 09:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860109; cv=pass; b=reKjTz8ieKFDtQ1obbAr/3NjYgWqQptrfgcYxeQ61gYz3Skq23ieNDpFIAMUq8PBgGjGv69uppsiRLAR0aZVhaBEKsFxPXqwRDmobhDCmPXzIE8mHuDg0EO8yDzRHNyg4iWSP0UKyDdQCqWMCBlgf8jokLylXir9zJNzzqgMICE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860109; c=relaxed/simple;
	bh=MS4N+wBIu8d1ilLBdLyUw8sDD8/0Zw7lI6RU/EotEcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M238MaPgfzXI12dXOfdUqdOo2xN3UjO+slqlmIlIBATUkZI2ox6PdnBwNcJvtRgQi+YTgVP9lamMRkC60IkCIK0IVWhH8GwqVPbsd9gQJBLMRnuOCOZRWLP/bpYbddUW9pfRCRZkGhbQxPm7TIrjAZjn0ZNLLQ3MG8FprKF8LWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=sox6nfXV; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="sox6nfXV"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJgn5tbvz49Q5T;
	Tue, 08 Sep 2026 12:35:01 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788860101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WPWwjv2lCc78jyciiGeHhfapHx7+w7VurSqk2gEfFB0=;
	b=sox6nfXVRfJ0wdfPz7Xy8oJy+xIUcJy61HUxhgXqNPUI6/Y8zxbmEE578M45pZ1br/eaqA
	GHQJCxPPM8XfgiRT/r+AGRBYVVJ59F9KHgU+NOqXhY6YJ4cEzY3K3662GTQq22yahsqTJ+
	waMojc8tCxAK1srAV6uyZT0LelmMvtIbug8TzB9bUj4/+RZfr8VAss41l1R4GRIl2aeEnh
	tPMlBbK6GDhJzRSx3guaHhXzEHGiKcRxw/A1rwDUk2TPaodzUy8mU9PjTRw+bZhS5UpJai
	gkbTliTDmB2kPGfa/ZOklLUIURM09FgT/WnOQQJOdlbI6adPHpf409OgewpQ8A==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788860101;
	b=TaCZ/YHo6zVNdGI3KeiLNz3ZnYFqlLwQRvofQE1SNPYjLdtwkoPq8qNCaG7j0/FRMF/LP3
	mab/nycp+6xsbIZnS2SSI6Xfq0JoYb6CUar54UJlMmlERGLqMWp9lVH6N3OQSMTSB5idd9
	VOOGQo37tqMimIw5+BMn1X7SjeMGnxqvNtj1kcdM+hEoQjVAY6tdj1V6mim08JahzkMbuR
	FNIYqf4/Z1g4qyNc7qXb50jtYTkK2TTqLLhGk/39+2uRxFCP6nqnfzh/H/s3l5z3G95C8c
	rvrlLYLNJaWWZcUQbTyigSFvki/zv1sXEW5ZJ83rv5K/hLLp95p6xETwa0pUTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788860101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WPWwjv2lCc78jyciiGeHhfapHx7+w7VurSqk2gEfFB0=;
	b=KYHJSCMBrNKr2zTzrcLnOQ6sd5kWo78WD/G8HUyC9o5M5i1EgNkPitOwoQbhMjW0pg+Pg1
	pCeSaaDx57ulNv05Tss7mp1hTp5okC8ACLpSAFx1uO5p1foqL6sY4F3TLmw/klSUSpNfWN
	XAZVDAwpaukS648Z7NCE3np2vf0kyg+K4BuVd9b0ODt5tjzoCRI25QNXizr2jiWZcSWeDH
	/EmIZ/9Sy7o19lZPhqXfnEhlWJUNExEDL3Uja+uT5L3CnZeP327ktFzhVk30tcdDjv/425
	y4lFdMoi8DaxFriogGs4VjC/OH9e7mjKmhXhxrDBEsVWQAkbZj5Jg9Sl8BE8Zw==
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
Subject: [PATCH v3 09/12] wifi: ath11k: bind to QRTR endpoint ID in ath11k_qmi_init_service
Date: Tue,  8 Sep 2026 12:34:34 +0300
Message-Id: <20260908093437.2493698-2-juha-matti.tilli@iki.fi>
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

If possible, fetch the QRTR endpoint ID in ath11k_qmi_init_service, just
before calling qmi_handle_init, and make it available in the qmi_handle.

qmi_helpers will then automatically bind to this endpoint for us.

This finally allows using multiple ath11k-based cards with the same QRTR
node/port combination to work simultanenous (and, for that matter, at
all).

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 7dc07339b9579..ee5effc113667 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -16,6 +16,7 @@
 #include <linux/ioport.h>
 #include <linux/firmware.h>
 #include <linux/of_irq.h>
+#include <net/sock.h>
 
 #define SLEEP_CLOCK_SELECT_INTERNAL_BIT	0x02
 #define HOST_CSTATE_BIT			0x04
@@ -3324,6 +3325,13 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 	ab->qmi.ab = ab;
 
 	ab->qmi.target_mem_mode = ab->hw_params.fw_mem_mode;
+
+	ret = ath11k_set_qrtr_endpoint_id(ab);
+	if (ret) {
+		ath11k_warn(ab, "failed to set QRTR endpoint ID: %d\n", ret);
+		ath11k_warn(ab, "only one device per system will be supported\n");
+	}
+
 	ret = qmi_handle_init(&ab->qmi.handle, ATH11K_QMI_RESP_LEN_MAX,
 			      &ath11k_qmi_ops, ath11k_qmi_msg_handlers);
 	if (ret < 0) {
-- 
2.34.1

