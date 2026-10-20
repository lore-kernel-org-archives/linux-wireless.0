Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536409;
	b=2AfWPx2RsPwLh008cclkruIJbhn8WF0JwbqalBIduzT08vpXJrOaEgAeCz4ursoyf9w5
	 El34US/QY28lZhy96sdEQM+I8E71oYqmp7atZH2PuC2MUDv27dU0jJef/3DMbmWmmmNBA
	 okuJoEJmehr7+9uLtvLdptfXsd2p1NYywQcrDvaAUrBgMyArfbQGqIlpP8XfWJDn8fTKc
	 9l93aZukVJg77ihu22KFvyVu/E4Om0EDonreq8GpOmwZfCsTRm2IWQV7+AQ978iT+AT/6
	 vR5w6u1ApFgri4dY5RDimq8NQFuAJn6zLGIQkdzKX0V3+OjC64FQhOrbuNFqy3afD4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536409;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g7DYkFmnYLBZzg/Tke3+5rre+MI+fJIUNeaYE/plxG0=;
	b=ARwkCyRDD+4wO0TYuVOaYjXZ2nrrSk3eg8tV1Jowjxb1gAjrxls9oJJX3S3Mg+W6ah6V
	 RodEaG9HDdpLwWy76bhv781h6khtI6fqtYyGv5bmTYm+iL+9wkRE1PLWXZomv7bPpyFb/
	 gs9NwbqVEblrvkMd1sDfZiqxyFSrGQlEbsLF0h9ikWMy9zyTnegG9FBg7dgR89UvepAa6
	 W/IGQrF1TubiTfoMW5LBjX/Bf8GNkHBWmmPJvHIsl7Zjdyu6VIYtQfAieKnEvoeIevOsS
	 ErjZK9O3YUVO3QTy/VxcB87dhEItJroIBpoZUjmuXgMtWk9F0K2H1lAQzomSQWU5ifw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=msj6cVaP;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0212606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 22:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0212606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=msj6cVaP
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f30660e69so9189285a.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 15:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792536407; x=1793141207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g7DYkFmnYLBZzg/Tke3+5rre+MI+fJIUNeaYE/plxG0=;
        b=msj6cVaPhol8uStwU+5oJrv56lIYgD7FtBi0s9zGgRAn2c9m5/uZjwR0RZuFNY+ios
         3ZbGMo44ynIWbe2yqcSioTFBIEX0ZW1Yy45sj4bO0I/Ve3HQNxWK/IOlsoFkFcD7Kc7+
         z+G0JPV1xdIFXywZQYESwZFGkh+GtAsaBIvuDO4Q9tll61D8qWQDDmOulC+ho2SOUNdx
         4vsLtArJkAOv8/8WJ0AKV9bqGGRmHQPoGCZVv6bxgod+XF5qRNwiRnxkKRtQu6HIF9cn
         EVhBgNCQvfMIp7FACJO7wlELPjiljJH02clZ/ZudJEP8zZ2lCHmkRHT4eEufrqIFmVT2
         Axxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792536407; x=1793141207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g7DYkFmnYLBZzg/Tke3+5rre+MI+fJIUNeaYE/plxG0=;
        b=N0iaHtNCoMpoE3mv72uM4O0+Z1wLbIfRo3v87Vzrf6wfO9+qxW5uI4cN7FkIn/VdlY
         jKAjphkbSd6lSAEw9mHB8hJFtLvVVj5uaogNo+UCo4u+TGnNuPs9uD3keS0TQtMPTxON
         hx86Y3Pz0hzV3t4ma7A2EAXCAQm+1pYbJxybR58Q+8Gmc4+Vv0DNi4HlTvaofX4YjH5q
         9r8MFbkYhHlHR4sSNqmdsHtq66NoOEPWwmD1wduNmrywH/5qWxz0eB3rx0LZydhbUULt
         nf9ckoO44ob6VGgrP94WEUPuslxiJ2te31hb/oXGYv+B/2D8DoONZOde17z+mOu7p2wF
         AS0A==
X-Forwarded-Encrypted: i=1; AKwUvBz3OkiikLH3lXktzXiQDG7QdGe2RmRpoXTc/Sibs7tLzMFmzZNZ3amGAceqQrycYISRtd66eXGJEtLWr632CQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJva3QSFQ4/AtOpabjXJ6yzxLBM7D06oKw5cDGXm1POZkaZmUgm
	iMc7DUjMNEk7aBI/X7Lp4pnSzWdG8SGyl5ymTrVxt085Uw11MIIL7G/W
X-Gm-Gg: AYBFou1EZK1N4JR/CLPoMdIM4gbPPShli/nqm98amH0GslThdHnFuOt3faELEsXr/Ti
	kNQipumE0zSYEdAzGba2VmvwGWLj2W3IGO0rClCLjj0m1PuA4TkKfUswhhUhel5jWusbwjO3Ic2
	XhsqIaUha6CcJiX7o08cpDIPzLs4lmjNVUFh93bKG6qgSgEA0hZLGPDRo833NkNHzUJT+YH7Dw6
	tSMaONlbWy/CGbCfRaPV/5mV7qAXOwpHmaTVJkIoRZiyE7BfVrNw2m08LPi+NRS4BSZipL47++U
	zFU650LDaCj0k2a3DLvNfQfZyHrQTIOgQykCb2e+91CFj+/beO+0PzYXxdKOPe1EmYv3mZ6Ux4P
	rEsfN0PIM4EchKj1EEpKPA/KzGUotT9XEJN8pV4pCIzflW3F5oxCgYfpoEjtxiu9fY0ex78THIt
	wNIpEeApdBtw5Vfqxqj8tojBfuPb/y4fdNkrd/D6mM2Q4neKjVNd7h9D/QjEqW9CGPoEjrsx9yx
	hgafXSH5fNK61tCIpUQF7tMpgYUsa/5IZQH/N2mzddb7w+QCk1R2VdaDoMUZQ==
X-Received: by 2002:a05:620a:29c6:b0:93e:4e1e:aafc with SMTP id af79cd13be357-93f57f2324cmr133047985a.36.1792536407681;
        Tue, 20 Oct 2026 15:46:47 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e005b7sm95533785a.30.2026.10.20.15.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:46:47 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH 0/2] wifi: ath9k: fix WMI command response handling
Date: Wed, 21 Oct 2026 00:46:44 +0200
Message-ID: <20261020224644.3858280-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261020152412.95560-1-mike.michalo@gmail.com>
References: 
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

Hi Michail,

On 2026-10-20, Michail Andreas Michalopoulos wrote:
> I don't have access to an ath9k_htc device, so this was not tested on
> hardware. Mehmet, if you could give it a try on your AR9271 that would
> be much appreciated.

Tested on an AR9271 with firmware 1.4 as an AP, on 6.12.113 with the
revert of 93ce8ea70451.

The AP comes up and works; the empty responses the firmware sends for
most commands complete as before. A test build that delivered responses
twice had every duplicate dropped, and with tx_seq_id started just below
the wrap, 0 was never sent. hostapd restarts, module reloads, USB
unbind/bind and a 30 minute soak with traffic ran without a WMI timeout
or a kernel warning.

Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Thanks,
Mehmet
