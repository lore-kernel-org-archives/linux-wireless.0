Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792511100;
	b=qX/705VLmlTtpWqj4XNUzddjbt52BJNwZZInkvNzJLVopLSnwpgqtHhQXv4eDvXbsWtU
	 8YZRtR/MsyuXxwmzrfOymJRpBiKpBnDVGAMBNdXPO6gdAemPAfK6fEL8f0+EqjFzFPPWt
	 K8oKI0zlI/hxaItqtWMT35NOIoumGvBKO66dgsnOAKymeKj4Dn4UMcnOSSpLqyM8r3BNd
	 i2hOHuTJFji1ozkqFoCz2Cfuu9+EG/DlmwRuP90hXJClL9zGxafirmnrl2OVtysKVInSC
	 KgKE/G/MD2u/hqFQEAsVFFS/NfRkI6lWpv3j8IUWal1BW5aQid3o68Wj75KCbN5ctjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511100;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=i1mO6MuWQfpqagLYjVpfTRaUcgdVFipQ47H+IkmGB/Q=;
	b=kX1y6ju/7eXnQFhUMHNSB4d3bPEt5U5ezeYVA2S+WT416RgB7RFVp6qo231Spcrmno2J
	 hoEEeOszDT0okTe6R+D51Xv0YEhHXeltYF79w8Yhyl+Qz1R0vLZRnE+zqLilcL+z7DNYB
	 PrbbBNbMMEd+4G67fws0fY1PUbjxaEKjqMv75tHsaumTvp2ts29I3s2wb0EQJRen5zvPc
	 TFoOicVPHqDWJ/tM6hyC9gWJyaTY+k+vEq731u18PgfXGdqA+RoDi8z/C9x0otkavJpRZ
	 Orbpzs1QVCK3RM1GXtPWLDi3c2mhep9j7rFknC4V6wQ5h2StwpYDcnSFrL1QL8g3KEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ALN4k2ze;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BE8606A32F
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3BE8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ALN4k2ze
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792511098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i1mO6MuWQfpqagLYjVpfTRaUcgdVFipQ47H+IkmGB/Q=;
	b=ALN4k2ze81rS98CsHTcuyaiNRTvGyqNLhHaRKMOuh6SQIFqmlwYA8PlCMVQA5G/p1h8Adb
	WXF3jErKC3T2lPi50vHVRC1p7KtC24V+hfaORV89zAkMLB4sPC7bMn41uQ9kw97Ysg1M0i
	JUra45fLp2kPSrenPNds1oIntIoDX+w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-164-wZzDOMMSMDSlMPLuSJEkog-1; Tue,
 20 Oct 2026 11:44:53 -0400
X-MC-Unique: wZzDOMMSMDSlMPLuSJEkog-1
X-Mimecast-MFC-AGG-ID: wZzDOMMSMDSlMPLuSJEkog_1792511092
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B98B618003FD;
	Tue, 20 Oct 2026 15:44:51 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E8315BC;
	Tue, 20 Oct 2026 15:44:47 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	johannes@sipsolutions.net,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fix MLO station firmware crash recovery
Date: Tue, 20 Oct 2026 17:44:45 +0200
Message-ID: <20261020154446.2131752-1-jtornosm@redhat.com>
In-Reply-To: <4f2a06f4-601b-4e96-826b-a5453bc03ec9@oss.qualcomm.com>
References: <4f2a06f4-601b-4e96-826b-a5453bc03ec9@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi Baochen,

> Johannes doesn't like option 2, let's forget it now. Instead, are you interested in
> (working on) option 1?

I can study option 1, but I think Johannes pointed out that taking
rtnl only around cfg80211_shutdown_all_interfaces() could not work,
so it would mean holding rtnl for the full recovery (~1.3s). It could
be a significant rearchitecture of the recovery path to not take a
lot of time with no response.

>> sense for you to land this series as an interim fix while that is
>> worked out as a follow-up?

> Jeff can make the call.

Jeff and Baochen, in order to get some fix, would you be open to
landing this series while option 1 is worked out as a follow-up?
Happy to continue with this.

Thanks

Best regards
José Ignacio

