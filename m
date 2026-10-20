Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792485594;
	b=iU8oPGQR4ZQtL0UDBWMFHhbev1T/1SE6w2n65aWwkFvXQdSy2S2zPzLI53CbpqceLxpU
	 ZEzHQLTmn/7+iAbdwZXM6nUtKE2IBSh6AqB6IsDE1Zgkimqc/gvu7ImBurVFwX5YWFvOX
	 sV/jAdQaDF7qs9AY90rK7lG0+ziOGUqw9yUZgLhFuvnzyn8twN6bRO7A5VO06dS3bNZt4
	 EKbt3MP4AazMyU7cu+1pnGTYQbUUZXbwNWnDVkSO4/EcgHqEsybXHzaRN3UVTw5zlKJR5
	 3tDTPtTl5fcTfGiKoVg/QT0yxP4xcr29x5qTtESMrZ0qnB5KRg1AQMZXgSz8xY+8TZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792485594;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=1BXTzKcczQ/ZL6VWZ1Sg8e1Q5TT0707z9V2mf3N+p8I=;
	b=R0CHyXcCRhplIwiQLOh0lJ+yT+APZx/FZFWl8kJsMwFjvRhLRN4gg6uIjaBiCl+txqup
	 CAR94mPK0/BbcBjHrerWuw2bnR0FC7QIstWSTa2VRrPK8knpFjuUPf8+11absRdVuHUfO
	 nNQ5r3JrsMSzP6SSyOzMwIBP0DM7CfM0uRhrEyxY3aYANEYA4xO08cohXkeR3VE+7UmVV
	 /xvMAejuSjPcSNXMWp5Gv6W5PUYmziLde01o3susQeiKxSNKvuCQctzalLyvektYgcQ7D
	 I8lyWqRdoe4elnpfWXxh24EzsXjyE5ud6Bvsnh0OoWvtmtOzk5wcOa9SWv7ILBIBRQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=THWkLVM8;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2B1606A31B;
	Tue, 20 Oct 2026 08:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=THWkLVM8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1BXTzKcczQ/ZL6VWZ1Sg8e1Q5TT0707z9V2mf3N+p8I=;
	t=1792485593; x=1793695193; b=THWkLVM8ceqj9n02HpI3b538FRdwR/rdyJy5/IbKfN51BFE
	DMKk+F8JvTmphprw3SDzlJ0uKuhYeZtwBDPOPUo2D1cbmWpY9mmPKd3IR8JwYUQzBiHO/LetDQoZj
	gnJJIVEI+7PLFhA9tIvfjuKjgTPKH37oHunj9ptOJG2U0KlGzgtpRKQLbEDoW9RaupvcfIqzR2hXR
	RAjVtrWqYoqVxKPwQrnK62iCBMW1vwy1nqi1ajjbhF8KTnwphVE8zxwaYPJRAJdP4ggL9iKwmvu7n
	zyHrrEiXHfyNTS/qdLpO+h4OMGGsx53Kde/APmOt4Im4nNu1U5IMD/o/lepwkqjw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJ5Nr-0000000G3Yr-0pZv;
	Tue, 20 Oct 2026 10:39:47 +0200
Message-ID: <b4c5587803cf01eb14a196d8968cc33d9c953f66.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fix MLO station firmware crash
 recovery
From: Johannes Berg <johannes@sipsolutions.net>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, Jose Ignacio Tornos
 Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Oct 2026 10:39:46 +0200
In-Reply-To: <f0c329ad-a13e-4bd3-b630-c0137a5f42c9@oss.qualcomm.com>
References: <20260804175004.1761075-1-jtornosm@redhat.com>
	 <20260804175004.1761075-2-jtornosm@redhat.com>
	 <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
	 <1c8bd087a5cfd54fbe2825f2fa19a7851357ba86.camel@sipsolutions.net>
	 <f0c329ad-a13e-4bd3-b630-c0137a5f42c9@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-10-20 at 16:37 +0800, Baochen Qiang wrote:
> >=20
> > There might be a chance to disentangle the RTNL from this given the wor=
k
> > I did recently on disentangling it from cfg80211, but then on recovery
> > *failure* we have a problem with cfg80211_shutdown_all_interfaces().
>=20
> Hmm, I wonder whether the restart work could take rtnl only around
> cfg80211_shutdown_all_interfaces(). From a quick look,
> ieee80211_reconfig() itself mostly only needs the wiphy mutex, except
> ieee80211_add_virtual_monitor(), which asserts RTNL. Though any rtnl hold=
er that then
> needs this wiphy would still end up stalling everyone while the recovery =
runs.

No, it's not that simple - it would have to drop the wiphy mutex to
acquire RTNL, but then userspace can come inbetween and use the failed
device.

johannes
