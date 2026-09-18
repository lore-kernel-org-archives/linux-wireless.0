Received: from forward502b.mail.yandex.net (forward502b.mail.yandex.net [178.154.239.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236550E591;
	Fri, 18 Sep 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749334; cv=none; b=FiaHbR1C9IXBsAz+qPhdJJvyLIBE5tdaqsoTpwPF4Xi28I++CC3JHLcmMG6SX6WTlHXlkBVauh4woXXG/fI7RsAkQwyRX5C7PdU1XDyHeEFmEtwkyS9LibZQw++k0dq6D5YPKwETq4V74okqtGoMkGRpHDll5vWS5eEqF9s7gr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749334; c=relaxed/simple;
	bh=NAU59vvsEmrYVpB8nv8x4xK1FUmZUpy8NnVvSLExP/A=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=Dj3weEmP+xpi3z4DhxWwSYb5kJYqxPnx2bGy2rjnMkmCuD0qhUQrhRVxbfWMpQo2LJ0+wJomFzSm/n+sBzvDDg9SkAmYvAeZkaj323BX80FLRdDRvXazQCDumeh9thK/KzBAnZPNIx9/Y5OD+LRDbNG+mR3e5XnG7f4xR2Pow88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=HweAqYwy; arc=none smtp.client-ip=178.154.239.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="HweAqYwy"
Received: from mail-nwsmtp-mxback-production-main-59.sas.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-59.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:501:0:640:c489:0])
	by forward502b.mail.yandex.net (postfix) with ESMTPS id ADDA38CB2C;
	Fri, 18 Sep 2026 19:27:27 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c1c:3147:0:640:b38b:0 [2a02:6b8:c1c:3147:0:640:b38b:0])
	by mail-nwsmtp-mxback-production-main-59.sas.yp-c.yandex.net (mxback) with HTTPS id MRaVga1vk4Y0-2b5DlXr0;
	Fri, 18 Sep 2026 19:27:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1789748847; bh=NAU59vvsEmrYVpB8nv8x4xK1FUmZUpy8NnVvSLExP/A=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=HweAqYwyNdpwVVygzSr8jyfDApylvClVKAdQdRXnHjhOrZTfIaJ2odJ9veG7qwXHf
	 leCj3QHs3Rowv1kljnhTV3Jb7ZASZ2cODom4+PMNFYyTfchrtBl7rtKg1crZgPlxSE
	 V/1VbSXA/0pFnrr4D9hMsccdD3zhGP+N+emsSYco=
Authentication-Results: mail-nwsmtp-mxback-production-main-59.sas.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-91.sas.yp-c.yandex.net (sendbernar) with HTTPS id 5f39ae46106f62be9806b612ed5e658f;
	Fri, 18 Sep 2026 19:27:26 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4> <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 18 Sep 2026 19:27:26 +0300
Message-Id: <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Yet another update: 7.2.6 + firmware from mtk-openwrt-feeds is stable for a few days, but then crashes with

[98876.837441] mt7996e 0000:01:00.0: Message 00130022 (seq 14) timeout
[98879.483965] mt7996e 0000:01:00.0: HW/SW Version: 0x8a108a10, Build Time: 20260721003616a
[98879.592297] mt7996e 0000:01:00.0: WM Firmware Version: ____000000, Build Time: 20260721003609
[98879.631743] mt7996e 0000:01:00.0: DSP Firmware Version: ____000000, Build Time: 20260721002848
[98879.657097] mt7996e 0000:01:00.0: WA Firmware Version: ____000000, Build Time: 20260721003453
[98902.835490] mt7996e 0000:01:00.0: Message 001a0034 (seq 11) timeout
(repeating from there)

I've picked a few more things from the latest mt76-fixes, specifically these three:
- https://lore.kernel.org/all/20260729173632.14387-3-enderaoelyther@gmail.com/
- https://lore.kernel.org/all/20260823053739.186748-1-gongtao0607@gmail.com/
- https://lore.kernel.org/all/20260901092232.461379-1-nbd@nbd.name/

Building this now, we'll see how it goes.
