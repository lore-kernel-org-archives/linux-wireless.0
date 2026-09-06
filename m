Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EC226A08A;
	Sun,  6 Sep 2026 10:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788691581; cv=none; b=jDiZVdlOMXYZMhI1lmw13/8QzFT3gX576CgDjvNlVH8V9+V3cLvzI5ACCX+5aI7vAtRz0gSHZMkhdnLCBNkB+epS7M+603rm35by0uZhCextehOgkHmAgbi9zyqpO/Ka+vg1jjO8WnIFcokmBycmgZAsgzI4ujRYRNnzEBaUCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788691581; c=relaxed/simple;
	bh=V2a5BfEqYhttT7XBrh1fm1JBPreZV4ALxhdug6Uz1BU=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=DQP99baO/wzkjoCk2P5ZLyq4m4fkNO2IHvACV5JjmgtlVQUTfIWnweSTlZJn5cmPe73TK4AkqGW+hM8TkQCRO1jlgH/kRwpR/IdNjqRTr7iUrQw77JH/qp1bTzuAygyJ5u6t2T1ojhJMcnzOWSLDjAAzNMHUWbolITFD+sB3fdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=p5sjvJg6; arc=none smtp.client-ip=178.154.239.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="p5sjvJg6"
Received: from mail-nwsmtp-mxback-production-main-76.sas.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-76.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:29c5:0:640:e1ff:0])
	by forward500b.mail.yandex.net (postfix) with ESMTPS id 6D728C0FCF;
	Sun, 06 Sep 2026 13:38:28 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c23:f2f:0:640:d25:0 [2a02:6b8:c23:f2f:0:640:d25:0])
	by mail-nwsmtp-mxback-production-main-76.sas.yp-c.yandex.net (mxback) with HTTPS id 8cIxwmIw0W20-3r3Gvg2f;
	Sun, 06 Sep 2026 13:38:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1788691107; bh=V2a5BfEqYhttT7XBrh1fm1JBPreZV4ALxhdug6Uz1BU=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=p5sjvJg6FHLD0XsjQrdcAEglZ+9QvhBkzc4cWPqeTxO44AeeIwXDyeLD83gHqoO88
	 Vb+qLSyXnCElvTEBT9fIuf7YNL7CHtgH6FcqL7fplUCxkOdfR/rxcUe8tkJzJ4fmed
	 WmGIRBiS+SUviTthUQwvTtFwyJeKDGcWjKhmZ4aI=
Authentication-Results: mail-nwsmtp-mxback-production-main-76.sas.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-85.sas.yp-c.yandex.net (sendbernar) with HTTPS id e2ef39f0168386ab0ed568b1a36d4f79;
	Sun, 06 Sep 2026 13:38:26 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 06 Sep 2026 13:38:26 +0300
Message-Id: <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> This abomination is now booted on my hardware and I'll get back to you if it explodes again, which I'd expect to happen at some point
during the weekend at worst (and if it survives longer, that's already an improvement).

OK so it's been over a day with no explosions which is already better than its previous best. The question now I guess is: which one of the patches actually fixes it? And do the teardown paths still need fixing?
