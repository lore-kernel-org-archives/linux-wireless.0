Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF03D6CA4;
	Mon,  4 May 2026 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777907488; cv=none; b=fCguhzkhTkLjEW1JtzJO4+sfAdNjT7Mf0AuUr2Ph0YdnoycCWdNJQRP6rvzaKMxDnLQv54ROhYKzmAQbAY/X0LKRYFTzOcsbmIu9YZBYMXYEQPMwau/wXqAxA6fDef5zZSRu5Lz0SpnJlOUyyBXQKimdCeG0FCEAUR3KP6tG9TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777907488; c=relaxed/simple;
	bh=YVRLj2COanz5C46+3L43OzPmGxR24wjHetcfrEhAoA8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kx3cJLTh9S7eVty+PFpT3mKZmLc3yExrpp28Zq6u7n8tWBH4uTqgkmlWVZOa2lQfPVJSkrVzuXikt6wH09pq5n7stAS7xANASJv7i09+xH4klmrILbx8ZdDobhje406eg1kDeEbRmahtB8CRDZR20eEDlI5shZRIcPQzax5auKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aKl2Ywsk; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aKl2Ywsk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YVRLj2COanz5C46+3L43OzPmGxR24wjHetcfrEhAoA8=;
	t=1777907487; x=1779117087; b=aKl2Ywsk+xpBpjkj+e18GWWfL0up02VlVupmCPfdnc/bLTQ
	UzBWpCGxapFF/rcc+oWFfRIZl0dpvV4137KZelOVgkk0CYch4uEnKYGZGOzGi3M0SJDKWSvMNobmQ
	BFv1Z+C+MONWVuUDpdOGdSPOLaW1EmcreV4cjl6CzV3s6mo76z9DaXFqcc371frLOy8tGEmcRrxs3
	P1stPBS04px7hIwcC0Yf9mrZhEqBMLdtaa0WeEeGMavHIWu4LW7dXM5E+F6ym69K6+rG2FYmLTuet
	7GJhozwtkL9YpgLlDUrHsUqi6a0WbK7uSVUItRBDyiHhRpIMleqzY9pOXXPHiXKQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wJux8-0000000F1Zj-2Zl0;
	Mon, 04 May 2026 17:11:22 +0200
Message-ID: <728ff47b9f1ded89829c7dc186881ad39fbe37af.camel@sipsolutions.net>
Subject: Re: [resend PATCH v2 0/1] wifi: libertas: fix bug in Marvell
 Libertas driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakov Novak <jakovnovak30@gmail.com>
Cc: dcbw@redhat.com, kees@kernel.org, libertas-dev@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linville@tuxdriver.com, mingo@kernel.org, skhan@linuxfoundation.org, 
	swilczek.lx@gmail.com,
 syzbot+c99d17aa44dbdba16ad2@syzkaller.appspotmail.com, 	tglx@kernel.org
Date: Mon, 04 May 2026 17:11:21 +0200
In-Reply-To: <20260504150416.4853-1-jakovnovak30@gmail.com> (sfid-20260504_170431_315835_9FEDF50C)
References: 
	<57275e905a67e789ea438bf637be0aeb442fc880.camel@sipsolutions.net>
	 <20260504150416.4853-1-jakovnovak30@gmail.com>
	 (sfid-20260504_170431_315835_9FEDF50C)
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

On Mon, 2026-05-04 at 17:04 +0200, Jakov Novak wrote:
> This is the same patch with the suggested tag and message fixes.
>=20

That makes it not a resend but a v3 I guess ...

johannes
