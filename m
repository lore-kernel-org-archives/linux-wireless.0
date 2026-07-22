Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA4943CE7A
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740309; cv=none; b=FEXDzmGHmEYbcfDCTEhtbKYmhahC/O0+e6A1RQbxXy523Rsm3Gm+6ocZj0GQ1QO/t+eApF02/k+rXShFpe1kDTQuOs790h+P3qBYyXA4QD5GdHlYET9gOmQnHFuuG175nNnpyw+X5Yxd/Zp7BCM8HR/Bnug0Ku5IM8SOFYxofhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740309; c=relaxed/simple;
	bh=RzfSmIMBg5Zu645nMhfIQg3Rlp0CR4eLtJ/201cLgiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/sKmrUklkse9X0E/TKeBVG6a9ieXd8veqdKyg6UwrsYHB8tNOk1k0djP4KygYaigm1dDUTOSO54Snydf+IhT9b5iRpvngLjyd9DtskMeBaUiZO+bH2F6npT9alJ0KktdTSPN8j2eJcXyB2iYraiVL46QQGUZlRHrC5J6fyaTi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ok+9Dpom; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ok+9Dpom"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784740303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RzfSmIMBg5Zu645nMhfIQg3Rlp0CR4eLtJ/201cLgiE=;
	b=Ok+9DpomRDF5P3SOdTluPRG2dtUijzCXSP8ekb7Qb3uHeEvfzBZVMMi2iowNBOftWiDrmo
	XA1digeLu1Fnzrw+E8qlyZwWrpTWCOnn4eoo7UVQR1TJMozV9YB+gE83Xk80ShAcW8fiXT
	2XhL5xKRA3rFNH86ViXc3bqzxRlLwcs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-T1iGTCcONxicw4fmm9AFNw-1; Wed,
 22 Jul 2026 13:11:38 -0400
X-MC-Unique: T1iGTCcONxicw4fmm9AFNw-1
X-Mimecast-MFC-AGG-ID: T1iGTCcONxicw4fmm9AFNw_1784740297
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E3091805F0D;
	Wed, 22 Jul 2026 17:11:36 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D166D3004181;
	Wed, 22 Jul 2026 17:11:32 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/3] wifi: mac80211: add ieee80211_tx_peek API
Date: Wed, 22 Jul 2026 19:11:28 +0200
Message-ID: <20260722171131.262239-1-jtornosm@redhat.com>
In-Reply-To: <c913114343692dd201da3af8f05fe1bc356702a8.camel@sipsolutions.net>
References: <c913114343692dd201da3af8f05fe1bc356702a8.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Johannes

Thank you for the review.
I already had some concerns about the peek approach during development, as
it was difficult to implement cleanly.
Your feedback confirms those doubts, so I am reworking the implementation
to avoid the peek API entirely.
I will send a v4 with the new approach.

Best regards
José Ignacio

