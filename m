Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A71738F62F
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527487; cv=none; b=gUMOUSkyj+qYnb1o2fwXVrG0C6Q+AiP9Z5VUMi1XAeu2SHgGwmF2W58b7Dk1HOVEcWKCrci707jCDmvMFujZ++vU+uL1yXKM0i3E0dLczSczxyMxGrTKOFn8Jv1H6Ly+LwDBCaSrnZ9VERVGWBqiRVT+HB6kSJlvdUXV8o8ReKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527487; c=relaxed/simple;
	bh=wASILoBgcX+sWiRWB/5Bls46/1SWcDPIaduw/Bu5BtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wha5EMZXMAtxkJaOzPS9XypG0Rte5O95sZFGgExjOK0MF5SfwfZYP/JIF0S/b8n3M3ScC6RR2Vaxsb2ZqDLGXmknBfGjeQcJvwUpdIY8K6dShWWtLlvgL4tZMjORNeH6YjyOi0eeJBgs3t6rPtFeRPrmKgNThzNfTMXz2xdFMTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WxniuUeQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WxniuUeQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784527480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wASILoBgcX+sWiRWB/5Bls46/1SWcDPIaduw/Bu5BtQ=;
	b=WxniuUeQeS0ytCaxHqI/BRCzMrY92S/mG9TL5GAxnkq5nnxVmoIk5jBa0g4g+QhY/3qT6W
	MBFuG8zFze56GnaXKdD+T673laYWbYwr3TZqGPwqSQ4AEKK+lOQHXUj7RRk2KDCdSuUkFQ
	SEQ3q0Q2KxR0dWcvaVwsUh+PuKnzsF8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-czMl9-bpOL67qe-ybEXkiQ-1; Mon,
 20 Jul 2026 02:04:38 -0400
X-MC-Unique: czMl9-bpOL67qe-ybEXkiQ-1
X-Mimecast-MFC-AGG-ID: czMl9-bpOL67qe-ybEXkiQ_1784527477
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CF7318001F1;
	Mon, 20 Jul 2026 06:04:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.69])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BE241956044;
	Mon, 20 Jul 2026 06:04:34 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: nbd@nbd.name,
	lorenzo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com
Subject: Re: [PATCH v2] wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations
Date: Mon, 20 Jul 2026 08:04:32 +0200
Message-ID: <20260720060432.7943-1-jtornosm@redhat.com>
In-Reply-To: <20260702104337.679536-1-jtornosm@redhat.com>
References: <20260702104337.679536-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Felix, Lorenzo,

Just a gentle ping on this patch when you have a chance to take a look.

It fixes a device registration failure (-EINVAL) for mt7996/mt7992 devices
introduced by commit 5ef0e8e2653b. Without this fix the device is completely
unusable, as cfg80211 validates all advertised interface combinations at
registration time and rejects the entire driver.

Please let me know if there is anything I should improve or change.

Thank you for your time

Best regards,
Jose Ignacio

