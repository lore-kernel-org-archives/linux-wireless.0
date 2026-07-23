Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23EE40B0F9
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 08:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796128; cv=none; b=XEEYY9TKjqF/slCSI0i2yvpwqYu+dDzdQ1Yw78b4QdBGpjhDkFr+0r0/ykbjzKseypp8xowKpEUmKa6pgBGJ8r1nzkJpr0GZLFMMejhb8sbGbHkKKDiB8yqcSlX+hJTQp2A5mJwlwdIC184pdPkxLSetRDc0ZZcjL/xsiy5thDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796128; c=relaxed/simple;
	bh=7tOOPIfJ76X6MXFh2ry+HLYJTARWMn+AoupRyZVwHkY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s7uvTh/Z/gkbUbhSlU7zLEOMqbMe1fC3g+3JKenseMW8hDVK7fBNfOJqzSvX+xE1hhdwcj8sUmxxcVEbGdlvaPUk1LOhgFJzVA3rRWBWJyzDFthK/ryuqvvsMzRcGk9rkjaNLIUcr+O3Am+SjnSRy6VOrNxdRMZY8gQpQLdkj0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HvKwJFL2; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HvKwJFL2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7tOOPIfJ76X6MXFh2ry+HLYJTARWMn+AoupRyZVwHkY=;
	t=1784796127; x=1786005727; b=HvKwJFL25o/0avKJ4R+TYN37+krZdM24W94uxvhIOk3qhD8
	OcyTBquA5ctfY0Ou0N/DOXU5AuxlPuJt2cL9aKPLKQXLelITm+tgla8fL+Kub2KlVql945e2bPBNj
	XjTaO20RVLuFrvd4TQ0di1nOvxl5y5lZT7l2nEdvoP49nqozi8XmSrzfKzfv6DRWjYn7J+fcvnEN9
	7+mT/tZ6E7All/RVJbPAEwQNbWeAwwE7ZSrRWPZlyKxIdU0wubL+uKQ6NSIQlbH6KIPsNyMdvs8TW
	Myvu3Luz8XMsj67OZw0dWqESOCpx+2aIEVk5B4NcaeeL7p6Cziu+F6aycfaYWQ/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmp0F-0000000AQ6J-3E2Q;
	Thu, 23 Jul 2026 10:42:03 +0200
Message-ID: <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net>
Subject: Re: [RFC PATCH wireless-next v2 0/4] wifi: aic: add AIC8800 SDIO
 FullMAC driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Yanli Yang <yanli.yang@bedmex.com>, linux-wireless@vger.kernel.org
Cc: Zhirun Liu <zhirunliu@aicsemi.com>, Dijia Xu <dijiaxu@aicsemi.com>, 
 Chunqiu Liu <chunqiuliu@aicsemi.com>, Liheng Wei <liheng.wei@bedmex.com>
Date: Thu, 23 Jul 2026 10:42:03 +0200
In-Reply-To: <cover.1784724170.git.yanli.yang@bedmex.com>
References: <cover.1784724170.git.yanli.yang@bedmex.com>
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

On Thu, 2026-07-23 at 10:13 +0800, Yanli Yang wrote:
>=20
> Known limitations of this RFC are:

Known to you ;-)

You're not going to go *anywhere* with this if you just resend it more
or less as-is without every looking at upstream yourself.

This driver does just about everything that we don't want upstream. I
plugged this into an LLM and asked it to do a brief review wrt. things
that this does and upstream doesn't like, and it very quickly came up
with a huge list, but you really need to do even that work yourself,
nobody is going to review the driver in this shape, it's just too awful
to even start.

Familiarize yourself with other drivers in the tree first, start much
smaller in terms of feature set and especially Android-specific stuff,
etc. Using "struct task_struct" in a driver, really?!

So you have a very very long road ahead of you, which quite likely
involves more or less rewriting this driver, if you really want to see
it upstream.

johannes
