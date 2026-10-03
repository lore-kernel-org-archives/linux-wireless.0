Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [31.44.14.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AB638F949;
	Sat,  3 Oct 2026 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=31.44.14.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791052813; cv=none; b=DhOW+hhzoDxlAw+jDSkD7bxhKpnEo045Ljb3PpojUmAOnNWptezu6rdOGo0mwbtse0Qq4oefMJu3G9iIVVlNgLLNqddp8cChAza+SexOjjAYWbGAvVu3zCUiQvLEd+TBHbvB1eA7fUmgmXZANi+LCAHWS1tyoZM9aM7IfZt94hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791052813; c=relaxed/simple;
	bh=dskkS6LDPCtTx6HuEeTN3ds94w/Gub2MzDXXV9xpoLQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=utolfbQtNXb6NYhJvC4Dttt3UPrT0b5kyMcwftP0+d176vyCqLfW1YKdSGGQbYZudRgx/Zm2jup1mPqhT8UQvumsu/Y6rP/pcWOM2hDGsxt2pa8DAnauEtDY6i+VOk4Y5BaBzXtiLar8p3UYlQlchZN8uWdkhguOrQddz9umPQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=J/v5eIrF; arc=none smtp.client-ip=31.44.14.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="J/v5eIrF"
Received: from mail-nwsmtp-mxback-production-main-57.klg.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-57.klg.yp-c.yandex.net [IPv6:2a02:6b8:c43:4d0f:0:640:45ce:0])
	by forward502d.mail.yandex.net (postfix) with ESMTPS id C3285CE5A8;
	Sat, 03 Oct 2026 21:32:36 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c42:de41:0:640:5afa:0 [2a02:6b8:c42:de41:0:640:5afa:0])
	by mail-nwsmtp-mxback-production-main-57.klg.yp-c.yandex.net (mxback) with HTTPS id IWrqV77AbSw0-ABx8XyaZ;
	Sat, 03 Oct 2026 21:32:36 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1791052356; bh=QJVrIB7qkSU0nHkAG5G7mRwWRLxDg1bGwqOVq12cvos=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=J/v5eIrF7NViugMMQhMTIDg39zldRxtdqinS9p8wXp5xLxKzSJakvbeeY7RuECUi+
	 2+wWOPxpt6oBqxYUKRS23FaEM5GrQXbJg3s41vtuoX+vpfhH1searzqyVVksDiV9mb
	 Yq82fteD1AK4F1KER1lqqDdESEMECdHZ45/RdeVo=
Authentication-Results: mail-nwsmtp-mxback-production-main-57.klg.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-55.klg.yp-c.yandex.net (sendbernar) with HTTPS id c21a6e1b34ae069be1de7566bbbe38f6;
	Sat, 03 Oct 2026 21:32:35 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <c4286904-2a9a-41fd-93ce-be57964909f6@candelatech.com>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4> <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8> <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136> <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd> <143991791036721@40be7595-980b-4665-ba66-1601e10a0899> <c4286904-2a9a-41fd-93ce-be57964909f6@candelatech.com>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 03 Oct 2026 21:32:35 +0300
Message-Id: <221941791052355@558b3e58-c2b1-4e14-91fe-beb5649d18f6>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

>  Our kernel should warn pretty loudly in this case, so if you are still hitting it you should see signs.

Any specific log lines to look out for? I have all the logs from this machine piped into Loki so I can check quickly.

> And, if you can reproduce the deadlock with lockdep enabled, that may
help.

I'll try building a kernel with minimal patches + lockdep and crashing it some time next week probably, would do it tomorrow but have a dental appointment that will take up most of the day :(
