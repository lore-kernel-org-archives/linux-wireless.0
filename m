Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A4F51DAE9
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909882; cv=none; b=m3g6zDJh5qs9Btt1FHljFUVRnbpjc7+WJcocJch0oxOCBC+BtFgsQNYBFPT7PY+lZ/8Hz3UOlOwW0loru3NzoypI2lMeugqnL9gabppuxt4Tf2SawuNuQMZr8waXWuWZSGa4hofsw8nOVNNTViO33gG9odUeMWbk7dzeENpg3fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909882; c=relaxed/simple;
	bh=Q5tT5PaVyLvkznsNtS7swqhqenCbpkuaeBB/vaVxQKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FO+T6lCewJXtLehFvjAxF1BE6O2Pec+oZO1kX5Ub8y1/FDbC5vyn1KR7YXhtpxiHfTfq2A8NS8c2j6j/tRYW9dwv0ThnJ1kWHqNfXhU1eblenNMVt0c+r+00NFGBy5MuUh/HTOiDCC5vuReJgTgQrEyaRDyQzDONe+RRS3QFb/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7P4lb3Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7P4lb3Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791909879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rvuVUKSrndopolcbkINdeWPhSExNCeI8jvU0JnOyCeY=;
	b=Q7P4lb3YdGCbgVjccuplQ+ewK3gMcxx44ZhocbbuQYg9Irn4LaWXBf37oZVcWa1+q8DVQa
	nZf1bVvZY1dpCpqYpFdU4PyJ/TaHfl7+QrdxUddkVEbOVQLAtJeCfXObRSTuk4QMcoPHXM
	TZjB/xcMTUYlLndz/e0ZyJNlIH8rJFE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-1DkudKECO2ya43ctc4eSiQ-1; Tue,
 13 Oct 2026 16:44:37 +0000
X-MC-Unique: 1DkudKECO2ya43ctc4eSiQ-1
X-Mimecast-MFC-AGG-ID: 1DkudKECO2ya43ctc4eSiQ_1791909876
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE3701944EB2;
	Tue, 13 Oct 2026 16:44:35 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ACA0F30000E6;
	Tue, 13 Oct 2026 16:44:32 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jtornosm@redhat.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/3] wifi: ath12k: fixes to improve MLO station stability
Date: Tue, 13 Oct 2026 18:44:09 +0200
Message-ID: <20261013164431.236842-1-jtornosm@redhat.com>
In-Reply-To: <20260804175004.1761075-1-jtornosm@redhat.com>
References: <20260804175004.1761075-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Jeff, Baochen,

Gentle follow-up on this series. Without these fixes, a firmware crash
during an active MLO connection results in NULL pointer dereferences
and 20+ second recovery delays. Non-MLO recovery works fine; this
brings MLO to the same level.

v2 has been on the list since August 4 and addressed all v1 feedback.
Happy to rework if something is pending or can be improved.
I know it is better to not have recoveries, but if there are (I have seen
some), we would be covered in a fast way.

Thanks
 
Best regards
José Ignacio

