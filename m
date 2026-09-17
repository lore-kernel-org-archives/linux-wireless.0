Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D648649505E
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 10:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789639310; cv=none; b=Ux7NgOJdflcyEIAQ9HWd1dmazNSE1Lm4ooPjYVF1SG9iY29v74dNYab+hJ0BDufpho5PEzb5h+zsRmUeMAPGJEXhk60osmM30ytAKvlk389+uo7uEY4RCpo7pK10ez/9zuo46KUc6kNwGsQQACoRgZ2UR64+hvTQzWhMAdw8uuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789639310; c=relaxed/simple;
	bh=0FltFsY6ankPumYo1oeKxNcQO+Ae9X3mJpO+iWWNVrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/XZuQQZogQ8lFH1snDDrvnhnqWXmhm19OuR7rBcoeJ6VE1/bI6lMQN+CtXuMCQzXbsNZcLTaQ1UILAucxDzsqGyfudBJ4XGirScCA5CXcRKMJmID87E+UefmZaGKaxUI/MZ9FV77jALYlPFMp0j4zWFbQvLjt8uZQk9aArL7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SkYDjtFz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SkYDjtFz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789639282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0FltFsY6ankPumYo1oeKxNcQO+Ae9X3mJpO+iWWNVrs=;
	b=SkYDjtFzY6LLUgk5+yAU5T/C+OVD6Kp63dG2o1+WE2mxCJdjTUJPv4chaH713g4WS6/XMN
	vUVsEWmjCbgEAbvYDiUPD+6R4gwfjOGvlOzYUxdw7zlmZzIVJU6oU+lHm3To6t+CO+VuRW
	lgit/Wdp6uE/VwIk+Fda3gMVw6lnJxM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541--vhghsE7NXybKx5g-qswkQ-1; Thu,
 17 Sep 2026 06:00:56 -0400
X-MC-Unique: -vhghsE7NXybKx5g-qswkQ-1
X-Mimecast-MFC-AGG-ID: -vhghsE7NXybKx5g-qswkQ_1789639250
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E53291977008;
	Thu, 17 Sep 2026 10:00:49 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B6541956089;
	Thu, 17 Sep 2026 10:00:47 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: nbd@nbd.name
Cc: ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7996: fix NULL pointer dereference in MLD AP recovery
Date: Thu, 17 Sep 2026 12:00:44 +0200
Message-ID: <20260917100046.31142-1-jtornosm@redhat.com>
In-Reply-To: <20260727161353.962426-1-jtornosm@redhat.com>
References: <20260727161353.962426-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Felix,

Friendly ping on this patch. It fixes a NULL pointer dereference during
MLD AP recovery caused by stale valid_links after full hardware reset.

Any further comments, or anything I can do to move forward?

Thanks

Best regards
José Ignacio

