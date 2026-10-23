Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792768971;
	b=n9iwJwEmEXjm8sTHaQ3pqTfXHWy7APGYZp09tW/p0Q66WkvB8sl78+SdDdcH+k7kDfdp
	 7V6X3Xnrsa2SO2OhWRsI2+fv+GZBNUkmMbr+piaaMscadk1sUXQqV7F82/UdEeBo9vJy/
	 lCwcSN7PziMI1UV6nEUWN1jwLVVPNoeCRsYlixmhMGJ7AHkb9Cn8PaLVfxH2l2rw0s+56
	 g2fHkc0KwiwsQ9eo5H+UZp8Q3kBRcIfni8n8VPD+aF7lSfe1JFkOYAFGPEHc2QMwGBoFF
	 QvBV1pY2JttBX9DJmeg3S8tWZ1bm/9jEs3UvvGxxwN3FmwAWNZ3pi9nzhfrhFG/caWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792768971;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=/CDx71/tfsWPALCypf77QFDts6odDm6ZB4NI54JYcdY=;
	b=W5Hw74Gb7f9/8g7oKm70mYUjVfhos9Z1Al/FBw0zGeL1YuxYfIhEVVPttWaC82AAdW82
	 2F4p6AZ1lbPFX2t1ly/4CAZermTz1nwSYsSjAjti0g6+O29u/ZOSEwX2pmpmzINbXznUW
	 gCtLSCq7vcqBoG5GdU38BVy3q5r4l3/zwP/soLcqJMSkQOOQIegdn3prYBuccp0bw+lZQ
	 8Jh82PLBaDbf5filwZ+QBUkHqfmwhsrn/DcoU5dV9Dw85AhYIQSt4oie9ZWEsOAZ3MGOW
	 109IhOgTgRszWynHFE7/qT9/QX/k0WKI1p+HvMSjnjvU2OWYUOM9kQZD4O6GD/oiYIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Qxzy65jR;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8F7606A321
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 15:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA8F7606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Qxzy65jR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792768970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/CDx71/tfsWPALCypf77QFDts6odDm6ZB4NI54JYcdY=;
	b=Qxzy65jRSbFtrxd9DZ9cQQH7IZldOkRCsMXVqIMJ0NTu7FjhG5mJWLNcfmesqLhnfjWym3
	PdVnq00NDQ8tR0sVi/JhHyGLsgp41Da9YCZk7J3JWSXkQAbECPMf4Bgbx7axUsVPNXzdbC
	Av30m0C9lEagb0FNNxlgnA8q7kmTuZM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-OhLi541-PV-XZX-osD665Q-1; Fri,
 23 Oct 2026 11:22:46 -0400
X-MC-Unique: OhLi541-PV-XZX-osD665Q-1
X-Mimecast-MFC-AGG-ID: OhLi541-PV-XZX-osD665Q_1792768965
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F208E1800758;
	Fri, 23 Oct 2026 15:22:44 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 204081956089;
	Fri, 23 Oct 2026 15:22:42 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: egrumbach@gmail.com
Cc: johannes@sipsolutions.net,
	jtornosm@redhat.com,
	linux-wireless@vger.kernel.org,
	miri.korenblit@intel.com
Subject: Re: iwlwifi: AX210 firmware ADVANCED_SYSASSERT 0x2010120E on MAC_CONFIG_CMD with ty-a0-gf-a0-89
Date: Fri, 23 Oct 2026 17:22:36 +0200
Message-ID: <20261023152236.533085-1-jtornosm@redhat.com>
In-Reply-To: <CANUX_P2oQDo6_A4w1e6a9_483aFy+iN07P=FyDJyeV6=xBUSYQ@mail.gmail.com>
References: <CANUX_P2oQDo6_A4w1e6a9_483aFy+iN07P=FyDJyeV6=xBUSYQ@mail.gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Emmanuel,

Thank you for your help

> Can you please file a ticket on bugzilla?
Sure, here you can find the ticket:
https://bugzilla.kernel.org/show_bug.cgi?id=222185

> I'll ask you to provide a firmware dump and we'll try to see what we can do.
> Checking the conenctors or any physical aspect of the device can be useful.
Ok, I would need some instructions/reference for the proper firmware dump.
I didn't think of the antennas because the firmware version 86 (Fedora 38)
is working, but I can try it. Anyway, since now it is reproducible, I will wait
in order to get the dump.

Thanks

Best regards
Jose Ignacio

