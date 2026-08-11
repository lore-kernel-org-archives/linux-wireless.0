Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD94364931
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786444994; cv=none; b=d6OaJzpokzV8fUleOPR1P7TmkgFChdfcrKj1sTWzgT3EZC0cw54sqkia3dZJz0s5LV6AxpUSNByTZAIC/85fbSCkR6z5YCKT0F8Hj9NjFc7RBaZz+BPMFRIbm84Tc6cRgfDpsKi6MbXSYRVGVjbW+eL+gxyvhXLV4BJcEHVlQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786444994; c=relaxed/simple;
	bh=VlaxmCs+2BmBzsrKE46vcfXh8zF4HlemgralQUTmDsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSh9H89BCrpk8rUzCeXajzy3TqqxMmTBP4AEfKrIcBystqJZMR6VjvwB1J8KAHsusO1mfmesWX5CvPu/iB0Zen6vflHzmN7NyxZwr7RL+TElvoL4TlIYWlN3VXpCv/n9KlAXlnUPb2Tsjy9Z+LZRSbpeQf2t/1OZ/NCvCm3eC6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wq8/RsJv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wq8/RsJv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786444991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VlaxmCs+2BmBzsrKE46vcfXh8zF4HlemgralQUTmDsQ=;
	b=Wq8/RsJvW/InVy5l78pGkeHykUPa6TvK76/k+EUnAVTezTJ2hAAVwlbnLNle8imvkRHabg
	v4auDDj84QL/EOfDsbW2WS3BC4fBIr6OkhA2LA9yT02/G/pDrvLni7BmEzi6G5aw/Vj2Ij
	QFJ+bJC/bsyDwNfsvR8MAwuDmhKY86Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-Fc0tHaWRNi-5iXcBc5NOOA-1; Tue,
 11 Aug 2026 06:43:01 -0400
X-MC-Unique: Fc0tHaWRNi-5iXcBc5NOOA-1
X-Mimecast-MFC-AGG-ID: Fc0tHaWRNi-5iXcBc5NOOA_1786444980
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1116A1800644;
	Tue, 11 Aug 2026 10:42:59 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.68])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F2E1019560AB;
	Tue, 11 Aug 2026 10:42:54 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/4] wifi: ath11k: implement custom wake_tx_queue with flow control
Date: Tue, 11 Aug 2026 12:42:53 +0200
Message-ID: <20260811104253.394517-1-jtornosm@redhat.com>
In-Reply-To: <2774127a-01ce-4d26-b8fc-e68f49da2bbc@oss.qualcomm.com>
References: <2774127a-01ce-4d26-b8fc-e68f49da2bbc@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Thanks for the review, Jeff.

Ok, the if (!ar) check is unnecessary if hw->priv is always valid when hw
is valid.
I will fix this and add the Tested-on tag in v6.

Best regards
Jose Ignacio

