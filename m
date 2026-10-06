Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177563812F6
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791270907; cv=none; b=OssBdlCt3lIugFr5ptQusEZ1CD3ReRpnZ0XPejSZiZCw/LafjJMgmZABX/vuGo0+yTk4V3H8RI7wHJD4SwLtuRIKBNO56RTIsT1+EDfCtIF4VDhzbbcOL/HR2Wl1COyaUylyq6R+AEASsZt0YAkQeD1DNPdf0qPbSLRFXnW7rKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791270907; c=relaxed/simple;
	bh=o1oLphuqmiswyZMKGrNkDTUIRMUMVNXDHs4za8xzywI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A7K2FJrJtGLkfX+bwhqhmSoGrfqpWP/HdLAtvIlkiP8I7+W7SGypz+u1qwZ4heVu9CiswYnvbmcRAc4OMiDOzkUrt5uedkcXFEnPresQyBnP2QUu3BuidFtekIHLYz3s8jrxUvtXon8sCrtp3adCHN7saSK0UruAFNc2s6nESKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nANisy8b; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nANisy8b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=o1oLphuqmiswyZMKGrNkDTUIRMUMVNXDHs4za8xzywI=;
	t=1791270906; x=1792480506; b=nANisy8bW5ti0BAwzCKRzTBPg6UyqGcPV/k01hFDvjkrqvM
	jRRa0Ytr8PESMPjSat+ijDx8EXfbV02763gIMfmminm0+Uy7qwxeXMvQXqoyg4SSifBOYurpCrIJW
	/cVK7Xs/kv4D9yCY57ggC/6WLkOu8Cat4goIHmRvFS8sRVgccuzsJsY9oJhsrpy3q3kh6EgZTnioc
	M5Kot6jJtzVjLziYY2Rf9GhTafl5GrnRaCOmaToPqFF0dDuJOvyS6HqjWxqwTUB/aOzR6PBjAAXle
	xQ/gp/bk7K+hmGT+92frLR35Fwp0XNZ8ke+GHqt9EotIXE2MZxCAiXguqqrSbOSw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDzO8-00000006OuY-2f4T;
	Tue, 06 Oct 2026 09:15:00 +0200
Message-ID: <623f20912fee5ed614e3a884f54c116bb8f2944c.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 00/12] wifi: AP side locking improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: "ath12k@lists.infradead.org" <ath12k@lists.infradead.org>
Date: Tue, 06 Oct 2026 09:14:59 +0200
In-Reply-To: <3db68884-f6b5-499c-9959-7eec59ba40cd@oss.qualcomm.com>
References: <20261004214504.1636783-14-johannes@sipsolutions.net>
	 <3db68884-f6b5-499c-9959-7eec59ba40cd@oss.qualcomm.com>
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

On Mon, 2026-10-05 at 19:05 -0700, Jeff Johnson wrote:
> With both the redux and this series applied, I prompted my review agent:
> prior to the 2 patchsets (18 patches and 12 patches) ath12k relied upon t=
he
> wiphy mutex to serialize many of the mac80211 operations. are any ath12k
> object references now subject to new race conditions with this entire set=
 of
> 30 patches applied?

:)

> The reply:
> <LLM>
> New Race: ath12k_reg_notifier vs ath12k_mac_op_start/ath12k_mac_op_stop o=
n
> ah->state

That's a fair point, but easy to resolve - we can just lock the wiphy in
the loop of notify_self_managed_wiphys(). It already can't go away since
we have cfg80211_mutex. Looking slightly deeper, we should guarantee
that we hold the wiphy mutex for a bunch of these operations to the
driver, and that needs more than a single line of code, but looks
totally doable.

> Pre-existing but Newly Exposed: ath12k_regd_update vs ath12k_reg_notifier=
 on
> ah->regd_updated
>=20
> ath12k_regd_update() is called from ath12k_regd_update_work (a workqueue)=
 and
> reads then writes ah->regd_updated with no lock at all. ath12k_reg_notifi=
er()
> writes ah->regd_updated =3D false also with no lock. These two were alrea=
dy
> concurrent before the series =E2=80=94 workqueue items are not serialized=
 by RTNL =E2=80=94 so
> this is not a new problem introduced by the patches. However, RTNL previo=
usly
> prevented the reg notifier from being called while a mac op was running,
> which reduced the window. That window is now wider.

I don't think it's correct about that widening very much, "RTNL ...
prevented ... while a mac op was running" isn't true for most
operations, only start/stop (roughly), and e.g. sta_state changes the
state here.

But you'll need to fix that locally in the driver anyway.


I'm working also on adding clang context analysis to all of this, but
I've only _just_ (yesterday) worked out our internal build systems to
have clang 23 to be able to actually validate it, and will obviously
need to redo the (very small) adjustments in cfg80211 on top of this
series. Then we can annotate such things with clang and the right lock.

johannes
