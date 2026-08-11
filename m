Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F943A80C
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 11:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448601; cv=none; b=WzdMtIS/hCXJ6jkULbzWLNNC9Kzd839AW+gpKNdqM/CjSwlFjEBR2W2msJCZkpDAbAQzbhLZXdCu93X9Gvh8lvawDVK7XdfAZVKBjthmn1mXxCBzCpdOGvzk+egkwMRRDrl3pksSAffYZCwGzqG2hIUTX04MT2ubl86N4Xhwxps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448601; c=relaxed/simple;
	bh=VR/FR12up2l3bccBXUXL/3VFyoBK3DsRHlCU42gGUeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utlOyFOA93wGEvx/os/WnDOeuo9IueIY3a0jqx9dPxr+8MJ5YfMueHWDCHj3MVtZ4vrFydD6sF7UkR0rlRt99JPdIQptMH4fh6tNAhTjMXyNJytT6ersisnU+FNLfOhTf9qA8Rz5fbI7P+pdvWnsf3XrwnOr2i9MgLACXK4kzlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5QxTPqo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5QxTPqo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786448599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VR/FR12up2l3bccBXUXL/3VFyoBK3DsRHlCU42gGUeo=;
	b=N5QxTPqoEPX8zbL9RdIMrccPSejyoBk5B8CZskQeql7OaeliIQu+TbzUrh+oOZhk6MtAP2
	nnu/VmG25YuSpi1PhTgxQ78uKTVD+qSAFmGLrwWrL9u+HOidNUW8T4QZcnvTecdzhqMHES
	Q4t8wspK/DtoTJhCxA+QtJCVSLi9yr0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-Pc4_KJBhMvORZ46iogtoQQ-1; Tue,
 11 Aug 2026 07:43:15 -0400
X-MC-Unique: Pc4_KJBhMvORZ46iogtoQQ-1
X-Mimecast-MFC-AGG-ID: Pc4_KJBhMvORZ46iogtoQQ_1786448593
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD492195604E;
	Tue, 11 Aug 2026 11:43:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 39A743001D38;
	Tue, 11 Aug 2026 11:43:06 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: lkp@intel.com
Cc: alex@shazbot.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	bhelgaas@google.com,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	mani@kernel.org,
	mhi@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v11] PCI: Add device-specific reset for Qualcomm devices
Date: Tue, 11 Aug 2026 13:43:05 +0200
Message-ID: <20260811114305.400333-1-jtornosm@redhat.com>
In-Reply-To: <202608110204.wb17Qqit-lkp@intel.com>
References: <202608110204.wb17Qqit-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Please, use the latest version (v13):
https://lore.kernel.org/all/20260721081301.205374-1-jtornosm@redhat.com/
That and more things are fixed there.

Thanks

