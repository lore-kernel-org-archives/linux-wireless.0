Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22C4A2E16
	for <linux-wireless@vger.kernel.org>; Thu,  2 Jul 2026 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782999796; cv=none; b=PWB+IbMaVzoy1lCgcP460pxTHPd51nhfTwQdqSd0Hb3u7PD2WXjpQnhbZbxXV4T+0JL1vmcNuKT/Xe6g9TbGgo+NRWicsOp/EHFCWWb+seml5E/5Jn9b8Al33JmJ0M2hRXIt1wsJvcQJt+7af8AUXIj4QpvMHfbG3WzyjPrvwHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782999796; c=relaxed/simple;
	bh=lnIsV8wu8Wpkp+oh12mCGa6Zdv58CtR2DlfsY94Roz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8qeZpLREPIPqUIahlDbZSkT9xXm0Wk3awHUd/F/M+EEQPjYTx9rVmx9sg3ijcUdguY/ZiWZMd+2Rt0LR1H2ALM98Ik2qyQ1kvM8D7j/llqu71VBdV8GsnvCfp+bC1QZVLlD+MjJzP8IXMWzn1eOI7LOQCvZ3Jwr9T33X+4+CPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bl/bEdF0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bl/bEdF0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782999794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnIsV8wu8Wpkp+oh12mCGa6Zdv58CtR2DlfsY94Roz0=;
	b=Bl/bEdF03ZTBdih1ROKGnW1ymJ50HeJzY1UdwvStTfXoOVNSn1P+VbgLH3XXpyyHyhM8iE
	pT9kVDq+RSJT5r7qRUUmYR+hYBz9JCZTx3V/+li/Ygf4Vzhn0/C0+dJyiUMk+IOWJVBu7y
	wSr8szfIKO8XniIbkmoe7Ox8evKGW7U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-JXIDLPRIPSm4F_U0l_Rqng-1; Thu,
 02 Jul 2026 09:43:07 -0400
X-MC-Unique: JXIDLPRIPSm4F_U0l_Rqng-1
X-Mimecast-MFC-AGG-ID: JXIDLPRIPSm4F_U0l_Rqng_1782999786
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0D061944CC9;
	Thu,  2 Jul 2026 13:43:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B5AD818007F6;
	Thu,  2 Jul 2026 13:43:02 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: jtornosm@redhat.com,
	linux-wireless@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com
Subject: Re: [PATCH] wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations
Date: Thu,  2 Jul 2026 15:42:59 +0200
Message-ID: <20260702134259.1052418-1-jtornosm@redhat.com>
In-Reply-To: <0723f2f3ddb22ce4b9a1c2d075126c8987031a6a.camel@sipsolutions.net>
References: <0723f2f3ddb22ce4b9a1c2d075126c8987031a6a.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Johannes,

You're absolutely right - I had the wrong commit title. It should be
"cfg80211: disallow beacon_int_min_gcd with IBSS".

I've already sent v2 with the correction.

Thanks for the quick review

Best regards
Jose Ignacio

