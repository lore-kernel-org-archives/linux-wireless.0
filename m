Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3D3220F49
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 14:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784729294; cv=none; b=H6fQCoC3ShoUrifWTuPh8iwVLKu3hTR5WbdC3xJHD2az93G+qZ0DZmAOGeYPM8F7aJlPskJNE0j9H8HD4H49u72j8mwLYBNU3u8CauQ9iW1iW87oiWC7jaYJpYLklXWLo5ETMN4ikxLPzzJtp6CUjHK/Qcdy7oCQV1fCC5Mtmas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784729294; c=relaxed/simple;
	bh=jA/RJgN7iNwL1TL7ToDfgZEDjaPa92kKT/MOaQM4m2A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nVs2b/EXh9oeYONG1H7D5Ycou2YLeWuSW/K0VwVcvXNvCH/RT5r+K2W0k5U0fegdZ/cqNnpt5bjavzQM9dQqrghwETmMNDM9P3ycbkUi6mMhTo5opZ8fdRAK0jwFU6IKV9OADyigmwk+hc5TyARKklP/LJlrSNDMLAfoIxLS6lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CMp52H+X; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CMp52H+X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=5cUC4k/3uqIOg3tp8YmbbS7HkkcktVvF8Cv4Ao3xCWI=;
	t=1784729292; x=1785938892; b=CMp52H+XbFXqKmRCdJLTY1PDiXror/IxJTH696eP3qWxVN4
	YrubKEv2W5S9evOrtRgZ02V6PohrdlSFOCKA39i4jI4JJOrkvd150pzbKPdtxTcpBFddj6GJgQkzX
	8iBylPPKoLkK6Vf/212MdaTgvpaJOFXZCPHxJA0qrmQwP768++fDmokq6vWw3O5IGDijVYDy+/0OA
	P0xrOwTYlvfvs7lrSOg1EBzr3IMY1i6/U7YVPH6tUOefcOOuQB3poASsRSiCzw3XK3rjlgYcJQjO9
	ycJWAtRA38LWAVrCE30XioeHRMsAbYD+pAfAveP0t5OHYEiON8a/qa2IP01FvcJg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmXcG-00000004nkt-0dpj;
	Wed, 22 Jul 2026 16:08:08 +0200
Message-ID: <67b88a3cc68473a1ee9d2816c4b5fe07c378434f.camel@sipsolutions.net>
Subject: Re: pull-request: ath-next-20260721
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, jjohnson@kernel.org
Date: Wed, 22 Jul 2026 16:08:07 +0200
In-Reply-To: <f73b76bb-dc27-42d0-8e47-b617eec766a6@oss.qualcomm.com>
References: <f73b76bb-dc27-42d0-8e47-b617eec766a6@oss.qualcomm.com>
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

On Tue, 2026-07-21 at 16:46 -0700, Jeff Johnson wrote:
>=20
> ----------------------------------------------------------------
>=20
> NOTE TO UPSTREAM MAINTAINERS
> This PR includes the merge of an immutable branch from the qcom tree
> https://lore.kernel.org/all/178362521364.2422497.1305957434056184382.b4-t=
y@kernel.org/

That's annoying, it added a kernel-doc warning that now shows up on our
output... I guess we need to ignore that.

> New warnings added:
> Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found for r=
eturn value of 'qcom_scm_is_pas_available'
> Warning: drivers/firmware/qcom/qcom_scm.c:1055 No description found for r=
eturn value of 'qcom_scm_is_pas_available'
> Per-file breakdown:
>      2 drivers/firmware/qcom/qcom_scm.c

I also get two fixes tag reports:

> Commit: b127f79a4933 ("wifi: ath12k: Correctly copy the hint BSSID in WMI=
 scan request")
> 	Fixes tag: Fixes: f40abb4788a2 ("ath12k: New driver for Qualcomm 11be hw=
 family")
> 	Has these problem(s):
> 		- Target SHA1 does not exist
> Commit: fde37c064641 ("wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR af=
ter tx_encap_type vdev param")
> 	Fixes tag: Fixes: 729cad3c3c9e ("wifi: ath12k: Add 4-address mode suppor=
t for eth offload")
> 	Has these problem(s):
> 		- empty lines surround the Fixes tag

Note that the first of those ... the commit exists, but not in the right
tree. It's in some ath12k-bringup-start tag in your tree, but not in
mainline, got a different sha1 there. So checking locally is confusing.

johannes
