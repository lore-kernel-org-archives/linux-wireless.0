Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B7F30D3F1
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785770540; cv=none; b=Nr0rykgMg0om3LIeOQwSVMa9/J63ZLWY77DunM1JNWbIdy1NyUHSwNReYNvclcwQgHnuWzOWLthO5d7t9LRjpwDbGjQ/kzSIWfUJi9eSxvkHKlfnQ21SFM90w9/d5oYezx9RYmDhmZKa2htKsqwTpCfnMe4+QSwCKeKFQXEd5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785770540; c=relaxed/simple;
	bh=dtTfyADUv6UVcav8BCvcrctzmdH4H1AlrLdkyFgcalw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/ymqhR+I+09Audwwve4OKuDEy5GSqAHnLifTYsBDZ5d4SFp2x51hWV0G5EI/TvLrsNpVvtMqhUW1ojDWtmSEZpkzD7CxenZO3bJJHr1mTM/yKPZDvmXCQJYtQO4DFhGejk0QLopOurgA//Sf6O88FXCcOByxHkLUY29FcPg+3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQE1/uYb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQE1/uYb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785770538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dtTfyADUv6UVcav8BCvcrctzmdH4H1AlrLdkyFgcalw=;
	b=hQE1/uYb8XJ2LPauAXdjxSXKu3pu5jtKnQyA3XI6zHxPmmOxYovAdfw44++3yhpbq15xhT
	q0qY1tlswZ4f4/3WF6M771ynK750BnhwRj3heS50yoOGImsVdLVZP+kIcPuN1uAnQnWhA/
	L1lmox6pY4ELRVbxEL62UxNhjqQePvY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-JTqxdCNuPxWns_0NOkXstg-1; Mon,
 03 Aug 2026 11:22:14 -0400
X-MC-Unique: JTqxdCNuPxWns_0NOkXstg-1
X-Mimecast-MFC-AGG-ID: JTqxdCNuPxWns_0NOkXstg_1785770533
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8701C195604B;
	Mon,  3 Aug 2026 15:22:13 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.107])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3ED1E300019F;
	Mon,  3 Aug 2026 15:22:10 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] wifi: ath12k: skip connection_loss_work for MLO beacon miss
Date: Mon,  3 Aug 2026 17:22:08 +0200
Message-ID: <20260803152209.29471-1-jtornosm@redhat.com>
In-Reply-To: <1f80cdf0-2ca8-4b28-9192-b42bd61abff1@oss.qualcomm.com>
References: <1f80cdf0-2ca8-4b28-9192-b42bd61abff1@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

You are right, with the MLO skip here, patch 4's MLO cancellation branch
is never reachable.
I will analyze it better and maybe merge both patches in v2.

Thanks

Best regards
José Ignacio

