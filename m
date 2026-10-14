Received: from forward501d.mail.yandex.net (forward501d.mail.yandex.net [31.44.14.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5A54A2632;
	Wed, 14 Oct 2026 08:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=31.44.14.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791967252; cv=none; b=RAGRnBFsaRgbzCbaDrLx9XuqMDNQGYEzinRJ7UoyrP1ERa4wK7CaG17hdTZ+1ivfp8PDDDazxqg2g//rLwAxj4WNj7JKUXMLQfTzWwKlEl/8d3zPyYC5eVPfbBkIaWT5ylnm97dtMsXoy84YNp6Q798HA7op8CzB81KxrMjzXTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791967252; c=relaxed/simple;
	bh=reISsblVLVBUSDj1ORN2fpRl1kDMtHIMB7XNItMAv1Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=EL9FM0t6Sq0C0ROPa6DzpRSDJa9+JgO5YWuh3auxkv30LIYBMzqWbaE+gTI19KXfe3pX1dJfHmnMPu93VTbN0RNnRcw40AuLkBTn+UJOfFGKTmmI1Zh1kj73OTZnqc0PNDcbmByEoMipJyCvldzmrXOz5/Di2YQJ6PkuvZin4ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=WI3km828; arc=none smtp.client-ip=31.44.14.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="WI3km828"
Received: from mail-nwsmtp-mxback-production-main-60.iva.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-60.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:6718:0:640:45f5:0])
	by forward501d.mail.yandex.net (postfix) with ESMTPS id 4E3998B9B7;
	Wed, 14 Oct 2026 11:35:11 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c0c:7888:0:640:d17b:0 [2a02:6b8:c0c:7888:0:640:d17b:0])
	by mail-nwsmtp-mxback-production-main-60.iva.yp-c.yandex.net (mxback) with HTTPS id 8ZPi9s02JiE0-4a05ILdO;
	Wed, 14 Oct 2026 11:35:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1791966910; bh=QFT/+BhkdYdoXf5v5CBA3OcjOICHpHy7/Ndrrgblf7Q=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=WI3km828KsDttE99nyfjt/pXjPlHNsBw1kFmwaZ0T5FUKY18CDaCwvdQmhFrPqHBC
	 HPsbQn9i8cAuk46I8BtN1qu6oUYdepIRLnYnBAIA/W4r1iE+e1X3JChqECb46QD0PE
	 QA5NOcl0+qnHzVFmyurUCMMctg7zgtHBU2g2CNs4=
Authentication-Results: mail-nwsmtp-mxback-production-main-60.iva.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by ybzyx5bgt3byggqr.iva.yp-c.yandex.net (sendbernar) with HTTPS id 9583a2851fa81df7e03c6027b58d62c3;
	Wed, 14 Oct 2026 11:35:10 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <221941791052355@558b3e58-c2b1-4e14-91fe-beb5649d18f6>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4> <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8> <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136> <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd> <143991791036721@40be7595-980b-4665-ba66-1601e10a0899> <c4286904-2a9a-41fd-93ce-be57964909f6@candelatech.com> <221941791052355@558b3e58-c2b1-4e14-91fe-beb5649d18f6>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 14 Oct 2026 11:35:10 +0300
Message-Id: <5955851791966910@d362902e-9931-4ad0-8e86-72401cc67703>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

OK, so I took some time off of this because of real life, but during that time, my 7.2-stable-with-Ben's-patches frankentree actually crashed! I am not sure if this is the same issue or a different one, but I thought it's at least interesting. 

Here's the logs from the ~hour when it crashed (exported from Loki, so sorry for the weird format): https://gist.github.com/K900/e2e5b21d6a49f450fe353c7cc3057916

If there's any more info you need, please tell me.
