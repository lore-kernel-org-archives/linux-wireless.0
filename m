Received: from forward500a.mail.yandex.net (forward500a.mail.yandex.net [178.154.239.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED064E13FF;
	Fri,  4 Sep 2026 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538767; cv=none; b=ht+cARHfLtAmEimzJk4xrQ59QgcQN86FtYRqt2Z7//6dXFTW0Idh8ADyly0t7q2org3+0nvJwDAmmhrzrNslBDlDv998OXqRnUpiApkY1Cmugenx55laKfLud8hurjktVdE84zpFH8yihvBl0I33AhXHByFyykmjdRRBbSvptAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538767; c=relaxed/simple;
	bh=WKjGjHVhhR0zV1iEtU14nKVo2m/Fb9LFzj83DSGM/p0=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=p+57aqy//bg4Jq1tZHg1OXnke2OxL7a54X3oT4IezerMKPp13l+wQUdWUcXpvDaA3wJtzhq8ohIJYc+w696x83DQnGlC/M9kOwrOWMvaxd6X2jH+5kAKb+mRyJmWWfGBIioRbbeuQOhjDliin6Dgff2dDZl5Hd/nvYZG2DvyEWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=TECirj0B; arc=none smtp.client-ip=178.154.239.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="TECirj0B"
Received: from mail-nwsmtp-mxback-production-main-72.iva.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-72.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2923:0:640:6b94:0])
	by forward500a.mail.yandex.net (postfix) with ESMTPS id 41D76C15CC;
	Fri, 04 Sep 2026 19:11:30 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c0c:862a:0:640:6de3:0 [2a02:6b8:c0c:862a:0:640:6de3:0])
	by mail-nwsmtp-mxback-production-main-72.iva.yp-c.yandex.net (mxback) with HTTPS id 6BMMDbfoSqM0-VSMVhZy6;
	Fri, 04 Sep 2026 19:11:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1788538289; bh=WKjGjHVhhR0zV1iEtU14nKVo2m/Fb9LFzj83DSGM/p0=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=TECirj0BsqNNon0b2M4Ksr7nkXiXGVE6iqFokkZl+q9uMhLGaMEUDWSsAx6dg2wXa
	 TU280AN6g33YMAarMRIwqDDiUGh0N4uB2HEOUBNnMVukABh0COgcD2CkxfsZ8fLIt+
	 fU74hcEHMutdgbNjzM3OSm87YQbpnJGMPBDf3A8o=
Authentication-Results: mail-nwsmtp-mxback-production-main-72.iva.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-86.iva.yp-c.yandex.net (sendbernar) with HTTPS id ee0435dc52cae3934b01e0ae2982ece3;
	Fri, 04 Sep 2026 19:11:29 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com>
Subject: Re: [bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 04 Sep 2026 19:11:29 +0300
Message-Id: <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> https://github.com/greearb/linux-ct-7.2
Hoo boy that's a lot of patches. Anything specific in there, or do you want me to just rebase my changes on that entire branch? I can try, I guess, but probably not today...
