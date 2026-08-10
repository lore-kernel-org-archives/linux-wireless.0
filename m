Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B08C3B7759
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 10:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786356697; cv=none; b=Qj35xligo6mZZKZ6/b42BAWWqq5dmwHz6qPnBbtLUbIhMmqJ+EoZfpwaKauYiN5WB4LCtBw9FkHXvOF/2kqE5Blmrv/h+Yk3yB0OvoEhb7tSfss+dBk58aAFRM2nKtl5TgIoZgBjRz+89LAAzqVRqtqbTr/TLy18bDQ+JaDc+PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786356697; c=relaxed/simple;
	bh=VR/FR12up2l3bccBXUXL/3VFyoBK3DsRHlCU42gGUeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx+T7LtljPyCNRVZvSpN9Ve4m1f6WeR/sOOgg6CrrdQtUDbxYpQrj6JF0XcdLbZQLQQ9d5mmDwfUXuuSdM9E0VAPcCwO/admMw2wZCvF/AiM8MRO+B/yj+t1oAD+kMgE9gSbt+CzQMfqu7Q+ZIX2gVvn3IT+aVrdzmPzRh51ZQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJZoByG0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJZoByG0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786356695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VR/FR12up2l3bccBXUXL/3VFyoBK3DsRHlCU42gGUeo=;
	b=YJZoByG0RkLWzSBeCWKs4uWSX05NC/R3JqcvYNEAYHR9yDFbgyOoIxzf1h/SoLdeLq/TRF
	FoEazAocfRaWJfUBjBmeLQhJS812rryjm4GuRJrhcXOeE81b/dYRUV4tW83nxUUzsGV+FT
	v854OBeis0R/9Gj+f3PCishr0jTHQqw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-YiHmMsHdMn2kLv-HX_iktQ-1; Mon,
 10 Aug 2026 06:11:31 -0400
X-MC-Unique: YiHmMsHdMn2kLv-HX_iktQ-1
X-Mimecast-MFC-AGG-ID: YiHmMsHdMn2kLv-HX_iktQ_1786356689
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1D4C195604E;
	Mon, 10 Aug 2026 10:11:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.47])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7E6C919560AB;
	Mon, 10 Aug 2026 10:11:24 +0000 (UTC)
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
	llvm@lists.linux.dev,
	mani@kernel.org,
	mhi@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v11] PCI: Add device-specific reset for Qualcomm devices
Date: Mon, 10 Aug 2026 12:11:22 +0200
Message-ID: <20260810101122.25977-1-jtornosm@redhat.com>
In-Reply-To: <202608101710.4bALXXJf-lkp@intel.com>
References: <202608101710.4bALXXJf-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Please, use the latest version (v13):
https://lore.kernel.org/all/20260721081301.205374-1-jtornosm@redhat.com/
That and more things are fixed there.

Thanks

