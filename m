Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F383033E7;
	Wed, 29 Jul 2026 06:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306901; cv=none; b=ulZYE5t5qpVp2OpGi9hz+MuWmZw6UCBBtzM9K/AdUnkUHwdAmZsnd2LIbPLA5diw05ZY4jVRCgrJu5T0jTByBGBpi7KOeuc7HvWGoAQsVEZ6RT2QBWbs5oQIBRtjImQkcojVNe/gAf1yh1/N3MlBhMGkulHM9xk5OdiouY7n2XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306901; c=relaxed/simple;
	bh=eREqwVHEzJykZct3x1q3h1cxKfo2CVyDbx+GgSJOeXk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=akR431jKwCQj7Cj9zBHV/hEYIs+CHLmbTkAKwaelOQt6oGtaBxHRHs1nDtzCgRsDn/ORKNpKTHIGNsASrd7EiAJCZkQGNu1hhw4M4KG+EkagNpgAc6htF8hZMHlPxWACOsfdvEMwH5i4bjlwxbG1tVGh+CtnRQL/XwM7pDFco18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ZzCtke++; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ZzCtke++"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=eREqwVHEzJykZct3x1q3h1cxKfo2CVyDbx+GgSJOeXk=;
	t=1785306899; x=1786516499; b=ZzCtke++bXds9f8wR7ELbLfDrdC3SsH1dBT/cHXMAjJapLq
	A96dbmV5p9o+aRQg93QaxfyLDQfaAuxtHyKTy3CBCbqBLfgnp99dM2TIqq7SRGuMIZVDenQ0u2wbU
	Liukjh7FLDtCk+0zEBXMeVQW9JXa+lY1l+v5l7/gadrnQQFW71hDoFfKYUncnHad/Vu0hI9v2sTPk
	BhWKRStpi4vPzfJzdjFDn2+newkfIoxUqNPt9QR/RG9xvKip4IO2z1dTZn26ImQRtzoWnzRrpgF/0
	lvWsf0qbNnXpjtcUjXfknzxSQwVDLzJZan9vOZt5CrYZuDa+uHELJloteQL8W7pQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1woxsV-0000000GuAI-0eME;
	Wed, 29 Jul 2026 08:34:55 +0200
Message-ID: <5b4bd5885d0ea2d2f63e504180694dc37f06a3d6.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: cfg80211: validate IEs in
 cfg80211_wext_siwgenie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Deepanshu Kartikey <kartikey406@gmail.com>, Jeff Johnson
	 <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Date: Wed, 29 Jul 2026 08:34:53 +0200
In-Reply-To: <CADhLXY4m+KAkJz8-_OLtuvg2fsKx1=BehxBpe0kkAeKQF18QxQ@mail.gmail.com> (sfid-20260729_034144_234623_328642F8)
References: <20260725142028.32560-1-kartikey406@gmail.com>
	 <df56bee8-2347-4909-8859-384a0f87de11@oss.qualcomm.com>
	 <CADhLXY4m+KAkJz8-_OLtuvg2fsKx1=BehxBpe0kkAeKQF18QxQ@mail.gmail.com>
	 (sfid-20260729_034144_234623_328642F8)
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

On Wed, 2026-07-29 at 07:11 +0530, Deepanshu Kartikey wrote:
>=20
> Thanks for the suggestion. I will send patch v3.

I applied (a modified version of) v2 yesterday, so I'm not going to take
v3 - and anyway the bigger cleanup isn't great for wireless as a fix
right now. We can revisit this in wireless-next.

johannes
