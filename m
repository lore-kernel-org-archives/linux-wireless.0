Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB5C40EBA9
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 15:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769371; cv=none; b=ZKjTyeW1GORJ4jufllzbK1ejbZR+iQrSKlrG8fNbslbGe248nAKRG/sYDhPjbEmfTt9BEDZYtZkYH0zgPuc6HbO/kwS2mlVwGxUhYY28QVwQrJbvWJ6YRngAPFFGY6k330m00SsT27XbmxqFToLyYnQ6/Sqdbud1/lq94lC8La0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769371; c=relaxed/simple;
	bh=dWiiJckTVDVzLcARnbHfx74nS0LLRWR4IWZsUe6MJL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gn0Hf1ySmHUVN8r1bxm9MAVqFCDPe06+sH3rLS8stiN2xv0xwXYsPrWrT0Hc671/9rJcEacvd7lj9wuXq3mlKHuP9VABtG8xm4sxCkoiokDrM1dKZmJUXzI2S3kkD9JcaZNscgKCFDAMX6awEDUbYeUkbaLRIDPfIMidwInG5H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OT1jczKX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OT1jczKX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785769368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWiiJckTVDVzLcARnbHfx74nS0LLRWR4IWZsUe6MJL0=;
	b=OT1jczKXtFWy0cgztoqoqAFjLj1BRSw0TYSDl6blCbRPhhugvxt5IpdB3EXK0ckg8/TcSH
	cKthtvuKJIvUdB9ij7DOS4HB0o9HyYhNHqdWNMsBMIIl0fk/LRw6Q8Th+6hKLVVD/ZfZcL
	3EmUpH1zEtSew+pX0TOmQz4LWiRD2GA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-V0rD9lFtMCWaoOeB8dNFuA-1; Mon,
 03 Aug 2026 11:02:43 -0400
X-MC-Unique: V0rD9lFtMCWaoOeB8dNFuA-1
X-Mimecast-MFC-AGG-ID: V0rD9lFtMCWaoOeB8dNFuA_1785769362
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE38D1954B14;
	Mon,  3 Aug 2026 15:02:41 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.107])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 98CE31800480;
	Mon,  3 Aug 2026 15:02:39 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] wifi: ath12k: fix MLO station firmware crash recovery
Date: Mon,  3 Aug 2026 17:02:37 +0200
Message-ID: <20260803150238.28362-1-jtornosm@redhat.com>
In-Reply-To: <0ed1f684-1b3b-411b-87fa-929dc0f8f7e9@oss.qualcomm.com>
References: <0ed1f684-1b3b-411b-87fa-929dc0f8f7e9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Ok, thanks for the catches. For v2, CRASH_FLUSH will be moved to
the callers to avoid a layering violation in the HAL layer and I
will use the correct radio's ab instead of radio[0].

Thanks

Best regards
José Ignacio

