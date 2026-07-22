Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC0037DE89;
	Wed, 22 Jul 2026 15:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733705; cv=none; b=dUeScvIKpL2QQ14dCMx4KKgXhpcF0mAqqKmpEaRYs/Ubcu1cPDKszLzsu1aWOpuVr0ISDoXpxZGlSEv25LaVwDnbwkelz2aTXQqLebPNrhGypWAjIqLyXfqLXIykW98qLnHNEB2zOoXxLuymTyucGLWyG6srq3c1Iumil4ZSByQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733705; c=relaxed/simple;
	bh=hNGyoYNW7Q0ruScJq6NbWpvlJJKAolpo8RXLlzKGTR0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kWLhuNp6e7ZnOlSyuMWuadHSrQGQv8Q5J+c31/CPqzbUfimqUUG2cH45X5mFsgfdzPKHb2Kuz/yDaT2M7hUBjAIM440ymlnKPWZc+iDP2Vl+l1mFQeRI6M10yEBXfWfMxhq/4jjqlAtYP7kdsEleyVF2M3B1hjWGudBarf6hJyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PfXWreGa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PfXWreGa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hNGyoYNW7Q0ruScJq6NbWpvlJJKAolpo8RXLlzKGTR0=;
	t=1784733702; x=1785943302; b=PfXWreGaGXiLrmlFJDt+cGKWWaQfw4Se/uOcsVXZZCWQuDp
	laGXbRZmJ6SJkzEc5G/7knANL4oXvcZskq6yeL8DBf3BjAYhvOWee2mgPPUcfC31I9qbtVUlY08R9
	YO+9PYHgLH2cnFs3mSUjI4/GSS0mu3n/SS/aQalAiozJQuFvtq1NMJBgL2T+IqSgczK1YczvcgRwF
	ZYpsq9OnWovAKLz1G043HKKmkg5n+Zqt/+fwsPQ1m4/btGTOK+G3sLmh0N10CCRRo6e7WspgHnzA9
	oVc1GDVDzjwBncP5fjk6hGCSz65CqgARZHNyUW8Zb82CGGLVM50FpojCW/cnPGBw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmYlN-00000004qLv-385Q;
	Wed, 22 Jul 2026 17:21:38 +0200
Message-ID: <a9b045f7bcd5aaa545a047d2893ce3a04932172a.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Date: Wed, 22 Jul 2026 17:21:37 +0200
In-Reply-To: <CADhLXY4bpoaJAnh6KVe1fU9J_wCihgM3y-LQoXz0Snrmknc6eQ@mail.gmail.com> (sfid-20260710_173144_048168_17158A0B)
References: <20260710024637.16729-1-kartikey406@gmail.com>
	 <6be574903752d95ae7125461c38cc30b8a641d24.camel@sipsolutions.net>
	 <CADhLXY4bpoaJAnh6KVe1fU9J_wCihgM3y-LQoXz0Snrmknc6eQ@mail.gmail.com>
	 (sfid-20260710_173144_048168_17158A0B)
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

Hi,

Sorry for the delay.

On Fri, 2026-07-10 at 21:01 +0530, Deepanshu Kartikey wrote:
>=20
> validate_ie_attr() takes a struct nlattr * but the wext path
> works with a raw char * buffer, so it cannot be called directly.

Oops, right.

> I have reused the same approach using for_each_element() and
> for_each_element_completed() instead. Is this acceptable?

Sounds good!

johannes
