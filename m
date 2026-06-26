Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C282DC792;
	Fri, 26 Jun 2026 21:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509805; cv=none; b=L0Np/H+QzO1ocvjej/mZXHtDuGs6D3IsoNBVUBi+gpn0YjdnIpPejbNafL2KphsnDy4IK0GvaxgUAqCJXG6CNNDqx6HVf9T4TjGyc5oGdzDdUtQ2++rO0V1R7v86V1303Sx7dWv9rKEM8/9uY6VUAZSF3BeIpFK+VBO7Vk4GaxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509805; c=relaxed/simple;
	bh=zckgT7PpISHzXUahsmEIGOhJiYtmj8pDLtMjbiYTLt0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b75NdD6dkgBWTZOwnSqQH245M9rc0Zr267FOFG73ob5RIN8dj45Y+jqBiZZiFfee9CUJTEMhCyIJjfOckkkv2KVvRN/kNuemeFP+y3BesxdAC+GI8S6/m82y2XQZQnKON1Q09WDrFqzr5h+kT7FnDDDkP3j3GEPdH2kn6ZM0g/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vPXuG2ni; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vPXuG2ni"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zckgT7PpISHzXUahsmEIGOhJiYtmj8pDLtMjbiYTLt0=;
	t=1782509803; x=1783719403; b=vPXuG2niNK3mWFCH05ewAzqIVwSLUq1Klcs2iU2o2YHD7wK
	4NPa+P6tejpUweoj3GlLuiGea1tQJ+yEjUyzcXREGpBVrvU0K48WD+W3tMkyn51DNbJpZVhnfTuxN
	SL9nkrW6t4/bcGL+YsGJa2yy6kXPPRiTVuqzda6L6mqK7lTiNF3N6UjAK0hqQYu0reZppHMgpXFcr
	dm2m93a+YAF9OL5/7g9+pDHxfCHqlYHtPUyaTFER2+OlazBsmhKQ/hks4n3+iLmLJ3M5PsHcokfAi
	tvsL2jGrCKlOprLOmQwFzVfSWzLTEwdFusCKemRDXYXmvFGshftNHWZHKHUTLspQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wdEDO-00000007yYc-41o5;
	Fri, 26 Jun 2026 23:35:59 +0200
Message-ID: <2bc48524a11ab0065b33c8a02b4c442665852d93.camel@sipsolutions.net>
Subject: Re: WARNING: at rate_control_rate_init, CPU: syz.NUM.NUM/NUM
From: Johannes Berg <johannes@sipsolutions.net>
To: sanan.hasanou@gmail.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Date: Fri, 26 Jun 2026 23:35:57 +0200
In-Reply-To: <6a3eedeb.87857ece.10923b.5b31@mx.google.com> (sfid-20260626_232358_999373_6E38D4CE)
References: <6a3eedeb.87857ece.10923b.5b31@mx.google.com>
	 (sfid-20260626_232358_999373_6E38D4CE)
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

Dear people who run modified versions of syzkaller,

> Kernel Branch: 7.0-rc1

It might be a good idea not to use an old version.

> ------------[ cut here ]------------
> WARNING: at rate_control_rate_init+0x3a4/0x420 net/mac80211/rate.c:53, CP=
U#0: syz.7.23087/97240

and it might also be a good idea to check if syzbot already reported it:
https://syzkaller.appspot.com/bug?extid=3D9bdc0c5998ab45b05030

(FWIW, I'm not really entirely sure of the bisect)

Thanks for reducing (future) noise,
johannes
