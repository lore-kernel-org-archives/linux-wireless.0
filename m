Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=31.44.14.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792559695;
	b=DgMZigUtgyr3BkBFyge6mVPkSMJnRlM0424lzd0QN/xR6mkCfFL74r6y4TalmsqlCvQl
	 IRIjb0fiqnxtoUVifhN1Vzck6L80cRuzGdeR1DnLjIzogwJim/BGpZrZQxOapUsMiGH/i
	 5xGLCP6AT2LOBMzUH2DceQoGx9TP77W52EYq/c7ZShEzpUij+rFmkgpW+0sIKuui+XjtK
	 g5OFjH592MhDzUe9xOPCaYrTbPlXBGY5W6yyQ1i9otiHvVRUk0sQk6BMUK03lA5DB2qC2
	 Wv57DYG5LCfj2CyBfaY4vLJPeSzvlO2CggL0oclmMel7ULkXfnd+RedFjPSUIDR1ttg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792559695;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:Received:
	 From:To:Cc:In-Reply-To:References:Subject:MIME-Version:X-Mailer:Date:
	 Message-Id:Content-Transfer-Encoding:Content-Type;
	bh=jqWlW6zqb5Tv2gMRTIRS9fn3wqc6RPqo/Vw3J/4+54M=;
	b=mBaM596MVg2VWXnTJahxrkr9Vu34JuHGsG8IUQd3cPTZz9ICBMseUkoO5nRIl0hOVTZg
	 hW3BWZhq0ruJ2ZNeA8W/R/kf/KhTFz44Fp71wS9RWa3X0mx/k59sYWVD9KI20piY8Adaw
	 H3NQm6HhR2azZzsuyl+89PpsghAwql2jusrprzYvNmH7g9YoSUucw1Ig5Fr48hKxyCsRf
	 a8YkDRUD/RV48nBi7wG7/kamt9HzhIEyyLRAvFfSIpArCY/RSr9IlMFpAug9JZaxqPJJa
	 E6PV+XcFY9wqqcfy5O3w8PoIgfZPriMVPRd+fqV6O5Dn0Qcq5uzOY0Gf61UuHM/y/1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=0upti.me;
	spf=pass smtp.mailfrom=0upti.me;
	dkim=pass header.d=0upti.me header.i=@0upti.me header.a=rsa-sha256 header.s=mail header.b=dWOYFKWS;
	arc=none smtp.remote-ip=31.44.14.18
Received: from forward502d.mail.yandex.net (forward502d.mail.yandex.net [31.44.14.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EB2606A319;
	Wed, 21 Oct 2026 05:14:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2EB2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=0upti.me header.i=@0upti.me header.a=rsa-sha256 header.s=mail header.b=dWOYFKWS
Received: from mail-nwsmtp-mxback-production-main-369.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-369.yp-c.yandex.net)
	by forward502d.mail.yandex.net (postfix) with ESMTPS id 796A5C04E3;
	Wed, 21 Oct 2026 08:14:45 +0300 (MSK)
Received: from mail.yandex.ru
	by mail-nwsmtp-mxback-production-main-369 with HTTPS id fETbd21Loa60-gchyJVsg;
	Wed, 21 Oct 2026 08:14:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1792559685; bh=jqWlW6zqb5Tv2gMRTIRS9fn3wqc6RPqo/Vw3J/4+54M=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=dWOYFKWSNM6yJL42a9a6nhJrPaTXHRCAXCDvXZfz0Mj8MvyfAC7uZ0GWpe9jAS71L
	 FhE15RxA2+D6bYCjtCyfG3HcO1oYjnjjrN/j73Fn7xBU5sBdsxSfwdbjT+BcP3gsLF
	 4X1wciVB/RM0CldypHt6nJ/wUxcHJMUaBw2qw8w8=
Authentication-Results: mail-nwsmtp-mxback-production-main-369; dkim=pass header.i=@0upti.me
Received: by mail-sendbernar-production-main-96 with HTTPS id 52484760394db31a8bc30851e3f601b2;
	Wed, 21 Oct 2026 08:14:43 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <04b8b928-b671-4236-a792-1141cd81a34b@candelatech.com>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com> <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df> <2418461788691106@84aa39c5-f501-4e64-8418-6a8b6eb88e21> <eb405366-6574-4e4c-a89d-363751ed848b@candelatech.com> <4175721788798939@f00554c7-d809-471c-9bcf-78e5d8eceab4> <1556871789207706@7dc9deb3-4292-4932-8568-de9b411208d8> <1443771789748846@4a8ec5ae-80ed-44bc-b7d3-6bc660c90136> <211851789913261@df1900ea-d467-4ed7-a7f1-de68a4c3e6dd> <143991791036721@40be7595-980b-4665-ba66-1601e10a0899> <c4286904-2a9a-41fd-93ce-be57964909f6@candelatech.com> <221941791052355@558b3e58-c2b1-4e14-91fe-beb5649d18f6>
	<5955851791966910@d362902e-9931-4ad0-8e86-72401cc67703> <04b8b928-b671-4236-a792-1141cd81a34b@candelatech.com>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 21 Oct 2026 08:14:43 +0300
Message-Id: <93881792559683@cb540089-648e-4f63-be25-5737cfc54c1c>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> You might try the latest mt76 tree from Felix, it recently gained a large number of fixes.

Well, that survived for a few days, but nope, still crashing :(

Maybe I just need to make it log the last few firmware messages...
