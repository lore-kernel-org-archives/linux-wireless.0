Received: from forward501b.mail.yandex.net (forward501b.mail.yandex.net [178.154.239.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBAA477299;
	Mon,  7 Sep 2026 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788798947; cv=none; b=ETqSGQvXffnGDfUcSnhZI+ZoNt0Zy7Udjjeasa+bInJW3KL7ppPOGApiLz/YBdv6PbMSceiF34zFQydFCyjiqWZgYcwdDodQpC3oUdSKZpfyWdzJwhDwDA91jnEgXopwXyRSLmsvl1ilCsGRaBNnK1dIekwYLjMLvlp6RUoIi7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788798947; c=relaxed/simple;
	bh=sGAKvqenzy8j1ZHINkd1Kv/3zHBjEuus0R262brpzj4=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=ggEqLAWF3nmatub3x8L1CUEV48r8E/5TIsOat85sBplTYD3PiB6NYIcqe2utVsfOFUpLEpai10q6N9e8QRMoigtsi9xDUt11d4Y+KAbZDo11B/WRP+ymwgQ1BO+rpdnFVOTT2neHN+NDpvoi4Mh6NkL0vi+T8Wkgza5YgG7YD18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=SPo/3ll1; arc=none smtp.client-ip=178.154.239.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="SPo/3ll1"
Received: from mail-nwsmtp-mxback-production-main-77.sas.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-77.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:4aa0:0:640:afcd:0])
	by forward501b.mail.yandex.net (postfix) with ESMTPS id 030C58293A;
	Mon, 07 Sep 2026 19:35:41 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c23:4a89:0:640:86c8:0 [2a02:6b8:c23:4a89:0:640:86c8:0])
	by mail-nwsmtp-mxback-production-main-77.sas.yp-c.yandex.net (mxback) with HTTPS id QZPX8wJxveA0-6WSaPnpw;
	Mon, 07 Sep 2026 19:35:40 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1788798940; bh=sGAKvqenzy8j1ZHINkd1Kv/3zHBjEuus0R262brpzj4=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=SPo/3ll19Q8/4H3pWFnFi+ZEgrqm1XoY2qMUgAq8m8rq1Na/Hzs9o1ub4kPUkBR2C
	 b5dL1y/C9ffLeQ+Eak3fa8lroc8mxp95e9ZIdprhni0r3UfrXlycm7fNoB121QZhT9
	 YKzJt6vrzWUUzh4M/P7GtNlvCiLfwDzgRuJowo/8=
Authentication-Results: mail-nwsmtp-mxback-production-main-77.sas.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-68.sas.yp-c.yandex.net (sendbernar) with HTTPS id aab837aab8c70eda14295aa211673652;
	Mon, 07 Sep 2026 19:35:39 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 07 Sep 2026 19:35:39 +0300
Message-Id: <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> We do have some mt7996 tx-hang work arounds, but that bug was reproduced in STA mode in a fairly weird
> test case with lots of virtual STA vdevs, so not sure it applies to your case.

Yeah that's definitely not it then.

> Possibly too it is something we pulled in from Felix's tree that will likely be in 7.3

I've tried just cherry-picking all the mt76 changes from Felix's current mt76-fixes (minus the AQL/PS stuff that does needs 7.3 bits in mac80211), booted it just now, jt hasn't exploded yet, so we'll see.
