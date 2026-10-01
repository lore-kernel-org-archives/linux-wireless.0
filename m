Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAA939FCAE;
	Thu,  1 Oct 2026 20:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790885969; cv=none; b=KdsxoI73mXEQraJ2+iH3uyjstPFFA1jN3ti6Nu2zEzVBSG/LfxhO9pKoTNzoC0cZ2CJcuT9Z/DWG5chBPeOr1Gp/MXaSOwrzXR4qWBlYWuHhjS4POeakxGQdbmnQHJtiioZGfziGZBNN4d76g9HW9fybpReZGwY5STW75cteO3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790885969; c=relaxed/simple;
	bh=WTo7VA2LESgZ7Kd4Pt0GivZRGYJ5cCilvCtYAC/GiyI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k2cCRrzjllGzBM9WEbH6j6M6YAaqdxCu1ZqqFdR3VBsXlrzBCu1dZjbzXBjOpTdD7+UViZsrzbt3OmS1E1av3WlRjqYJhz7Q/vF7T6LsDLUpz5uJWt73GBUI7DtsCJ7z9dZJHvVvwUUExLaanqFOx36nJGnDkVDGeLbjMKbfla0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cWAOycCV; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cWAOycCV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8DkObyjFpWlzUsKh0ddtC3dRDIwRGpzyzE4rGlKzL7k=;
	t=1790885967; x=1792095567; b=cWAOycCVV3krIiWvwBvozG4Ja5gpm3fbyQgfmT7PgC4YCAt
	QQvPjcpbvuh6PYkhm28ginPg0/sYrv/kP8a2eYaX7EfqunQxeijUX0+7lX4S0NRL1D9rLw1/dqo7Z
	rNY5cihOl556manPKIM571dG5Tff1nVpDWrZuYyPsnt5PhN+2B75s0r+nrXhuc4jMy9e3KOM1iAIm
	aLUDnAi6ZyobhJsRcE/LXUy24GNX00ChHeya8Em7AePTYqSnlcRRgog9Q0i0PakggDIzGOokg5lPE
	B5R54r2Eivbo8mDAnU1LfCel9Nic+BfRmGs0LS9XyQNO+pmQN8uc5Er9XEo8Jw/A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCNFT-00000000Qug-1EC3;
	Thu, 01 Oct 2026 22:19:23 +0200
Message-ID: <d1f53a596835f79580b2078a83820d98d795ae17.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 10/16] wifi: nl80211: Define attributes
 to pack SMD BSS Transition context
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>, Kees Cook
	 <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Date: Thu, 01 Oct 2026 22:19:22 +0200
In-Reply-To: <20260924-smd-v2-10-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
	 <20260924-smd-v2-10-bb40094da1d4@oss.qualcomm.com>
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

On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
> Define nl80211 attributes and policies required to pack SMD BSS Transitio=
n
> context along with NL80211_CMD_FRAME to be sent to userspace, and to set
> and get the context during roaming via current AP MLD and roaming via
> target AP MLD. Without these, userspace will not be able to transport the
> context to the target AP MLD, program the context on the target AP MLD TX
> and RX queues, nor fetch the context on behalf of the target AP MLD if
> the ST Execution frame is sent directly to the target.

The commit subject and message don't really seem right - you're also
adding all the commands.

> + * @NL80211_CMD_SET_SMD_CTX: Set the SMD BSS Transition dynamic context =
for a
> + *	non-AP MLD sent from the current AP MLD on the target AP MLD managed =
by
> + *	an SMD-ME. This command carries %NL80211_ATTR_MLD_ADDR,
> + *	%NL80211_ATTR_SMD_CTX_TYPE and %NL80211_ATTR_SMD_CTX.

This is a bit ... brief. Incomplete, I'd even say. How is it meant to
work, e.g. this carries PN data which fundamentally maps to a key, so it
seems the key must be there before it. Surely the station must be, and
it must be in the right state (whichever that is) etc.

> + * @NL80211_CMD_GET_SMD_CTX: Get the SMD BSS Transition dynamic context =
for a
> + *	non-AP MLD associated to an AP MLD managed by an SMD-ME. This command
> + *	carries %NL80211_ATTR_MLD_ADDR and %NL80211_ATTR_SMD_CTX_TYPE.
> + * @NL80211_CMD_SMD_CTX_EVENT: Event reporting the collected SMD context
> + *	(requested via %NL80211_CMD_GET_SMD_CTX) to userspace. It carries
> + *	%NL80211_ATTR_MLD_ADDR, %NL80211_ATTR_SMD_CTX_TYPE, and
> + *	%NL80211_ATTR_SMD_CTX.

Why would this be async?

> + * @NL80211_SMD_CTX_ATTR_DRV_DATA: Optional (binary) driver-specific blo=
b.
> + *	Passed through nl80211 as a blob; parsed only at the driver layer of
> + *	the current AP MLD and target AP MLD. First 3 bytes shall be driver O=
UI
> + *	for the driver to parse as required.

That's just a vendor command through the back-door?

What do you envision this carries, and why couldn't that be defined
properly? Is the intent to have some kind of optional data there, or
would the target possibly refuse the operation if it's not present?

johannes
