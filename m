Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB8041DE0A
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 09:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886163; cv=none; b=DhzYsE80e7renZdOQfXmyadbb4rGTU+oI/nge/vnUVSom0DDqExRmgflusz9zTh7uZKWGT665rSVqfeLM+i16fsJsXDAVbqTOBjStbHrJR3aaEgtrsx1YwfZLN4ej+h3nabVCKlpRL/8pVw9rfu+usTp1i/cm1MsoG2tULu4zw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886163; c=relaxed/simple;
	bh=YY8zT4JmqSPdATyDqCCVUYQ0HFP8LkYhfzBPXdqUyvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wy/tI3PBQreN4bAbTMGkyCeGRlJ2GlPgs1oWrEwc0kPj4xE9hUpDc7pr+Ngp3WleJUsiFVPRcI42i4dszfzkhJY8BIjkHhcQknc5l4JWgYwO+/WvWj+TN+xzc/TaSMuzrGurCTGBV+gY8HGbbMBziUMm2knNGODik9UWLa9y5tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MP/wdmBl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MP/wdmBl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784886160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YY8zT4JmqSPdATyDqCCVUYQ0HFP8LkYhfzBPXdqUyvA=;
	b=MP/wdmBl/5bnv66DDwnbxvmi9TOcuWF3UlUcr7+8oWLcBJdzDjzdGrSEbUjsiAhXX8Ot5Z
	yRJFx5C1GJm/2CA0IpS45/R3xogn5991NlJz8tHqtWz7rtTsLdeLxAlhfhmmKIf4M2YZfP
	tmBtfNIsTC5QOrMDlgReC6CmOg6fty8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-380-4kBllGYVNnGpIMs-uDq9KA-1; Fri,
 24 Jul 2026 05:42:33 -0400
X-MC-Unique: 4kBllGYVNnGpIMs-uDq9KA-1
X-Mimecast-MFC-AGG-ID: 4kBllGYVNnGpIMs-uDq9KA_1784886152
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D29D81801201;
	Fri, 24 Jul 2026 09:42:31 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.50])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5667A1954226;
	Fri, 24 Jul 2026 09:42:28 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: tamizh.raja@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/4] wifi: ath11k: use queue mapping for WCN6750 ring selection
Date: Fri, 24 Jul 2026 11:42:10 +0200
Message-ID: <20260724094226.227200-1-jtornosm@redhat.com>
In-Reply-To: <CABkEBKaZOEh4OrZTYfFOj8QZHY8Ruxn2rcXL-axWHwK4o6MECA@mail.gmail.com>
References: <CABkEBKaZOEh4OrZTYfFOj8QZHY8Ruxn2rcXL-axWHwK4o6MECA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hello Tamizh,

This is the same mapping already used by WCN7850 via skb_get_queue_mapping().
The patch only aligns WCN6750 with that existing approach.

Thanks

Best regards
José Ignacio

