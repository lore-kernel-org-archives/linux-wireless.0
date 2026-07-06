Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C55F3AFAE0;
	Mon,  6 Jul 2026 10:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783334268; cv=none; b=aAMnBfmCGCU6qIiOrDTaI9n0Es0GGwJZ+icS3dOnPPzJ369sFOmZxoCJHHmpTriWViA98TlIs9ytydNXA+QkcskfiTtl62fpVbyJcErJ39YeFfeNntOiko12kdn8HgVYlY+/TUdIlmSkeJisMdrQocsIHnGhTaxtil/36jXWkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783334268; c=relaxed/simple;
	bh=70DB+crKdAn5t3MarAwEHdKaAEIJV+wYO9z148L6D8k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZVCXp/ftSIV7s7YuI78Fjhr+Vnz3QDp61Dh3Fza25lteYMC7StW2+uqeoGk/+fvRgsGfq0eDgfumltEbwsUMWL6aA6g1MU2rG0R8fq1AnF99T71NLC0BEEc8YnmD0QTwtG5kcRuY7mffk8CSEhe+g0vn2J+YJQ34Usg3GCkPIbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=QVZw1nVN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="QVZw1nVN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=cTKHlkUlKyFrya+FhJXp8WuW7bCMIJ+/sIackbjAeqY=;
	t=1783334267; x=1784543867; b=QVZw1nVNE4SdXsCCeRK1VaN3HubJ19HemlDf/Dy6I/Vgx5z
	gPKMh22jneash+lq00haIxNWqDnxHueQFHplUNogD5GOhxPdOWmIHUDoOd4DaeN1WFEmn74EspxbJ
	gWrN9i8yG1I9VHeILA10WfD3yjDjtdmOR1CwM9K+IwbGtylz5lwgaTHQ2Y8o3BcOCRFO1TiNlJ/Ii
	nVOTYEmFMBDESg3AtZWbkLhqgfgfCmH7HmSbSdEYJKQC3PUTMdnusPS+Rj7lInh1cqnL+a7A8yJlL
	hmu36e9+deLxrynQglekD25/CbcsGRSTrpt4/Nb/JWb04clMMTE3ij6MYjk77WUA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wgghs-0000000D61z-2zyu;
	Mon, 06 Jul 2026 12:37:44 +0200
Message-ID: <488ed9862d5196b8f5ecf23f037fa6725fbe9a52.camel@sipsolutions.net>
Subject: Re: [PATCH 1/3] wifi: cfg80211: validate rx/tx MLME callback frame
 lengths before access
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Jul 2026 12:37:44 +0200
In-Reply-To: <20260612185042.66260-4-enderaoelyther@gmail.com>
References: <20260612185042.66260-4-enderaoelyther@gmail.com>
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

On Sat, 2026-06-13 at 02:50 +0800, Zhao Li wrote:
> cfg80211_rx_mlme_mgmt() and cfg80211_tx_mlme_mgmt() read the frame
> control field without first checking len >=3D 2, then dispatch into
> subtype handlers that assume their fixed fields are present.
>=20
> Add a frame-control length gate, then validate each subtype's minimum
> frame size in an if/else-if chain that mirrors the dispatch logic.
> Trace only after the frame is known to be well-formed.
>=20
> Side effects of this change:
>  - The WARN_ON(len < 2) is replaced by a silent early return, since
>    these cfg80211 callbacks can legitimately receive short frames from
>    drivers.

Can they? How?

johannes
