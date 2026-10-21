Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792596113;
	b=p4rH1EdctNO35QNSKKxQuXsn21NQw9DpIEWUY3XbzajiB9JA/2bsVrpP+CuELlt678ql
	 ZsqZWJCm9zdIYUqDrCv27IIBW7aEF9XjjmHr9SBsx7sHb+8f0wcpvKUPA2jycDRCOVSrE
	 DOaOflVnAdWvqNSouuPBvMI9SdUXTrSziCPSkr4Ektd1tTUN3YrTaPJaVPlvbbQtJYXD/
	 XWBAiZmjJOF7yJq0kWpyDPMfi/bsBPlHI+V2A7RdWrG/29iSvWcakncLuip2XMKJbXMCQ
	 2HDTJyewb4yYnJ0DHMdH7L0fqOqd0mO+ca7iZLHxH3Bx6f25YbbSIn7n/fn236ik+Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792596113;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=SnjS024GuYaQHHoMEGecQOUYWneE4opnzyTSvqqt2JY=;
	b=0ednTgdvXesx2MqvzSe+Ciba6QNjonW6KtW73xuMYZWr6BwqcpQjOXOMSYVr94fcxCaZ
	 kkPXfN5TCw7Q07mXzw7WqMSeIF/u1UglFYxfk9D+Cb6Pb6piQ6j58jXCy2dabIz7Uh2kp
	 r9DSlay5srydjE1Z93yaiPckm3tYjBcpUksYsmYuVlA1wETyda6z+PoedItGwlvuGMVcG
	 Fi2KKq/+Q95p5ET8F46iOqkV86yr705/rkS7EGTVwPuxQPX1XNrU/3ddNfuzZlaKTzT6X
	 U7RzS/o0l01a31abahSVNz355BA3q9wrvK4/n22A4jLhn5iv4WkOM9ZS0X9HYl3Cvuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=g35ejlfi;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2285B606A325;
	Wed, 21 Oct 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=g35ejlfi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SnjS024GuYaQHHoMEGecQOUYWneE4opnzyTSvqqt2JY=;
	t=1792596111; x=1793805711; b=g35ejlfivg1u1g5+t4T0oh+CKU9+luF4YB0E1gGljNXaqZR
	vt3NMyvo/YcujwvWRfEY7cj4KA4y/ReMsjhzO1BOBj3xLhr/r3RvcTI7IX8AeD6odAekClnw6PcvW
	qrPOOEmE/H6lUGdFUUE5V3eauGFYHQnXSANZ+wpWoPVa5Hummo15runJftHBVZdlmp6UHy02Dip37
	O6AXpqfxszaUr8lvejPPXq1XijjSoCe2oMc/N0RybNrqxDC2uZNr5H/UpCz6HWadY0TUJk+PX381k
	KGujgh6OC0DYpisfSCdmWyLffjcuSDJD2aCvC2DTTbiXYwzjFlAJI77FZz1Z6vIQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJY8S-00000002TPF-2fwv;
	Wed, 21 Oct 2026 17:21:48 +0200
Message-ID: <8a508046f36d8f483137ab6715722318af2b147d.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: wext: Limit notifier event flushes to the
 device's netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Cosmin Ratiu <cratiu@nvidia.com>, linux-wireless@vger.kernel.org
Cc: Tariq Toukan <tariqt@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>, 
 Dragos Tatulea <dtatulea@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
 netdev@vger.kernel.org
Date: Wed, 21 Oct 2026 17:21:46 +0200
In-Reply-To: <20261021144111.611840-1-cratiu@nvidia.com>
References: <20261021144111.611840-1-cratiu@nvidia.com>
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

On Wed, 2026-10-21 at 17:41 +0300, Cosmin Ratiu wrote:
> With mlx5 netdev instance locking enabled, registering an IPoIB netdev
> calls the WEXT notifier while holding the instance mutex.

I hate wext :)

> It may seem strange that the fix for a lock cycle across multiple
> subsystems lies in a completely unrelated part of the code, but this
> seemed the most justified lock cycle edge to break.

Yeah, seems fair. Finally a good reason for my ~17 year old commit to
have the wext events per netns? Today I'd probably have rejected it as
useless churn ;-)

LGTM.

johannes
