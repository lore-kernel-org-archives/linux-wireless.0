Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C271B313E03;
	Sat,  3 Oct 2026 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791037089; cv=none; b=QnUfmr4Z2hpT7DBPxuh8J46IBx6mIMizgOPWGV/ZlrLAyIlQvA/2S6YgWr01/iR7EuzRkCT8v8sHYfe/gddKK5WuGmKIyNfivy588hK6aN05aOC8py5YbmWXHlJRKmvQvOi47LvieTtZgExIZrdJBSffzpC3l1enBzT/gjNVpsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791037089; c=relaxed/simple;
	bh=p1iE9IJuA9vzahQdkL4uD4ZoYz14exJJjYG0KNLd2AU=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=gs8BJXLtKNisOd1APhPZUFi0V1AAKAi+nlfE2kWmCJxkvgE2xN09qiUGgG3FSK+RlQ9iKQ/qmVYtZAbZIS8qGhXJblhAVrXeeRnTtRI2FzuOpi2wgcrfx0vCgV+tSClQFMEkMqDIQAPL6FW/BmCgMToHCMFBVAh/IV2jIXEN7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=GQdg3GxM; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="GQdg3GxM"
Received: from mail-nwsmtp-mxback-production-main-813.iva.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-813.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:5a80:0:640:5f14:0])
	by forward500a.mail.yandex.net (postfix) with ESMTPS id 0EDB4C1A3E;
	Sat, 03 Oct 2026 17:12:03 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c0c:5c14:0:640:a57b:0 [2a02:6b8:c0c:5c14:0:640:a57b:0])
	by mail-nwsmtp-mxback-production-main-813.iva.yp-c.yandex.net (mxback) with HTTPS id ZBnmCa5JU0U0-uaRxgpvu;
	Sat, 03 Oct 2026 17:12:02 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1791036722; bh=p1iE9IJuA9vzahQdkL4uD4ZoYz14exJJjYG0KNLd2AU=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=GQdg3GxMKnjDtrIjZh0QrCu5kM1xhINdJesJyy4yrZFahZoGEghildQm5SzcpOyF8
	 eolunvKhE4ANInoHCfjW/QEx/wGRIQzTHNviK19rFLiKc8JU7gl4zuPOFlGP1IHX1a
	 eORP3jrRt73DwL9U8oIouuXCGiIrB0GOIvGUrIWU=
Authentication-Results: mail-nwsmtp-mxback-production-main-813.iva.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-60.iva.yp-c.yandex.net (sendbernar) with HTTPS id ee00c04c1aa76ab2be9247f83e4d4341;
	Sat, 03 Oct 2026 17:12:01 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4> <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8> <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136> <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 03 Oct 2026 17:12:01 +0300
Message-Id: <143991791036721@40be7595-980b-4665-ba66-1601e10a0899>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

OK, so another update: my current branch which is basically 7.2.8 + bpi-r4 specific stuff + any patches from Ben's tree that touch net/wireless or mt76 code (http://github.com/K900/linux/tree/bpi-r4-728-ct) survived an entire week of no crashes, which is a very good sign. Unfortunately, it's still >500 commits with a total of +20k -2k lines of diff, so I'll have to go through it again and strip it down even more before I can have any idea of what is actually helping...
