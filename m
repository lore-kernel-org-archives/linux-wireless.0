Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12E73A8FE6
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 07:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782805635; cv=none; b=kY3FI95LHBsfzI86Hzy7r7U0IzfVqZKRE+JuKIosCw0Nj0eYwyhBXOY9+AtKnxCQY1sh8ZjMbkWgRV33WsKxqzLlzMWynvh9vptQfViMEIXEcpPzLIEOT17hI6FJ6Bz8SzOlHsNCfIHOMiAi66NpzoOMED5lJ2kiCJWxYDsa9Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782805635; c=relaxed/simple;
	bh=BaJn7vumhdH+2YNMOTwDWNQeEsW4AGdWx03TiZX7Th0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixl6JUQ8y0oyBcBkN/Bj4eQoI1VphITrkX9PAG+XkI2hRuc23OLjb22IzdqqQ3HSetc25dOSeTtZizy/d3V0zcR0yhDZ7c7gD/x0PGSzwOMcoC7OU1bKbfPK0yFQcn7atthGgmOAMHj2AvYPHzLDZ+GsHoi4u4bPb2Pn9VUD2V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SIO8OwPI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SIO8OwPI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782805633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BaJn7vumhdH+2YNMOTwDWNQeEsW4AGdWx03TiZX7Th0=;
	b=SIO8OwPImfl5DufaXiCDMfsT8n9kiozpvjZ5UC8HZyZe+35RUUfRiOhTxflkz9PwEnUmp5
	G4j/9NLYVfDTo61IIV9wz0klQVb8ErO/1XglEV71RBwEpoIMApxXTNHBOuathdaXRGEzXN
	ZZZXa/qp0ygTv+0L2irr6Vt3bDnQYZE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-8W47WlKaP7WI1JVq5tqMXA-1; Tue,
 30 Jun 2026 03:47:08 -0400
X-MC-Unique: 8W47WlKaP7WI1JVq5tqMXA-1
X-Mimecast-MFC-AGG-ID: 8W47WlKaP7WI1JVq5tqMXA_1782805627
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E33B21956047;
	Tue, 30 Jun 2026 07:47:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.35])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D834180059E;
	Tue, 30 Jun 2026 07:47:04 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	miriam.rachel.korenblit@intel.com
Subject: Re: [PATCH 1/2] wifi: iwlwifi: enable MFP_CAPABLE in FIPS mode
Date: Tue, 30 Jun 2026 09:46:58 +0200
Message-ID: <20260630074702.202759-1-jtornosm@redhat.com>
In-Reply-To: <a9578988af110a0966cd2bd236e6044ac5e7a70e.camel@sipsolutions.net>
References: <a9578988af110a0966cd2bd236e6044ac5e7a70e.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Johannes,

>>> There's probably something to be said for the second patch anyway.
>> Good to know, should I resend patch 2/2 separately, or would you like me
>> to wait until I have the customer use case information?
> I think we can just take it as-is.
Great, thank you!

I'll still get you the customer use case information once I have it.

Best regards
José Ignacio

