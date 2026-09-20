Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0A83264C8;
	Sun, 20 Sep 2026 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789913268; cv=none; b=BZEqAreXUVWHi5Nu6/Hyz2rZ9v5MnfQchIP1QlB6f8U9nyRc+jXAHB8ADjrMskaYeDZEGmEj2RSCk9i+C0pJluV/ZmquXNLbTr4pX6Cb9FAZLiwgUsaR3XWpjwtU8H/kWck/tOcuOVx2xJ5uPBd24pFC+pfk+lzxrRZR19rVxmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789913268; c=relaxed/simple;
	bh=ggDXQml+3AwD7Hw47o9K814Vwfhlxh4e7ksLSjlixVU=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=hVRpOqlA8holpIEZjeAqkGsp32axpMaqGm3N10zBvKC/J9dqpyAB13xn3i85ohIFcl2kpOb4r6K1KMBVSI3zDS3zQV3wKqXW+I38BoMMKGQOZy3c7BkW70AwxxEAeKOArRhLWeSUsQ5b3TVIyKTRkIxkuu0BT2KSF87X5pwMI2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=NyPvplGO; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="NyPvplGO"
Received: from mail-nwsmtp-mxback-production-main-82.vla.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-82.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:2f23:0:640:4f85:0])
	by forward500a.mail.yandex.net (postfix) with ESMTPS id BFF46C1223;
	Sun, 20 Sep 2026 17:07:42 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c0f:691:0:640:b58d:0 [2a02:6b8:c0f:691:0:640:b58d:0])
	by mail-nwsmtp-mxback-production-main-82.vla.yp-c.yandex.net (mxback) with HTTPS id P7aE5u3vjqM0-cwncLNUX;
	Sun, 20 Sep 2026 17:07:42 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1789913262; bh=ggDXQml+3AwD7Hw47o9K814Vwfhlxh4e7ksLSjlixVU=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=NyPvplGOMOwkBXds1ghR95s9Ac8MUST3/qRWYMh0Mdj+iT1neDTJMcdEyI3ZMXqyl
	 rx9WVDOTmc/21jq1ueGcxN0dX3MZ4/gexGtT5EqPoGBvmvB3zC+Yik+Pnzz8ou0pYc
	 jEdmGGDpiEPNicpPhOgBO5sttUTu6Ii5TcoHcr7c=
Authentication-Results: mail-nwsmtp-mxback-production-main-82.vla.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-46.vla.yp-c.yandex.net (sendbernar) with HTTPS id 26bebf9f2deb4af9870c5891ce14b963;
	Sun, 20 Sep 2026 17:07:41 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4> <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8> <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 20 Sep 2026 17:07:41 +0300
Message-Id: <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> I've picked a few more things from the latest mt76-fixes, specifically these three:
> - https://lore.kernel.org/all/20260729173632.14387-3-enderaoelyther@gmail.com/
> - https://lore.kernel.org/all/20260823053739.186748-1-gongtao0607@gmail.com/
> - https://lore.kernel.org/all/20260901092232.461379-1-nbd@nbd.name/

Aaaand it crashed :( I guess I'm officially out of ideas now. Might have to rebase Ben's tree again, but not today...
