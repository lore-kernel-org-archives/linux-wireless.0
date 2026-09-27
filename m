Received: from vinatta.cz (vinatta.cz [37.205.8.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51E475809;
	Sun, 27 Sep 2026 17:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.205.8.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790530102; cv=none; b=BAEru8V5xMVtmoQDDFrnBs3h+bNLZM69iphJKVYWfwn7c1T7oRDncbshOKayMHRkjCJq2U4mGgng12zDM6f7CzWJ/lRQt9eipaKxn4tgIlLFX4gsLl+LM8/TmQq8gYqNcXPE0CoXlukEOwk+CyeBXjJj/cfKYA5ID+0/IBPe1zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790530102; c=relaxed/simple;
	bh=7wFClM8+pAQczxdhJUJqKMlAR1HmGxjlTK3IxTJCg2g=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:To:From:
	 References:In-Reply-To; b=aTTw7RkJslg1SXZVN2787Vp/0xYWCqIhs08aFX7Q9Vs8IirM4/MgQqWCT1AR5Hjn5Uf0HJg45+4ZYQs2gDku99gy4K3l22oFBrbG1b4kkOJfZmXuaZ5DFACwZdAMR3a8PNBNO7etS8ywe/pUYkq3Tt5HdNE14EQk+mF2Gxy60jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=matfyz.cz; spf=pass smtp.mailfrom=vinatta.cz; dkim=pass (2048-bit key) header.d=vinatta.cz header.i=@vinatta.cz header.b=o/oOCS/A; arc=none smtp.client-ip=37.205.8.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=matfyz.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vinatta.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vinatta.cz header.i=@vinatta.cz header.b="o/oOCS/A"
DKIM-Signature: a=rsa-sha256; bh=7wFClM8+pAQczxdhJUJqKMlAR1HmGxjlTK3IxTJCg2g=;
 c=relaxed/relaxed; d=vinatta.cz;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@vinatta.cz; s=default; t=1790529144; v=1; x=1790961144;
 b=o/oOCS/AFc0OjfWcZe5MxNwXS6fDKe/EMD55e5ERTrXjHgqe6OUKdYWia3HW/I7e0okeLwKn
 ayhBroQ/58yk0do/jUapZ40tqgOdoU1OnLXZXNAVOiVYtGZ1w1KBxcoOiMhmt4XEbPV/O8J7BEF
 606PN+T8JycaxJ2BKdTJeD38bsTnT3pFAeRXkB6PbjRA7eUhQpyGhjOnk/t5ppT6E2Q6vYj+hAu
 hopCkhFeh0InMztWieMVMG3RNKypEgxs497OW4zpHlwdTgk1Uegtn1TqZJl2fk0A+JGaRbSECKn
 xB8Y6wPms7petV9XW6NabhiQLirznwv9VJOB8nmitke0g==
Received: by vinatta.cz (envelope-sender <karel@vinatta.cz>) with ESMTPS id
 713fe9e7; Sun, 27 Sep 2026 19:12:24 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 27 Sep 2026 19:12:24 +0200
Message-Id: <DLQ9LXDE2P29.248MPYCJMT0DL@matfyz.cz>
Cc: "Francesco Dolcini" <francesco@dolcini.it>, "Johannes Berg"
 <johannes@sipsolutions.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 =?utf-8?q?Duje_Mihanovi=C4=87?= <duje@dujemihanovic.xyz>, "Andrew Lunn"
 <andrew@lunn.ch>, "Gregory Clement" <gregory.clement@bootlin.com>,
 "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>, "Ulf Hansson"
 <ulf.hansson@linaro.org>, "Frank Li" <Frank.Li@nxp.com>,
 <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mmc@vger.kernel.org>, <~postmarketos/upstreaming@lists.sr.ht>,
 <phone-devel@vger.kernel.org>, "Jeff Chen" <jeff.chen_1@nxp.com>, "Peng
 Fan" <peng.fan@nxp.com>, <david@ixit.cz>, "Johannes Berg"
 <johannes.berg@intel.com>
Subject: Re: [DONOTAPPLY RFC PATCH v2 0/4] WiFi support for
 samsung,coreprimevelte
To: "Brian Norris" <briannorris@chromium.org>
From: "Karel Balej" <balejk@matfyz.cz>
References: <20251026182602.26464-1-balejk@matfyz.cz>
 <DEJL1ATTQMVE.120JV9YW59I27@matfyz.cz>
 <aSnWYS2g5slVFaSk@gaggiata.pivistrello.it>
 <DI5L100Q1RKO.1A68EJIPWYSRC@matfyz.cz> <afI8y70U7wFT_07h@google.com>
In-Reply-To: <afI8y70U7wFT_07h@google.com>

Brian,

Brian Norris, 2026-04-29T10:15:55-07:00:
>> Brian, what are the options here now? Would it be possible to make an
>> exception and accept the patches without the firmware being in
>> linux-firmware? This is an old device with no mainstream audience so I
>> expect everyone who will want to use it will be able to supply the
>> firmware themselves
[...]
> I suppose I'll leave it up to Johannes on this part, and may be willing
> to retract my NAK [1].

I have not been able to get a response from Johannes for these last five
months, despite pinging twice =E2=80=93 is there any chance you might be ab=
le to
help with that in any way, please?

Kind regards,
Karel
