Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63328299937;
	Sun, 26 Jul 2026 19:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785094646; cv=none; b=VzdQYC1sxjGs2Xc0+nW+c655nQcPYriFLu8BpgPIjfwL2QuCWW0fF1+1rX87t6VOHrrv/cHb5LJLlISqBlO0WZ+dYDr3fjRqUpesej6cJVxBMFjMFtImaeErMciZQxkgREsrrkPsn9P9q4Q6F4EQ/VIgxhjqhsiWtap4o1+0XUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785094646; c=relaxed/simple;
	bh=AYAWMV58PmO78UreUzwpzq5ig1firj8vyN9wTLQHpVA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ey6V5y0LUuvDQGmuM1c9bP6O7HT3S1T/05QEKCtnBceHPHy7PrvxF8Rmf4K1s47JQ89qtmLCpuhQ0oH+dW5a/1wwJVPtDSUAkAY++/gjTNPmEZPXQumjyn35LS1jwMKtfsaVhlFcOaPLMDrcLto5UUjWP2ayDffXp5emLvwrwXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UXPDCQbX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UXPDCQbX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=AYAWMV58PmO78UreUzwpzq5ig1firj8vyN9wTLQHpVA=;
	t=1785094645; x=1786304245; b=UXPDCQbXGvO7ValS9mvF+FyrcHuYVcCSsddPctn2SjiPui/
	OgHKE7yAesfRlh8GQqeTrpQ/mes4SIDjvqmph7LUX66SXFa1DoSV/ew6kX6Ej3fw3gcJBmhHyg+yq
	AUtgKDr2N24k90hYZCPq99nnTXtgi2HEByXtp3LyUqorR3wn8/jeRzR4ULt0ymsv+Me/3evTrn5Xj
	uyM5suZ8owQtDgVPIN02TLL6RQODtsqhZHTsrm9CbU7McCz0pcU29ri8PG4QQyA/MaVVZq61hO2k6
	j5l8KmKsBE/ufeXiP8c06gt5j+ywZWym5YhXrsT2YZVcp0BB1AczXSlpkFf1mYsg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wo4f3-00000004E5F-28GE;
	Sun, 26 Jul 2026 21:37:21 +0200
Message-ID: <9b00d432905facbe0f86556eda6c2986df79888d.camel@sipsolutions.net>
Subject: Re: [PATCH -next 01/10] wifi: cfg80211: pre-assign cookie for
 remain_on_channel, mgmt_tx, probe_peer and tx_control_port
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
Date: Sun, 26 Jul 2026 21:37:20 +0200
In-Reply-To: <20260726192541.2816743-2-arend.vanspriel@broadcom.com> (sfid-20260726_212600_559050_A9FD5109)
References: <20260726192541.2816743-1-arend.vanspriel@broadcom.com>
	 <20260726192541.2816743-2-arend.vanspriel@broadcom.com>
	 (sfid-20260726_212600_559050_A9FD5109)
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

On Sun, 2026-07-26 at 21:25 +0200, Arend van Spriel wrote:
> Having a single place for cookie assignment and keeping that
> responsibility in the cfg80211 subsystem is a logical choice as it
> handles the userspace nl80211 API. add_nan_func already does this:
> cfg80211 calls cfg80211_assign_cookie() before invoking the driver.
> Apply the same pattern to remain_on_channel, mgmt_tx, probe_peer and
> tx_control_port by pre-assigning the cookie in the nl80211 command
> handlers before the rdev_* call. For tx_control_port the cookie is
> only pre-assigned when the caller requests an ack (cookie pointer
> non-NULL).
>=20
> Drivers may still overwrite the value for now; subsequent patches will
> remove per-driver cookie generation. Update the cfg80211_ops kerneldoc
> to note that the cookie is pre-assigned and drivers must not modify it.
>=20
> Assisted-by: Claude:claude-sonnet-4-6

Hah, I _knew_ it, just based on the text style, before even reading
beyond the cover letter ... I'm starting to even be able to tell the
companies apart (not models yet, i.e. you could've told me this was
Opus). E.g. "Patch 1 is the enabling change: [...]", "Non-obvious
aspects" or "This means the cookie field is threaded through" etc.

Fun. What weird times we live in.

But you forgot S-o-b.

johannes
