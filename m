Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8A25AAA75
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421402; cv=none; b=hWQcCak1LSlD81ZaVCMU+4Tv8z/4YeAYxFaiYY1QnOmWc7JoHgJ2Kmaoh4PD4Huve027bkw5ENz7mwzOz3U87KCltWhFWpRk6/FFPo1LZM2N907fF/TjppX9ZoTr2hQ3rg8Eg44fUjDfPPPpKR1Hi0hYRdwA/6B5LFaLjy2GTME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421402; c=relaxed/simple;
	bh=luKaiuxvmAcNima0/Lz4mjAAF9gJbNVCtFBu5JEt2uQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FnA2ICKAYd15RT+aGXxkYizW1RrkDrdMKtOqiRweMHPomWCDgahGmsltpyWZbmiKLFFgt9n7MIEhQkEXREhQ+GQxYz8HxS1d+Xwv5k7n17AeNuNkT1i5shj3TGvOMu9wf1RdjfmlavwFO0uSr3S9FYs/mdKrZiI/Wk/Za012G0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UwAZ9gZc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UwAZ9gZc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=luKaiuxvmAcNima0/Lz4mjAAF9gJbNVCtFBu5JEt2uQ=;
	t=1792421400; x=1793631000; b=UwAZ9gZcVaLsZzymybP7slLwlzVwU3CINqoY0tZJpuz3kz7
	FKEURo9CWjM+ltHi7OnUKUxeeXEi49R8FHP2JB1Ily2TZeB0zQ/Nlq5ACRn4OCddYHOQ+DOYGiiPA
	zgywM25Gj3KHNqORaSlYmP/TqLATh+f9XIDHi4KALr4sAeui53Oc0Df8GXfRLVrBqsYByk2c9Nsi2
	p/7mMhv2XehioqiMVW8qunciInrOYuPiajS5BjrJtvoyRA7yZV8tHqrNyZewzHKWK8wWv/btcTekx
	AQKYOHfpVcXU3XmRvQl4DzmHp6C0kTHwQBRdxXXnGhEt0lRqSRaWUxK9CrxRA5tw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xIogX-0000000DR1g-3qaG;
	Mon, 19 Oct 2026 16:49:58 +0200
Message-ID: <c90d2612d4ea4a49e41c93b45133329440a4c727.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 1/2] wifi: mwifiex: append hotfix
 number to firmware version string
From: Johannes Berg <johannes@sipsolutions.net>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: jeff.chen_1@oss.nxp.com, linux-wireless@vger.kernel.org, 
	briannorris@chromium.org, Jeff Chen <jeff.chen_1@nxp.com>
Date: Mon, 19 Oct 2026 16:49:57 +0200
In-Reply-To: <20261019142809.GC118352@francesco-nb>
References: <20261012123624.3147417-1-jeff.chen_1@oss.nxp.com>
	 <20261012123624.3147417-2-jeff.chen_1@oss.nxp.com>
	 <20261019141347.GA118352@francesco-nb>
	 <6b94b803c6424227f6ebc044e0ff2e6b90c180c9.camel@sipsolutions.net>
	 <20261019142809.GC118352@francesco-nb>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-10-19 at 16:28 +0200, Francesco Dolcini wrote:
>=20
> Jeff, up to you, we can take the patch as it is.

Wait, we're discussing mwifiex, not nxpwifi, didn't I already apply
this?!

johannes
