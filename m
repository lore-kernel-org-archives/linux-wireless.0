Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF9238E5F9
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2026 09:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772011717; cv=none; b=hY1vbwS5EibA6iqPTYqGbJxF9d7VTDMV1fOCqazSujEEv/1+AxWjQtpgqYClVKUDtgJk45nT+8CYB/5VRrd3DtySmyG+++unr/EzdAIKcj25GP0rH+0V+Nd/groKrb7UPuaazVBozH2YoWi2cbPcNG0Iqc9hc54LjavJUfJ3Y+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772011717; c=relaxed/simple;
	bh=EkQdBeNw1j79fQy1wYivNxB022XRm4cXFAtD1zCJjKs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bvDppW+TkxhOajRsOHUNZHsk2laQSBwjTS0LeeXSJqFOxqQfBQoi5AdY5bgogYauJ1A/MPUWH7z9KD2BLpV5GSsWpgyCvqXKPkSFPq4Z8AoK86iJ3jCyqSw24eILJ/o8kgtttC/xhN2fj+6Eqts6lKgvenGOrjp3ATfpE7HEyvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=k2wwEDoA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="k2wwEDoA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EkQdBeNw1j79fQy1wYivNxB022XRm4cXFAtD1zCJjKs=;
	t=1772011716; x=1773221316; b=k2wwEDoAo0tZyUOLIlLDwc5n1xuHOwarDY1n467QyWuzhUi
	ZfgR/3ZPR32dlbbSqZo5Z2DDystpaPMZ6QTuoMNzgMUrt47f8FgOD5rFhfz6bfp8NxjnkXijz3Na9
	rlPar+9cfkTehu1p8v/bKwK8ppvZa8Pfxtr3XnxQBcrMfYXV6KSsF0/NQehiDMeB/xyXSIwk4kUbU
	IBMM0IpKN4Y1P6KfEzIP5qDESpRU9KYSPrr0pWpaXy4+qrBWdZCXN8wAvpqHJiY0MAH/BRrUkVE8Y
	SSwbeTv3V3aNXyK4K+ftK9vTCcZxcnZOoK4m32bqF6QSWhg5SemJRBz4ebRV5UdQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1vvBC4-00000001MhJ-1JOj;
	Wed, 25 Feb 2026 10:28:32 +0100
Message-ID: <593b5677967a24068cc92eefa3fcac23f3207079.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 7/8] wifi: mac80211: pass station to
 ieee80211_tx_skb_tid
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Date: Wed, 25 Feb 2026 10:28:31 +0100
In-Reply-To: <fbacd977-ab61-4399-b70f-554abc5afc4d@oss.qualcomm.com>
References: <20260223123818.384184-10-benjamin@sipsolutions.net>
	 <20260223133818.c932d807e54e.Ib7be90db0d3712d14e7a292023ff3d922baef860@changeid>
	 <fbacd977-ab61-4399-b70f-554abc5afc4d@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

On Tue, 2026-02-24 at 23:15 +0530, Ramasamy Kaliappan wrote:
> [SNIP]
> For the no_sta tx path, The sta lookup happens in ieee80211_tx_prepare()=
=20
> (invoked by ieee80211_tx). My understanding is that the skb still ends=
=20
> up being queued with a sta.=C2=A0 Is that correct?

Right, should have replied here maybe. Obviously, what we want is that
the error number to be passed down to ieee80211_tx_prepare so that it
will not do a station lookup.

The update of the ieee80211_xmit call to pass sta is missing in this
patch version. With that added, ieee80211_tx_prepare should get the
error number and take the branch that sta is not NULL. However, it will
leave rx->sta NULL as it is an error pointer.

At least that is the intention.

Benjamin
