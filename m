Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4406E3DBD4A;
	Fri, 24 Apr 2026 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777040086; cv=none; b=eaVbOgrINADKbSHXdyURC8H8Nlf8ssWMms+VnUYRHxW8bAJYeDWK1IJizbZqyMiEnR3RxLXKc538wvfszeRjPxfqQYfqlpf9YIjT4R8MnOmP1NzpzJuAzhjDJ60f8hbMyQnYlHGiynWZjSQQo1vMpiCFBu2aUp50/6mXmUGaK1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777040086; c=relaxed/simple;
	bh=fYQ8VR7DAxlEoRAlG/wQmtY6yYFnXsPNkTF3TccrjUU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=T8h/tlcPxiO5hJDo1inf0tIkQv03yilRsNGcJKLrXOrU9jQBoSYoQqOBdQfgDh6X+ghQ8II6l4b1AC+NGPk2KJLtNsVdum8RdZKpaz66sUMfmbyXXRosdY+LO3XVT0VcMINZTa5SnJRtgEFvPFgZ14sMwK4bQUtdOqVJRB82FSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=squebb.ca; spf=pass smtp.mailfrom=squebb.ca; dkim=pass (2048-bit key) header.d=squebb.ca header.i=@squebb.ca header.b=KYiQDz40; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nopZRL20; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=squebb.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=squebb.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=squebb.ca header.i=@squebb.ca header.b="KYiQDz40";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nopZRL20"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1F95014000B0;
	Fri, 24 Apr 2026 10:14:42 -0400 (EDT)
Received: from phl-imap-08 ([10.202.2.84])
  by phl-compute-02.internal (MEProxy); Fri, 24 Apr 2026 10:14:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1777040082;
	 x=1777126482; bh=Ifnuh73riQo8tGZfAnsdE17QTjWMPIDxYapxrOESda0=; b=
	KYiQDz40A9fSnVFcvOv0HNSRroU5QPfj8quQ2Vn3QL7v1wTC7Ch21Nc+lW99WwES
	uMRcQyTVoEb/p/ZHz4D6XdcQhhtQdF00v8LsGs8zpc9jaQLarMig+KfxLfAGTlRd
	5zcVKl2I/vdiatAvyWWeY88euVhWzx+rbSRTs183Hwdbib6k6ITOyf/1r0M4EruV
	iSSJ/SL3JWDdODIICfKndOvFAXzDIJ7kgdartwmpChZkzb2HelLoHIzKrr/n1Lw+
	rEBoB/aQaioddyyui+vUIYx6h0NUPdGSnG+sAuJl8gi7MMb014+KokTcTtJbaZYy
	yDxtwqqACOxaZrgvJjJtYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777040082; x=
	1777126482; bh=Ifnuh73riQo8tGZfAnsdE17QTjWMPIDxYapxrOESda0=; b=n
	opZRL20QK365pYIa2y7pk0uM9hhTGCFrVXInx7RqnfvP6ALnUkI80JCCoa51Ed6Y
	odQ3IL7G9XoHQzuodjWK34hTJnJNryOfCaxt2OCGbCqxsv/Ghro4VrDPs/HTUAoF
	8txZUiVB7Zbkk0wGxrjUBNhFFr08mVb6GinR7SRYWNLvkGrFIoh5PlJky2RLFVZk
	QuBqzNeeCsdNqW/jp+nVAUNHnShE8BgbBS/nVMdaz2zivjw+QaFRjFzGf1chFfKc
	JEMIHkdOij3a8rO/cghI2oiK7956PZ7f4RGkkClyxRcDXQu3GOUjjPXeaKoMUQwT
	c+YUiC8SuEIPY6OIMrT6w==
