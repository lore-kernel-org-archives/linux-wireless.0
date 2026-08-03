Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64351313E2B
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769015; cv=none; b=hBE2dV/DWoP8WXrwnsDJu566sCNHfVpboEmb9d6diaEbFxWMyXfrF6wOXoUoUB5sRkTK1pHYFATenN/sYTf5MU3aWV11A9v3znMtIAnP53PJr88goWGxm9p3ap56Bmzh04HY3WnK202FXFwAKAq5K/9fQfRleNi+17gQnXXTTQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769015; c=relaxed/simple;
	bh=6fLRIeuArlV8OFsJF1bxwW3+kc6bImaHGFUoBw1oG5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfMyde3nGUqxd3Ql6VhMT2TY2+L1VCxUDOLRR0xUJP8MH2PGS/7PpjS/kVBQgezMgZ92ha1D2mJ9RfJK/kGWVP5yPsTbu4TzK+EA5bYfngRe8bInR7xhLlye532SHzKJdgzs0DO3YQK7urehmf9uMQTDqgDohsj9q5R9RTYQ5iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YY/9hsmy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YY/9hsmy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785769012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6fLRIeuArlV8OFsJF1bxwW3+kc6bImaHGFUoBw1oG5I=;
	b=YY/9hsmyndAJed4f2U9okP7M53GY8Ao/NoXyeUxQtI9fFL3Z9LKoDG7E+TBu3KEXyCAeQ+
	Jypjwveex2bd/skmc5RU3tnCd2JtY6kPSw59NTN3zaVYIo6mLBd1jJnLX7LA02ZiveeKL6
	vggRkWaKwooxeukQ6ecuvhNA0hhKdnU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-300-p_L3XEKvNfSxGihHvfnu6g-1; Mon,
 03 Aug 2026 10:56:49 -0400
X-MC-Unique: p_L3XEKvNfSxGihHvfnu6g-1
X-Mimecast-MFC-AGG-ID: p_L3XEKvNfSxGihHvfnu6g_1785769007
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 194CF1800592;
	Mon,  3 Aug 2026 14:56:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.107])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 49201180049F;
	Mon,  3 Aug 2026 14:56:43 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jeff.johnson@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] wifi: ath12k: fixes to improve MLO station stability
Date: Mon,  3 Aug 2026 16:56:40 +0200
Message-ID: <20260803145641.28070-1-jtornosm@redhat.com>
In-Reply-To: <a9565939-0ff0-4672-a733-20692b9f9f26@oss.qualcomm.com>
References: <a9565939-0ff0-4672-a733-20692b9f9f26@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Ok, I will rebase onto ath/main for v2.

Thanks

Best regards
José Ignacio

