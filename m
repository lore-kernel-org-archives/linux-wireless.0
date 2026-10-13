Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB4551CF65
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910012; cv=none; b=V6HSeCnljavXFp6FsjCxZ0V0W8/K4wf7Iae8xoT8W/T7id6HJcxBmaRi2yuDwB3IUiIlH9GiSnUOkcvabYfkwWfvFPX80VgL1urTsdzOfM+V5IJMolspjVtHzixtMh57IhIkmcoqEE0jik0h2t4hAnkpDZmcs3QmCRjhVa8f52U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910012; c=relaxed/simple;
	bh=cpuFSJHGfxMv/DIFz6fwhLfh8AMSAm5kBky9M0SJgZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNyx2B1KthrjTg1SI9ce49neXymh8KjnHFneKiHLGOSeAKinQGzyT0vnDSpilzwZfafP0KEY6icnWjmdlVkUZfpe0mFRY6UuOEjm06HsgDy1n86+FpJFOLFKqvaHQq4catLVscJctai+Yu23oK1PZqgAaveH+jHFNuZBsruhpiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=adOZ40/b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="adOZ40/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791910010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeUXwYP8/FNRFS/9a5waWcvU8Fc4oxwHviZo5ZlClWA=;
	b=adOZ40/bCs43ssjnFZRCJw+YifBWZhw6yeKfTyeqZwIwFwnRb+szj6TdagVjjn22QSp13k
	D+4ln+dJ4huk3AjzcYhqTYw2leCJjI3f+iNkWE0+SL00eZcTzjxcGAhTpp5l/rr4Wft/V1
	lhIAIa8b3sneQzpHKioPbl57YaCntyo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-IGwXJBi8NjC_dVumhGwqZQ-1; Tue,
 13 Oct 2026 16:46:44 +0000
X-MC-Unique: IGwXJBi8NjC_dVumhGwqZQ-1
X-Mimecast-MFC-AGG-ID: IGwXJBi8NjC_dVumhGwqZQ_1791910002
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BCA2180076D;
	Tue, 13 Oct 2026 16:46:42 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7A66B1956095;
	Tue, 13 Oct 2026 16:46:40 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jtornosm@redhat.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 0/4] ath11k/ath12k: implement TX flow control
Date: Tue, 13 Oct 2026 18:46:38 +0200
Message-ID: <20261013164639.237064-1-jtornosm@redhat.com>
In-Reply-To: <20260917064825.12747-1-jtornosm@redhat.com>
References: <20260917064825.12747-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Jeff,
 
Friendly follow-up on this series. v7 addressed your spin_lock_bh
comment, and I replied to the rcu_dereference_bh question explaining
why ath12k differs from the ath9k case (happy to do it as a follow-up
if you'd like). My results with VMs are much better with the TX control,
and I think it can help baremetal too.

Any feedback on v7, anything else I can do?
At least, would it be acceptable for ath11k?
For ath12k, if the concern is the locking, the rcu_dereference_bh
refactoring would require changes to existing mac_op_tx code. Is that
the direction you want?
 
Thanks
 
Best regards
José Ignacio

