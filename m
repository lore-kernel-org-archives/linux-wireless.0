Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562987;
	b=UoSq6qboaOMpQ3xDav9DBhIYCgLSggq2+73z4SBvCV2M2pRHeBcNajx+gnQRm/vY1nZp
	 HCT/pxKSSGT2lKvM7rk9tpLRsHXUj01nY5UhGnS1FaDKr5aVVbME4dblPio7UrxqT7+hU
	 zGFRifCd1jGqG6rUuQqu0/cFd8+c/48hvd1B/SAa7wxRirPJa1q0V2qb+fnTTa5wyuGyX
	 BYYYNLrziCHrovHgX3VTndejwZy9BTGsZGQOnZ6HsKI6Lhxqre9p6kpvARxIlXx0mcNDS
	 HcSXV9FDTb2loMLYlsgL+3mlUNe1SXMa3ccC7l07VRVlU4vp5hvmG7J25hJkUqZvZag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562987;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=Y3Kbd4rECN07DcxByi+wY4G9Biu9iKfm+5QZE7UXzxc=;
	b=mqDFwSZTZv0EJis4O8t6cZgfVdMSmbC9ZSP2YEALT5NQ2DxDr3E6YXGy2gUwv8yNxGSW
	 1CtW012v7vdQfwmguelwJAAQKK3hiFGmvxVV/xTfcPu0sGKZx4KTRFPIzGhRQTfadF7kZ
	 o24Qa2Bq14/VENdvpTrEC/tm1svymHlWssSQzVPfzu7aLcUBw/S2N2iJ7rMUhba4KqeYF
	 bOc/sugIy/nG9j2q2FXvBZgjlN58dX9SWSH5v/D2hBaTBvFCpfvSo/fUiYbGLXr41evqP
	 BP2ijLqb/p0v3zPSQ9zPIA6AUdzwqUUmsqUfqQ6AEmhu6Q3n9zLggWhuN0hbO9/DtkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=O+x+CgSG;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2951606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2951606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=O+x+CgSG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y3Kbd4rECN07DcxByi+wY4G9Biu9iKfm+5QZE7UXzxc=;
	b=O+x+CgSGzvGjsOKZbMmBl9c8mzUcwk3NH9DbZLZLDApHUckQpP80xZ0ySDsroo69kQ5pOu
	xv3NV79afHrsbDPQKiolKxXkY0MlbiW+k6lWONoMgU6bTJiBbW8RIP9pReoTm46oxdkLSv
	jiWDRLgx02WvXMMKP0ZULPgE5i6nyFA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-292-bItbCJ_LODKIpUzCS97Hhg-1; Wed,
 21 Oct 2026 06:09:40 +0000
X-MC-Unique: bItbCJ_LODKIpUzCS97Hhg-1
X-Mimecast-MFC-AGG-ID: bItbCJ_LODKIpUzCS97Hhg_1792562979
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E44751956065;
	Wed, 21 Oct 2026 06:09:38 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A51B1800347;
	Wed, 21 Oct 2026 06:09:36 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v8 0/2] wifi: ath12k: implement TX flow control
Date: Wed, 21 Oct 2026 08:09:29 +0200
Message-ID: <20261021060931.249629-1-jtornosm@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This series implements a custom wake_tx_queue operation for the ath12k
driver to prevent hardware ring overflow issues under heavy traffic.

Without proper flow control, the driver can hang and experiences -ENOMEM
errors ("failed to transmit frame -12") when the hardware TCL ring fills
up. These issues are more commonly observed in VMs with PCIe passthrough
but also occur on bare metal systems.

The implementation follows the pattern used in the iwlwifi driver,
adapted for ath12k hardware ring architecture, checking hardware ring
space before dequeuing packets from mac80211.

Testing shows stable operation with eliminated -ENOMEM errors, no hangs,
and improved throughput under heavy traffic conditions.

Jose Ignacio Tornos Martinez (2):
  wifi: ath12k: remove skb parameter from get_ring_selector
  wifi: ath12k: implement custom wake_tx_queue with flow control

v8: Split ath11k and ath12k into separate series to avoid conflict
    with Julius's airtime queue limits series (ath11k only) and help to
    unblock both
    No code changes from v7
v7: https://lore.kernel.org/all/20260917064825.12747-1-jtornosm@redhat.com/
--
2.54.0

