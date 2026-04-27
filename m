Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802992820A9
	for <linux-wireless@vger.kernel.org>; Mon, 27 Apr 2026 10:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284050; cv=none; b=WIl8+EUhQsRL1Xih1K2rFToMqMEsHE9vgwHzwyZdqfOGp7dXVXlaeflqhoySu11n10tSgumjCFwUByM3OUQBPbqY5XAACQcIOwtb3bG09XwI0mqcgJJXp2nYu4/DYifHzsAQTYQqhQbCuZGnskGOpZN50Q58Vv+jqaDCE7BXsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284050; c=relaxed/simple;
	bh=63qDyFtNkrR5SR3geXoRKUFBw4uJE3Jk5mJ9XFV59ng=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HSqq3sTTAU2KuP8mzX98iirs6FOY1Djn3lLW00NInhVAlgcJQyldUHBrccdyv5d4efsDspu8h00nAt7wUoO1Gat6QFH1ik4jvLGLC0Ot+qfg0laHzMALWYo89W3b//rzwYxlx+bt6U+Ni8Is7ctL7oE0EOg8UV4c5nO+r+UIdxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=BW3BixB6; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="BW3BixB6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=63qDyFtNkrR5SR3geXoRKUFBw4uJE3Jk5mJ9XFV59ng=;
	t=1777284048; x=1778493648; b=BW3BixB6ns/r46GY5gMNLTslgRg9/YCTdzekbnd97A6RfL3
	V5YZgCg81yegXUHz5KknOKeUYau/1TFOW9f5D2lv5GDqv14R6BiUnqDB1th0w2R+17ic1HgKHelr+
	vIi8Nt7BTSTBt15S3YnR/KxGdmjuRoW0fpgLuzwybv1VHBcuVxgt9I1xmClOTCLw530bNxc7dg7c6
	Z5Ts4qefzNAvEewxhseedDcvVX6m0Y2v+jHlMLmC6gLclYx+rKEJD4DE0Lm4lr5ha3k6vofvDF8KB
	hSxOvd9FD3aVhKatsloQ4dQ84ECemIRYsCzqSPxTq1Y47wutjS2gXKjclhn9phWg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHIlh-0000000EpTk-18np;
	Mon, 27 Apr 2026 12:00:45 +0200
Message-ID: <1f57207139c3fb955459425deda4d06c374ae212.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: mac80211: Fix ADDBA request
 rejection after MLD link removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Manish Dharanenthiran <manish.dharanenthiran@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Hari Naraayana Desikan Kannan
	 <hnaraaya@qti.qualcomm.com>
Date: Mon, 27 Apr 2026 12:00:44 +0200
In-Reply-To: <20260415-addba-req-v1-1-6eb9a33d8ca6@oss.qualcomm.com>
References: <20260415-addba-req-v1-1-6eb9a33d8ca6@oss.qualcomm.com>
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

On Wed, 2026-04-15 at 12:21 +0530, Manish Dharanenthiran wrote:
> From: Hari Naraayana Desikan Kannan <hnaraaya@qti.qualcomm.com>
>=20
> Subsequent ADDBA requests from a non-AP MLD can be rejected with status
> 0x0025 (Request declined), preventing BA establishment. This happens
> because mac80211 checks the per-TID A-MPDU session's tid_rx pointer to
> detect timeout changes on ADDBA updates. For drivers that set
> SUPPORT_REORDERING_BUFFER, the reordering state is owned by the driver
> and tid_rx will be NULL, causing mac80211 to incorrectly decline the
> update.
>=20
> This can occur during MLO link reconfiguration, where a non-AP MLD may
> remove one of its links while a Block Ack (BA) session is active. After
> the link is removed, ADDBA update requests sent on the remaining links
> are rejected, preventing BA establishment.
>=20
> Fix this by calling drv_ampdu_action() on ADDBA updates when
> SUPPORT_REORDERING_BUFFER is set, so the driver can accept or reject the
> update based on its capabilities and allow BA to be established on the
> remaining links.

Pretty sure this will break drivers, particularly iwlwifi, if you don't
fix those first.

> Note: A similar fix has been proposed in [1]. This patch also fixes the
> issue mentioned there. The difference in approach is to keep a similar
> flow when the dialog_token matches. Previously only the timeout value
> is checked, updated that to check the timeout only for the hardware that
> doesn't set SUPPORT_REORDERING_BUFFER. In [1], it was changed to invoke
> driver unconditionally when SUPPORT_REORDERING_BUFFER is set.
>=20
> https://lore.kernel.org/all/5806bab7e46506d3c300ab4eb66989d42936aeb0.1771=
323902.git.repk@triplefau.lt/
>=20
What was wrong with the approach we discussed there, other than nobody
implementing it?

johannes
