Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0939946D558
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391140; cv=none; b=ENDRt3eqkMDI1gOpkvAzWzM52HIdSgpmgizJ7PNhEnETWhZAu9KbDdU7gWc5gLZ4SwvtXZMrAtSpSKS/hGQtaKV4/89VjJZjniUrTAkG7aGu1Ghh4elTUFUEhFm2RbGo1fW77O9c+IcSGl8W01tVN4/LpSJUEAMpUenhliPMrsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391140; c=relaxed/simple;
	bh=q5o+CKn0Co/R2u4gXcpA7aZ6Z7WqyCo44To0XEIGF3E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iJLwYeoNc5pTfMEGnnEFSFfSq7qOl25T7JroBGhh9HP6CEjgEyhdKp1ysxk1pH3NPBRqI8c/IuxMhvbM/QCy4VX2st+SRVlPo0sDXIUzUgg0J55bkFCNRdIfRYS5wqFNL40iZSqbWeRC3W6R8TTslfB24LFpcbcTiPcCFQlLeoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O/66uSa6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O/66uSa6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789391136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IIrbGOfIQRouXedn+IFe+NVdpQt1cwK8/ve6LQAjMBQ=;
	b=O/66uSa6uvvM3oivI1M6pxBpCAbuTQPT/R9Xr/GPRjyCtQ+96ogwaVCdPwRru0GK8d6C83
	LMDYBt15pueHdSGvX+ozSOXBkp5pJAZ4g8RGOVBm+nIUdUPVQ3xKb9BQnLLY5wM3QtHP09
	Tu+1OmPJeEk04behp3sB6q/PCmC6efw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-v8tbygsCPh-78Yel-q_hfQ-1; Mon,
 14 Sep 2026 09:05:32 -0400
X-MC-Unique: v8tbygsCPh-78Yel-q_hfQ-1
X-Mimecast-MFC-AGG-ID: v8tbygsCPh-78Yel-q_hfQ_1789391129
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E27241955F21;
	Mon, 14 Sep 2026 13:05:28 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1325180056E;
	Mon, 14 Sep 2026 13:05:26 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Mon, 14 Sep 2026 15:05:19 +0200
Subject: [PATCH] ath10k: clear QMI if failed during init
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAMAwEvyI5G2iLtuhXxIPaaINSpRURxL8bP
 A47Ow9kSkwZ2uKBRBdn3qOALguYwhAXQvbCYJSxqtEVznzjcAatVvSybxwX1LV11lfGTeMI8jw
 SifZXu/59P0FKLW1lAAAA
X-Change-ID: 20260914-fix-ath10k-dangling-15676d427cbb
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Govind Singh <govinds@codeaurora.org>, 
 Brian Norris <briannorris@chromium.org>, 
 Niklas Cassel <niklas.cassel@linaro.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789391126; l=928;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=q5o+CKn0Co/R2u4gXcpA7aZ6Z7WqyCo44To0XEIGF3E=;
 b=FllOoEx11IsQvIExPmEjc7zvCB6JpPPqftbJxleq4hs7bjcJpONSe3ItkwpiRa8GzlfV6YUZP
 pudK/qMvdQqD9SIS5BBH9KG+C+0GFb2O/eUwRnriEebFaJVq7f7pazd
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

A failed ath10k_qmi_init() left a dangling
pointer (ar_snoc->qmi) in the cleanup path.
Clear the pointer on the way out for hygiene
and consistency with deinit().

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 0d74548a5f34..08a64f737fb4 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1128,6 +1128,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
 
 err:
 	kfree(qmi);
+	ar_snoc->qmi = NULL;
 	return ret;
 }
 

---
base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
change-id: 20260914-fix-ath10k-dangling-15676d427cbb

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>

