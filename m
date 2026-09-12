Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A3340D9D;
	Sat, 12 Sep 2026 10:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207718; cv=none; b=nwWE4Y/auWVZzR3buOZX19pVpwWicHlZmu+G26JDKU7gmed411W6pfFPB/uqQNiVArPBucpu/Eu1XbJ966IQ87I8BbVTOslgt57xri2wZgIGTC6tJ/4QqYQHpmR/KVBY7FDkxtElH/BbDM6NEEDOV6JUtRPpdEc61cf8ZQ/SfH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207718; c=relaxed/simple;
	bh=kDo4WJDSzf1M+g0EAwMrNMhWYQlF3hnTKIBGahzgRTo=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=sB8mdRyYH26A8/QTvzjb29PwAkbT6jfjgp4LeX+FV1YIvHF+isAG7iZEEF5FPNTLBDL9jd7L/fmUFqZgpmgQzsaD9ukeT+t4f23NUycFiydEof+n0lc/W/Z/7X7U0YEmogSaFQ9cmxSCy5lZwQDh9KgPJmrmuYD22N+0EvigHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=Ljz45SOw; arc=none smtp.client-ip=178.154.239.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="Ljz45SOw"
Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [IPv6:2a02:6b8:c41:1300:1:45:d181:d502])
	by forward500b.mail.yandex.net (postfix) with ESMTPS id 9B049C266F;
	Sat, 12 Sep 2026 13:08:27 +0300 (MSK)
Received: from mail-nwsmtp-mxback-production-main-17.klg.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-17.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:83cb:0:640:b499:0])
	by forward502d.mail.yandex.net (postfix) with ESMTPS id 84173C0114;
	Sat, 12 Sep 2026 13:08:27 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c42:3f21:0:640:a34b:0 [2a02:6b8:c42:3f21:0:640:a34b:0])
	by mail-nwsmtp-mxback-production-main-17.klg.yp-c.yandex.net (mxback) with HTTPS id v7OToaXbY4Y0-glj0rl06;
	Sat, 12 Sep 2026 13:08:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1789207707; bh=kDo4WJDSzf1M+g0EAwMrNMhWYQlF3hnTKIBGahzgRTo=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=Ljz45SOw3YK18zD1ANPpWMCubh/PzmP0k8Ulg6ir/0Qanp8g4Urg8JUCJpl7tKwQD
	 aL7z619YjoHR1wdMbYkCv5QvmRA/UOEtkNkmzmqh3cGL25eBtJknOqOGBqHOeEPtFJ
	 ULIr1dd4Fh2+a69xJpNFz9bas4NVlw9NkbeR14aU=
Authentication-Results: mail-nwsmtp-mxback-production-main-17.klg.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-65.klg.yp-c.yandex.net (sendbernar) with HTTPS id 93db8e472b59011010e0ea59c1f84888;
	Sat, 12 Sep 2026 13:08:26 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 12 Sep 2026 13:08:26 +0300
Message-Id: <1515671789207706@4f731255-7c4d-4276-8f89-37d7691f05c3>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> I've tried just cherry-picking all the mt76 changes from Felix's current mt76-fixes (minus the AQL/PS stuff that does needs 7.3 bits in mac80211), booted it just now, jt hasn't exploded yet, so we'll see.

OK so update on that: this branch (bpi-r4-72-mt76-fixes) exploded after two days, which is an improvement but still not perfect (and possibly lucky); the branch with all the patches from Ben's tree is still holding on another three days later... I was kinda hoping it would crash so maybe the extra logging helps point out the actual issue, but alas. I'll keep running that for now.
