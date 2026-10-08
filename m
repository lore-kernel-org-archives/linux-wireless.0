Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9593A5445;
	Thu,  8 Oct 2026 15:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791471713; cv=none; b=jb1Zau02wmghfWJZCs3cT4aPbDSmk1f9QetnhSGma5SrZvm9jutKswWZpgziNhDtS0kP4o+Qg5VIcQ4D9ldBU7x/diLtb890x367HU4LHTOlSVFcll3Os4Xf4RzaqetpeQMUIv41L5YfTRwMObguGDyIun1w9IQLX+5xWz4s+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791471713; c=relaxed/simple;
	bh=FmkbixdUOGhXtC9D0XvfNWT+Wmfa+KN3U29UeWurTt4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EW1Ca1rEBoDdwrtka1DO/oOeB1FoSlGURnNpCphty20/yoMe3NwUJvJ+pkexTLyC6+WIgbVSV+BI9GhtTIz8SP05moBjVhB83UccfNRyPR1Rvpf8iDtYgcBMwQr8oRYOnHi9z+XAeLOIEBVuRtAjuuQSsF44dhtyRgtmUOyOgq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PJxn/18u; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PJxn/18u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=FmkbixdUOGhXtC9D0XvfNWT+Wmfa+KN3U29UeWurTt4=;
	t=1791471711; x=1792681311; b=PJxn/18uz1tarism85N/iI5Lb02d8ipJLDRWuujJ/4+th4Q
	kZeyEtUfwLPlP90d1c/NF4eWV9lbRgCcy+rW4++C1mekw9ZaPE/0I1OPSnCd2D1JRQF91vOMHf+SA
	m/ggn56FtxIGE5xlPWYMitmBxoeYPkX7U7cQMupH9vxOKpPefdxyraTChwVqDKKNb+ZpAyvkFApuT
	vBJeSBDTNpUftnWfYiD1d6e43jMD99if6pmmoAwsr3Urfy2g0SNtceLIXyo+9qoGDW0ley28tTVpJ
	H4H9dhbB6EJpNBx0eTe+JdYL0Lm5igbenGqwD6ozxhiHMzAn3H6kt9QqkR5/GCaQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xEpcy-00000009RQK-1EFd;
	Thu, 08 Oct 2026 17:01:48 +0200
Message-ID: <8575c0d3cf58e56300313482dd1d4d74cbdbf4f0.camel@sipsolutions.net>
Subject: Re: [GIT PULL] wireless-next-2026-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: Kuniyuki Iwashima <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 08 Oct 2026 17:01:47 +0200
In-Reply-To: <2688563455012eb80063ae014f78230b10a14710.camel@sipsolutions.net>
References: <20261007205827.467974-3-johannes@sipsolutions.net>
		 <20261007163616.1088d364@kernel.org>
		 <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
		 (sfid-20261008_040528_485050_028310B5) <2688563455012eb80063ae014f78230b10a14710.camel@sipsolutions.net>
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

On Thu, 2026-10-08 at 09:44 +0200, Johannes Berg wrote:
> > Also, I hope we could remove the long comment in __rtnl_unlock().
>=20
> Couldn't we remove that today, by just __rtnl_unlock() in that place in
> cfg80211? But it's not exported, for good reason, presumably.
>=20
> But that's also irrelevant, because indeed after my patchset cfg80211
> doesn't do that any more:
> https://lore.kernel.org/linux-wireless/20261006100655.2687533-21-johannes=
@sipsolutions.net/
>=20

FWIW, I double-checked and didn't find any other code in wifi that would
do the rtnl_lock(); lock(); rtnl_unlock() ... unlock(); thing, so that
really is gone once I merge that series (which I'm planning to do after
all the net-next pulls net etc. settling this week).

johannes
