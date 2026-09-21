Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC8B377AB7
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790022024; cv=none; b=IDqDFLRQJOpDIMebChr4dYG3oTDk1PR/2V2i0E2Ws4gnRuIXIEODWxKwHS6Jjc6iSmC4PZp2pjmXu3aug21Kvz9gUX3+tV/PRsQFpVESVDwtLsU3hTIaj0HI91ikX7+A/Z3dHur4LsXNEWoNXJuX9f4IFK0xQ7E72unpbQz5bXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790022024; c=relaxed/simple;
	bh=HfR+e8Rr8pLKpnamNmL2ZxNnTmCbAgpGF12JpUTgIRQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JZ25MycBO0h3djnUbKFGCYz3fQkuIoD4C189bdGVp67ZSfENaG0837Gf/aMBR+GEZiTglM3dcIS23DO1rrPuRUSmLnR4CwpT00uD3fWmvcTC0TiEcDRhfY+Sc1BtEAdGKVX7omLMs3/myuHaJHV2hbQ6es0U9dSt+cQA4KBwJUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ciBile5X; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ciBile5X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=HfR+e8Rr8pLKpnamNmL2ZxNnTmCbAgpGF12JpUTgIRQ=;
	t=1790022023; x=1791231623; b=ciBile5XYq+VA1VBvqk0lIpyOkoQm4RxJHQH2X8awEKzLXS
	7Toq5NMTKyz1P6N0ay5LNOFJ5b2Scwb+sNzvE9uHGZTIBXM1rCzoRcfK4MoDStnm+0psdb/lMQV7A
	W8yXx1ayVoCTzPifauiayWzQDu3zR5UDlAT2nUdyLvUmbYLsC/Cw0cXyjqUBieSMURaO33HyxfqPl
	VGTzsqaFDXnugQ1ePB7FZqAN4VQt23Af23g35R7095ojaeJiWaWiuhUuk7aGHYHNdGHBJp2SmC+KX
	QgUbC7RQzkvjN3sgRG0WCt+OUYpFuvLr5TNjYJnXeavDdmm+CRtT0xG2f3+Ueo7w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8kUu-000000064FQ-1APK;
	Mon, 21 Sep 2026 22:20:20 +0200
Message-ID: <63e5e755ce0b8390864f36c9e2eb74cf5749b5e7.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] net: cfg80211: validate monitor
 channel set against radio usage
From: Johannes Berg <johannes@sipsolutions.net>
To: Rory Little <roryl@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Dylan Eskew <dylan.eskew@candelatech.com>
Date: Mon, 21 Sep 2026 22:20:19 +0200
In-Reply-To: <f7788e68-3292-4337-943a-032a838947fe@candelatech.com>
References: 
	<2318ac388c0da7a200c8a1aec0d0af662fdf1ba8.camel@sipsolutions.net>
	 <20260921184605.2699-1-roryl@candelatech.com>
	 <289eaefe3389894758d3ba1b3d24aa73aa630d91.camel@sipsolutions.net>
	 <f7788e68-3292-4337-943a-032a838947fe@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-09-21 at 13:17 -0700, Rory Little wrote:
> > > - Handle error return from cfg80211_get_radio_idx_by_chan
> > Yes, but did you do it correctly? I don't think so?
>=20
> You mean propagating -EINVAL out to the caller, right? I'd need to=20
> handle the n_radio =3D=3D 0 case to keep the -EBUSY behavior consistent.

Yeah, I get that, but it seemed tgo me it should return true (accepting
the channel change) - but then again maybe not, since it already accepts
"only have monitors", and then getting there means there's something
else ... sorry.

johannes
