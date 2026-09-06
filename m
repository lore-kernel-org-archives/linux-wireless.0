Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ACC361DA9
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 13:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788702257; cv=none; b=uomzvcvWW+aYD6X9HLKMv4/uN/jSFQrv7caAtuZ9I4TSVosRTInMqMU71nsDyj7OHjh8RrLMFMhAIxKgb+/+YWQsJ6sk1l3oRbhsVdiy9lRM+M0SeWYfrbHvHSB1P/EJX/2a1b1pX1zYs4NFwwOUeMonihhJnYqmbc60CsX0QAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788702257; c=relaxed/simple;
	bh=YOZTVyazkRD7N1lOYXKLgtktdjYFZHn2W86rpUJjL0c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nGAsRX8zv2wrriLEY5hWftY0pLCjYTPx0g93NfEyMc0P3z8Px6Hb7anfbSxkHGUzIpUb7YlS3BMr17MXulVjKA1LKxQGYhAwv11l4artOvkUH6/cPRak4ZEReKTE/qbiOPyPd72LTwLe4ecwgpNUm6DfGG42GyEeC7USmrO1EVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BrHSy9pP; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BrHSy9pP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YOZTVyazkRD7N1lOYXKLgtktdjYFZHn2W86rpUJjL0c=;
	t=1788702255; x=1789911855; b=BrHSy9pP4FJ1E7/xx1JlyOPzQPO5DP5uURQRIAXRW/QXCkL
	o8+ULRDArbpbsu5516OXdzfqOik5pDJz9W/dqwEnoStUthxdWAj8/l+WQNIUdD/sSMaMeYN34cKUD
	qOgcVydL+vtQqxY27tqH2FV4l7m3X1da7/vWUVvzWZXB6kIMmMv+okQrW7nBLsgfAFoM+E6BDwS5/
	z0If6Z9RoM0VRAf2I8A8KNtAhnUWQTnWaH/086OUPzpPk50CjdiUWsaJ6L03wnJOHIuzc186+CT92
	Bny6xDW2EHcUk6Ado1UC6NyZv86oog7qtccdyu9XavfhUThq/RRBUqPcM8B06XuQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3DAI-00000003JoH-41jT;
	Sun, 06 Sep 2026 15:44:11 +0200
Message-ID: <bd7a1d3e0f69c71e20f62beb9fc51b864ffe2c08.camel@sipsolutions.net>
Subject: Re: [RFC PATCH wireless-next v3 0/4] wifi: aic: add AIC8800D80 SDIO
 FullMAC driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Yanli Yang <yanli.yang@bedmex.com>
Cc: linux-wireless@vger.kernel.org, Zhirun Liu <zhirunliu@aicsemi.com>, 
 Dijia Xu <dijiaxu@aicsemi.com>, Chunqiu Liu <chunqiuliu@aicsemi.com>,
 Liheng Wei	 <liheng.wei@bedmex.com>
Date: Sun, 06 Sep 2026 15:44:09 +0200
In-Reply-To: <cover.1787903339.git.yanli.yang@bedmex.com>
References: <cover.1784724170.git.yanli.yang@bedmex.com>
	 <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net>
	 <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net>
	 <cover.1787903339.git.yanli.yang@bedmex.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-08-28 at 20:11 +0800, Yanli Yang wrote:
> Johannes,
>=20
> Thank you for the detailed review of v2.

I think you misunderstood. That was *not* a detailed review of the
driver, and it was emphatically not a list of "fix these things and I'll
consider looking at it".

Quite on the contrary - it was a "you've so obviously misunderstood the
upstream process that my LLM can find a huge list of things".

In fact, your answers like "we now have AIC8800_GENL" make it clear that
you've really not bothered to even attempt to understand the upstream
process. We don't care about what you deployed to your existing
customers while your driver was out of tree.

The only way you can reconcile this is to actually learn about upstream
and be proactive, not reactive. I will not review this until you've
demonstrated at least a willingness to do so.

johannes
