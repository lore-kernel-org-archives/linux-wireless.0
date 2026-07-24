Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D564908CE;
	Fri, 24 Jul 2026 07:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784877318; cv=none; b=bHUzQmn0YcvKhI/ckG99oVjhne+1kqzZb+RBAnVTQbUegS7d26qX+7+8QgiOjnkcI8p366ZMi2L8yijzxz9SY072XD5s9/2UYZRkk34oYXR+l+kQtXAOBQ4Jt8+qdaUz/rryboNXR0v5VN2IWsROnQNCGLfgbE3n7wzNVLNqDP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784877318; c=relaxed/simple;
	bh=YLZe1Vd6SPoS1P8/C59OJ7Dc009J18QvBwwUp0g053E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tAfxoyaMkQWMSeBDOKDWW7o6s+bySmNdslS6Nwe9Z1LaLXRarGp00JStvoZBT+L8sLKtU7NtROrvRP3NzTWjciEpQtUeIVr/Wf6lzS3Nt4dtNxePhNOIYjmRUYEJzvRyS+I8Tvr7NYVQpXrqPZ88zXrQFTKuxqRDiRIdS4nDmYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=oqTm+InP; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="oqTm+InP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YLZe1Vd6SPoS1P8/C59OJ7Dc009J18QvBwwUp0g053E=;
	t=1784877316; x=1786086916; b=oqTm+InP25VyoNoPCnggvBYkhlvFBYcEFF7RoGDPd+bRbJp
	/hRPIHsh9H/WEl/SQk3iJ9Krploo+6GXcFK95wKveRNPfWkXrybuJ+/wB+aFc1IhLzvekT/uMD67x
	q/9INdyKQN5i0sSy3D1UZktNLrU9uRXC6K4aaVYCprHq21CsfCToWwTU2F5Wyp7YA/FRuM0sQdoKT
	AAonZTenv1zhp80fH3BBYgwQVsBZCFvJKu1DDlL0TBviNsuEEZIkYSyDDcMSP0wXWejZBtg0M4dXC
	N4nNtoYFPNU7NRQsmT8W+GyVf4B0wdTkrQgQP5UMuaydqx0zZeBoGbIbHwb59zcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wnA7e-000000021nm-3tiK;
	Fri, 24 Jul 2026 09:15:07 +0200
Message-ID: <86efc46da2c0c5cf73ca262f8be8c5086d626ee7.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: reject station association if AP is not
 started
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Date: Fri, 24 Jul 2026 09:15:06 +0200
In-Reply-To: <amMLPgO8Yv1wjMGa@nr200>
References: <373210a9-4365-4cac-823a-0eec391858e7@mail.kernel.org>
	 <c9fa1c083ef9878240c2ee2fb223413153d93a68.camel@sipsolutions.net>
	 <amMLPgO8Yv1wjMGa@nr200>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-07-24 at 08:50 +0200, Slawomir Stepien wrote:
> On lip 23, 2026 11:14, Johannes Berg wrote:
> > On Thu, 2026-07-23 at 08:11 +0000, syzbot wrote:
> > > From: Slawomir Stepien <sst@poczta.fm>
> >=20
> > I'm a bit confused? Did syzbot just pick up another patch?
>=20
> Hi Johannes!
>=20
> No, this issue has been found by syzbot while doing fuzzing testing.

Yeah, but the email? It's "From: syzbot <...>" and actually was
delivered to me by sea.source.kernel.org, whereas your other mail was
delivered to me by smtpo49.interia.pl, so I'm confused as to who sent
the mail and how :)

johannes
