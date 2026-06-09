Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F21357D15
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781019226; cv=none; b=dZnrz0LhaZWP40oM2U2J23hMt9DlTIgj7dSDZmvE2W/auy8WLTO8DI9kD79ZHEn4WznjVuM0pAULiY3YeqdTVOyzdnLVGM16h/nItwIb2pP6CJYPKbQ6oG/30S4YsZMT1kBm76SM2vzjxSdagK4MboBcXKV6uHE/47RP9AcJWoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781019226; c=relaxed/simple;
	bh=ui57eud+2jNybnwIgjdXrFY/rFddgm487KTN2pVWv7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfjeoLQ/YtJ3XbNbe9H5Yhz3RH6RQe75U4PsKI4N5zXVVxxudcKmHYKlYaIMqTF/Kdm7L0iUaorX84p6Dbn+gaKB21MTSpT2B80jOTMZFpDMgCoZg9EN0Ti/RN06mCM0NAZArxAePX9jgrEpbWTd95ExBsx4/vuJ68KjHG2a5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=foKDBY/7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="foKDBY/7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781019225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8F188iQhDxLxAZTFy+ZfnH1B/Skq3VaWGOMUwtoZc8=;
	b=foKDBY/7Z7fYaoR/vc+S5Ec9rUYUgtjdl68an6MjGzrekJLaYCzMhtCcl+UVCMhmwn1h4U
	MjaBualBzr0MJFsYrxgccISoM/s+nO12gqw4S/uJOnKG9XhJl4ahLtzlb2JQaVzOkzJw8P
	QXDqbNn5c+ouUSvpefil7P27zIpX/po=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-S3FBmI6dPgOz1skQ8MXRJA-1; Tue,
 09 Jun 2026 11:33:41 -0400
X-MC-Unique: S3FBmI6dPgOz1skQ8MXRJA-1
X-Mimecast-MFC-AGG-ID: S3FBmI6dPgOz1skQ8MXRJA_1781019220
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71F0E195C26B;
	Tue,  9 Jun 2026 15:33:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.77])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4A67D18005B3;
	Tue,  9 Jun 2026 15:33:35 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: helgaas@kernel.org
Cc: alex@shazbot.org,
	bhelgaas@google.com,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	sean.wang@mediatek.com,
	shayne.chen@mediatek.com
Subject: Re: [PATCH v4] PCI: Disable broken FLR on MediaTek MT7925
Date: Tue,  9 Jun 2026 17:33:33 +0200
Message-ID: <20260609153333.70991-1-jtornosm@redhat.com>
In-Reply-To: <20260609144532.GA104629@bhelgaas>
References: <20260609144532.GA104629@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hello Bjorn,


> Alex, are you OK with this?  The v2 conversation talks about SBR also
> being broken, but maybe that turned out to be a red herring?
> 
>  https://lore.kernel.org/linux-pci/20260508145153.717641-1-jtornosm@redhat.com/t/#u
Alex can answer better, but to clarify: SBR works correctly for MT7925e.
The confusion in v2 was because I initially grouped MT7925e together with
Qualcomm devices (WCN6855, WCN7850, SDX modems) to try to fix their reset
issues. Alex suggested testing SBR for all of them, which revealed they
have different issues:
- MT7925e: FLR advertised but broken, SBR works fine (this patch - quirk_no_flr)
- Qualcomm devices: No FLR capability, SBR is broken (separate series with
  quirk_no_bus_reset + device-specific reset)
So I split them into separate patches since the root causes are different.
This fix for MT7925e (quirk_no_flr) removes the broken FLR and allows the
working SBR to be used.

Thanks

Best regards
Jose Ignacio

