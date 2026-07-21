Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0286944AB62
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 22:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671519; cv=none; b=pLtvGlgKq6jtYortbZ13riGG38DHqU3OqrvOMoYZ9ZIYX/3OIdiZWYAmmfcb03s1wHbZvsyxcVt/Co/hzjo12gJYi5a2lFyAj9AcAQnDXeRdsDw8wA+vLajWTRo+u2CMDFVM5Yvz0k23Br6pa9AgiviCHsaQq/KqY+1SMvzUi5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671519; c=relaxed/simple;
	bh=hyqtl41YLzvol3N8jecDTzOal7HTv6L8b3SNXxsTFak=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jWK6MlSYn3FlzOK6Lannvip/ZLkRkAMEmO52NJWu/ot94r9Ol4udq9l8D5BvEOUK6leLHqBG/O6J30UIMmjYTiNgs8jz+B4VsKb2g44KZ9+jWZZTeYBTSd+WmZybpPkaoUcYmB5sevVyqjOJSFp51hri0ORVfGVs/aQT4HMYJY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rsqXlX71; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rsqXlX71"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hyqtl41YLzvol3N8jecDTzOal7HTv6L8b3SNXxsTFak=;
	t=1784671516; x=1785881116; b=rsqXlX71+PzJW8QMyKuVbACeuoC6PcphIhFr06xFrBYIait
	WdBBiylrZFpZSGCtELnNGUsBP63iurXdOO1T0GZ5TolFXFa3C5EySv1iAc/wI3GYsHgapbWrbZhiZ
	4iNrG3z11sVNZLhKTnpBfkWUVMOO5/s5dsoNxTEajEdrVrJDCRKUbQUUdeHNl8JxDHHcK4oOIiP5l
	tMhD45RI+orV12IHTCkosw032RZfexzuKYDaZIX+q67qXchg8JNGoP9z0hj/fHOGSg6ZscR0wxbDi
	c1ZI2l7vnsYZcLPiTi9PAn3yKn+nn3V9vn/7FDp/f+UIIGblN5IKFjw6qL+ioZkg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmIaN-00000002zGl-2fhK;
	Wed, 22 Jul 2026 00:05:11 +0200
Message-ID: <4ea5025bc19f0ec89a42427aadb45e943884400e.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2] wifi: cfg80211: fix regulatory.db
 async firmware request blocking __usermodehelper_disable()
From: Johannes Berg <johannes@sipsolutions.net>
To: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 22 Jul 2026 00:05:10 +0200
In-Reply-To: <8857cc85-ab3d-44de-8ddc-cb9a4c22709b@oss.qualcomm.com>
References: <20260629063159.3288957-1-kavita.kavita@oss.qualcomm.com>
	 <8857cc85-ab3d-44de-8ddc-cb9a4c22709b@oss.qualcomm.com>
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

On Mon, 2026-07-20 at 10:26 +0530, Kavita Kavita wrote:
> Gentle Reminder!!

How many exclamation marks make it non-gentle ;-)

I really cannot convince myself that this patch makes sense any sense at
all. If there's a problem between request_firmware() and
__usermodehelper_disable(), why would we fix it in *wireless*??

johannes
