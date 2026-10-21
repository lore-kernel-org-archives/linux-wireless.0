Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792562858;
	b=Lp/AAKTFjfDYuZt8JBpRHll90P9Vd/GU07sbdpbI5Pl5Ey76Rrrj6l5U7DHwdWMqlHuj
	 KA/S7gRtCXB7o/5d76979V4MEt8+un0xOHePQSx6MlU5LmuvJt0GHCOzvxVU2unUWLT+A
	 1uVvoMF75bbAqcGmcUzZVYLlxyGkXHcwoYh9Km8TAB2TU99tr6Jf/C5a5sDxT3/l96y8a
	 WmIICuwh3qISW9Cm0U1doGtpk7D+ZPECza49UHBUWeabSETKX513MOwiNT5fEp9tFQ2ao
	 014lHokbwVg9UO7OEHEvtoZ4dBymsKMdmXG59k8rB5kIj7ALNbEeuoZz+bHQ/eMH6hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792562858;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=hJTbezORZnYJia58M/w7jTBC+CsV7fk7tMYV5VsvrrY=;
	b=e+XA6r0ZKBBlJvwnJyqK2RoCx3eFGCGftpf4MnVXpPpryv0fJY00A2XpCHivl/jvGhQo
	 a5/Cf1U92kem4XIF5qXhfBimickH7JusjUH1SPqKof77InR2IfmWIBXS5TMBMZU+6H3ze
	 +zVQgHgG/D9i+6Ex6kPHkrcz/eI50Lf7v55hTiK65nAogc6ZeWRIO74xjDgO2SMVo8iY1
	 iYzluJHzoPaKatsHIkmaLTT02iOCt+cKprZjbLA/VjB4NPBps5eugqgjTVxHuAP/unCok
	 5uGkkUKnMduGh+6gOPjCHWEoIgZwDsF4EiL7yq0gO18ghfQMv9wwhF/63Hy9CKk1RyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fED4uhra;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB03606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 06:07:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFB03606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fED4uhra
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hJTbezORZnYJia58M/w7jTBC+CsV7fk7tMYV5VsvrrY=;
	b=fED4uhrantB3LTFfdKuURb6/LRqj+pq5DhlYYQbdhnJwZu1DEn3VQjL0bc/48Fe2EhSd70
	C3X2v7PTKXseSWNwsckDRXxjW43A2y99pQBCuKdvpsCjvh6KGtOuj5X6BfjBNNGhIscP/O
	6LnpNY3RbbMxYuSoD71/PuCSu+QRybQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-LhCrz1F7PyyeUPBsoPOzHg-1; Wed,
 21 Oct 2026 06:07:35 +0000
X-MC-Unique: LhCrz1F7PyyeUPBsoPOzHg-1
X-Mimecast-MFC-AGG-ID: LhCrz1F7PyyeUPBsoPOzHg_1792562854
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 174E9180028B;
	Wed, 21 Oct 2026 06:07:33 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9266630001A2;
	Wed, 21 Oct 2026 06:07:29 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jjohnson@kernel.org
Cc: tamizh.raja@oss.qualcomm.com,
	julius@bairaktaris.de,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v8 0/3] wifi: ath11k: implement TX flow control
Date: Wed, 21 Oct 2026 08:07:22 +0200
Message-ID: <20261021060725.242681-1-jtornosm@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This series implements a custom wake_tx_queue operation for the ath11k
driver to prevent hardware ring overflow issues under heavy traffic.

Without proper flow control, the driver experiences -ENOMEM errors
("failed to transmit frame -12") when the hardware TCL ring fills up.
These issues are more commonly observed in VMs with PCIe passthrough but
also occur on bare metal systems.

The implementation follows the pattern used in the iwlwifi driver,
adapted for ath11k hardware ring architecture, checking hardware ring
space before dequeuing packets from mac80211.

Testing shows stable operation with eliminated -ENOMEM errors and
improved throughput under heavy traffic conditions.

Jose Ignacio Tornos Martinez (3):
  wifi: ath11k: use queue mapping for WCN6750 ring selection
  wifi: ath11k: remove skb parameter from get_ring_selector
  wifi: ath11k: implement custom wake_tx_queue with flow control

v8: Split ath11k and ath12k into separate series to avoid conflict
    with Julius's airtime queue limits series (ath11k only) and help to
    unblock both
    No code changes from v7
v7: https://lore.kernel.org/all/20260917064825.12747-1-jtornosm@redhat.com/
--
2.54.0