X-ME-Sender: <xms:0XrraTqe8XNRs-ycOmRiQ9LB9NkERNOGRZUQaD6HCnI0Lo6LFlvU_g>
    <xme:0XrraYdOD3fkBGhgXeqUT7vZ3kFoWaUfS7PDVLRvo2VoNBaT-fYp5H8BDWV-8CP3q
    NmWFWJWsqA0BX0SoOcaZtH77SHaAp-7kCV2nU5tRHN96hyj43xPylc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejtddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdforghrkhcu
    rfgvrghrshhonhdfuceomhhpvggrrhhsohhnqdhlvghnohhvohesshhquhgvsggsrdgtrg
    eqnecuggftrfgrthhtvghrnhepgedvgeeufffhtdeliefgjefhgffgiedvjeegleeujeeu
    tdduteehjeduhedtiedtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmphgvrghrshhonhdq
    lhgvnhhovhhosehsqhhuvggssgdrtggrpdhnsggprhgtphhtthhopeekpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehkfhgrrhhnuhhnghesghhmrghilhdrtghomhdprhgt
    phhtthhopehkohhikhgvsehighgrlhhirgdrtghomhdprhgtphhtthhopehjjhhohhhnsh
    honheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghthhduudhksehlihhsthhsrdhi
    nhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepkhhfrghrnhhunhhgsehouhhtlhhooh
    hkrdgtohhmpdhrtghpthhtohepshgrnhhtihgrghhorhhrsehrihhsvghuphdrnhgvthdp
    rhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdifihhrvghlvghsshesvhhgvghrrdhkvghrnhgvlhdr
    ohhrgh
X-ME-Proxy: <xmx:0Xrraabbi4kq77MdKzQrRef6LHAgxMbQvnTL2PDrbka567AxmUR50g>
    <xmx:0Xrraf-Jn9vsAu57-uTWyASi1a87sBe4T20YWyWw8dKH4M7Vvrh2HQ>
    <xmx:0XrraYmwGrnPiyc1DXGBT4x9BpZDbQIfmnECkFSvZtFII1oksR_SDw>
    <xmx:0Xrracz10GQt3G9atzlirQwG-PvnDGcgpduHI2r8P_vDosKN4-imDQ>
    <xmx:0nrraWimNfB5pOKR7ww-4XsJfoVreqVyRU4ohJ5Y54BMVALQ71I3ApYa>
Feedback-ID: ibe194615:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8DD852CE3F93; Fri, 24 Apr 2026 10:14:41 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AmUhnMeJVjIs
Date: Fri, 24 Apr 2026 10:14:21 -0400
From: "Mark Pearson" <mpearson-lenovo@squebb.ca>
To: "Kyle Farnung" <kfarnung@outlook.com>,
 =?UTF-8?Q?Santiago_Ruano_Rinc=C3=B3n?= <santiagorr@riseup.net>,
 "Jeff Johnson" <jjohnson@kernel.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "koike@igalia.com" <koike@igalia.com>, "Kyle Farnung" <kfarnung@gmail.com>
Message-Id: <c3e0eff6-afa6-4054-9a37-fa3943442657@app.fastmail.com>
In-Reply-To: 
 <IA2P223MB1199153665E2AFF709BD2F52D02B2@IA2P223MB1199.NAMP223.PROD.OUTLOOK.COM>
References: <20260423211458.458911-1-santiagorr@riseup.net>
 <IA2P223MB1199153665E2AFF709BD2F52D02B2@IA2P223MB1199.NAMP223.PROD.OUTLOOK.COM>
Subject: Re: [PATCH] wifi: ath11k: Add two missing Lenovo IDs to the quirk table
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Thu, Apr 23, 2026, at 10:07 PM, Kyle Farnung wrote:
>>=20
>>=20
>>=20
>> ________________________________________
>> From: Santiago Ruano Rinc=C3=B3n <santiagorr@riseup.net>
>> Sent: Thursday, April 23, 2026 2:14 PM
>> To: Jeff Johnson; linux-wireless@vger.kernel.org; ath11k@lists.infrad=
ead.org; linux-kernel@vger.kernel.org
>> Cc: Mark Pearson; kfarnung@outlook.com; koike@igalia.com
>> Subject: [PATCH] wifi: ath11k: Add two missing Lenovo IDs to the quir=
k table
>>=20
>> Commit 0eb002c93c3b4 ("wifi: ath11k: Add missing platform IDs for qui=
rk
>> table") added some Lenovo platform IDs to the quirk table to address a
>> wakeup from suspend issue [1].  However, at least two more platform ID
>> are missing in that table: P14s Gen 5 AMD, as reported by Kyle Farnun=
g [2]
>> and P14s Gen 3 AMD.  This commit adds one ID for each.
>>=20
>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D219196
>> [2] https://bugzilla.kernel.org/show_bug.cgi?id=3D219196#c23
>>=20
>> Tested-on: P14s G3 AMD.
>
> Lenovo products have a pair of IDs, you'll want 21J6 [3] and 21MF [4] =
as
> well. I submitted a patch myself [5], but I've been investigating anot=
her
> symptom.
>

Thanks - you beat me to it.
Confirmed that you'll want to add those two.

Mark
