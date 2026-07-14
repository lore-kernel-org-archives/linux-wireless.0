Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCC3890E0
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2026 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784044970; cv=none; b=XBNofU6ChFJDPBPG0jlj6KXoGZvW8sWZWMaKYLDC/GvJzf5/bnhV8UNDpVClL9ylUcjYhnLGzYU4da5HRPEZzQnMGQKmokoKWJaljfBeXlwDFbvOkLyq34OMhYuN/Loftf5Cq7lAqnJcxtt6TuROmsP07vm1x2/2yERmrQHZcX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784044970; c=relaxed/simple;
	bh=7gzRHDdaQ8XnD3vFMga3+B1hXeSjtRDQXoAX5zitGVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrI18ZTyZ0Ccb0jCV06FXKBUlDkrTIH6TLRNGB9olz4eLl6pkbQmYx9WrpY3bY1jf5qsdz5I2k+NvRSPxUKReylyx9ftscRHz4XMgiAzIVCA4ImID/pWynUHTO6CzS7+JeVV+MpzjfXt0zEMDy6lntf61Pkw3NW4HPZ+dyn8swg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZMP466a4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMP466a4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784044968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HD+/nSixqFwhUNrYPVI+z6DSeUlu21xZXSgevbF+e4=;
	b=ZMP466a4e7cPos9ds3e23HoF9ceZBfXczi79udjSYuFAAe01Tz/7P7k+sbmEd3mvkSRZ2c
	K5qCo0CeyUD1vcBU/SaDlFQxfxR2O00y09+awHhmQOy37anBAw44V62QS+gATzEDclJYP9
	vn/8e/EsFoUF5JcnR1pbMnzX7eAZqcY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-mGULl9C1N_i7T2PYcjMyGQ-1; Tue,
 14 Jul 2026 12:02:45 -0400
X-MC-Unique: mGULl9C1N_i7T2PYcjMyGQ-1
X-Mimecast-MFC-AGG-ID: mGULl9C1N_i7T2PYcjMyGQ_1784044964
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C572D180025A;
	Tue, 14 Jul 2026 16:02:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.50])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7833A414;
	Tue, 14 Jul 2026 16:02:40 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: hujy652@gmail.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wifi: ath11k: implement custom wake_tx_queue with flow control
Date: Tue, 14 Jul 2026 18:02:38 +0200
Message-ID: <20260714160238.664089-1-jtornosm@redhat.com>
In-Reply-To: <CAHGaMk_FbjCShGw++0m9UT+sK+w23okwvx1vkqid6n9M=WScxQ@mail.gmail.com>
References: <CAHGaMk_FbjCShGw++0m9UT+sK+w23okwvx1vkqid6n9M=WScxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi Zhi-Jun,


> While you are reworking it would you mind looking at the previous attempt?
>
> It tried to follow the behaviour in ath10k but lacks throttling mechanism.
>
> https://lore.kernel.org/linux-wireless/20230501130725.7171-1-quic_tamizhr@quicinc.com/

Thanks for the pointer. 

I have looked at Tamizh's patch and the main difference with this approach
is that the ring free space check is done before dequeuing, so the skb is
never consumed when the ring is full. This avoids frame drops and the
-ENOMEM errors we were seeing.

I think no additional push mechanism from TX completions is needed since
wake_tx_queue is called frequently enough under traffic to resume dequeuing
when ring space becomes available.

Best regards,
Jose Ignacio

