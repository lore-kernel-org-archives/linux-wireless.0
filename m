Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84E54908DC;
	Mon, 21 Sep 2026 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790007943; cv=none; b=adm7jTsbpZ/t99+hSoZ4hoXsQ90APNvR7zrPjLVRjr6qLhK5Kl26vfeYqrErpLtj8lm0tLr3wFpKwPJ000o99DlXVyQpv3dbWifE5xsNKMteqEZAJvFciKr2Ane1gnNf1+8/L8rWyllC25iJr42RR8X/AA0Ay+088VvM5M7J6K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790007943; c=relaxed/simple;
	bh=Iv7m2O+PBXEyDEg9P1KLutmzrSPth3ZcpmF+Bsv83C0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bfJXm/bMdLTqEPJi2+FiVqFp9UB+VJfzHNPC+suViRlFuUWu9+Eb6vlo9uIJYUrseJALh+ro8LNmjyWADuh+YwwBB80GeFRoHsEomruTnAUcaxsSbqCh1zfPtl7Ap3yeCU2GEmXaE/xN+xae9/BDvfyj9sClGAGLoMvqZUVyPiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pmK1kVff; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pmK1kVff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Iv7m2O+PBXEyDEg9P1KLutmzrSPth3ZcpmF+Bsv83C0=;
	t=1790007941; x=1791217541; b=pmK1kVff34V7BZXVXFvNC+M/uKFhWAh21bMQATalFvaTr7f
	GvDaa3pVUvkvFMavGC3AGeCtmNG5X57JtTE0nYbw9Z87kbcKFXgnf5idGBOuYBsNJ80d6i/00kEEZ
	Zlo8tgRzoxBEjim8wjYy272+Ie96OZIOHnljOk3IXFK0JzmFxdXZwRBDggtQCvuWHBEWeUnoMPsk8
	b1fDOEfEPtoRX+0dR4mUq8exa9aPvOL0oBLJlc+0ScoqxY4TdNBxk9vMZvjW926SkNwN+L7CeaGjO
	6BbzWSCia+QUq/4P3/ewgARwSJ62BrkQEKvaXwNkt7y9crg9r69V4HesqQhe9lTA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8gpl-00000005wUE-0rJO;
	Mon, 21 Sep 2026 18:25:37 +0200
Message-ID: <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Michael
 Straube <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
 Bitterblue Smith	 <rtl8821cerfe2@gmail.com>
Date: Mon, 21 Sep 2026 18:25:36 +0200
In-Reply-To: <20260921154347.82317-7-luka.gejak@linux.dev>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
	 <20260921154347.82317-7-luka.gejak@linux.dev>
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

On Mon, 2026-09-21 at 17:43 +0200, Luka Gejak wrote:
> Add Luka Gejak as the maintainer for the RTL8723B/RTL8723BS support in
> rtw88.

How's this supposed to work in practice, managing patches to the driver
etc.?

johannes
