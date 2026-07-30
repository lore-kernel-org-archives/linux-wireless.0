Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123384657D6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437682; cv=none; b=N1sCoZgWOEJJ0qxlvpYJnXsaieKDKuErBCiSWdfkw7iXH6wngTDGtx0IzNjHp4fgAow2SLtijnL3WEtrY9vJn7s0XtiXUo9exnwXVBFYXZo9Yvz2DqsNIxGbG+eHZGe3MA4oldQU9sj+fkq3dbwwzc2IENCjn+iFQz38MpGLucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437682; c=relaxed/simple;
	bh=U404prs2zZh62mLKqdkVGBoyOy8V8DBNsgyTT41vWzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dd5tJIg0XGNOZ279vouGBbxuRTvuAwTE00r7l9e8f5hSlyzwPJWqEzrpQayZpbqe7HzfNMaFKQ8FJesulOBl5R7HqEGNWWbCB58COBUmLtMwwpMPxShIErE5cFARsrVszbbpz86Scsqc9jcS2HdW9yPyWfaUvdKfWM/DuQ6F/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qcDo3NB1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qcDo3NB1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=U404prs2zZh62mLKqdkVGBoyOy8V8DBNsgyTT41vWzw=;
	t=1785437680; x=1786647280; b=qcDo3NB1jUAksBlYSlPbOCJRQs1c+FSJzqzzjKv+2CIqthA
	FhG+GBSI/i/RwSVOi0qxbjR1vpfg+b1DZIUCVrjwoTFqce6zDAirUfYkklHvdfrNU1PmBu0a2obSk
	4DOYTo7M24mp/lajmAFv6se0I9atfc2uv+mK8ij4fcXqC9DXJnAni1LM9Tkt/piw733u/JPJbtdWJ
	Tup2D9Yp4Aea3tW7ZoJTJn9b4TfogtRRB8wx3KLZpCKzNvU7QpldEoS23UWQ+v7JjIbmSpLz+rMlC
	juxs0cUy8O2Ou7KWu17MQORV7y3iDRW0JxMDleb5vKQbbjHyqzny7i4fyu1nY62A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wpVtr-00000009cmb-40Q4;
	Thu, 30 Jul 2026 20:54:36 +0200
Message-ID: <cfcb2f3748aa51b7001ee41c6dd4d578b0cdca28.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until
 association
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrea Covelli <andcov23@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kavita Kavita
	 <kavita.kavita@oss.qualcomm.com>, Sai Pratyusha Magam
	 <sai.magam@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 20:54:35 +0200
In-Reply-To: <CAOEJtZHV8HLxe70B7Rugkh2o34Sy9cr26BXji5LWB7b74JTL1A@mail.gmail.com> (sfid-20260730_190055_809485_7E91D319)
References: <20260730161531.3535100-1-andcov23@gmail.com>
	 <1dceded216618b1d7bb7b79846f15712161f2cc8.camel@sipsolutions.net>
	 <CAOEJtZHV8HLxe70B7Rugkh2o34Sy9cr26BXji5LWB7b74JTL1A@mail.gmail.com>
	 (sfid-20260730_190055_809485_7E91D319)
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

Hi Andrea,

> Thanks for the review. Understood, I=E2=80=99ll hold the standalone patch=
 and wait
> for the SMD-transition series. I=E2=80=99ll review how it handles the def=
erred-key
> and SW_CRYPTO_CONTROL paths and test it against the AP-side FT case on mt=
76.

I think I'd mostly like to understand how it interacts. SMD Transition
won't actually handle this particular path, but client-side has a
similar issue where the key is available before the STA entry for the AP
is fully available.

Now looking at the code I also wonder devices could just deal with the
key installed before the station is marked associated?

johannes
