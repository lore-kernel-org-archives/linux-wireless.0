Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742AD37BE70
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 08:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153090; cv=none; b=JRNPeh8ZAzztbfQhuv1Q1SQwlAr0fDg5i18gCdeT1RCKT5O4RafDhodZZdkxQ+f2HcbtQ87kHr47zwUUQ/tg1EQlTEnxTMUbUthhpWfe5k8Xr7COohgwAO+ytRb9s1BpWh9nfnyNjlJEjimZ+XFqrhQWcUqrXl16vmh6RQHVwwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153090; c=relaxed/simple;
	bh=5HtiKG4HZiV8G0W9hq66q9T7mdEbG2of2ijEqOGb7g4=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=jO3iOXCazmQiMQQg5TTOF5LO6+yv9WyhAk4dt6LCjUrLZVQWntNnxVo0O4fimyQgTgY2cd9Pjbp+VsxqAl1j6spOs5vteLJNzYzmUFTo4hRBb2Cv4rKaZ35+iCEc2rN/wjR5Q0YpIuP7+6ZljGCEzMuiOMLF9uIV6l5fJx2nWfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sF1FI39c; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sF1FI39c"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5HtiKG4HZiV8G0W9hq66q9T7mdEbG2of2ijEqOGb7g4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790153087; v=1; x=1790757887;
 b=sF1FI39cFDmh6qmEcQWDV0SFQkfdAxfpNw81sU/B8WVCE1sZeZMPieJvSxXKUqhHuk072h9+
 RbF59Nu1SC0ye9MXrnD5k9adjVz90D8bpThYijzWNBXxUb0Pm5nq/qNFYmuquCo4yljQBGRNEjK
 muG4tCo7IahOm0ewELDRT5mk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 656c7f665a49ef96;
	Wed, 23 Sep 2026 08:44:47 +0000
X-Mizu-Trace-ID: 656c7f665a49ef96
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 08:44:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <09c6a890906e4d4e93d8dcde41e2b808b7d9582c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 2/6] wifi: rtw88: 8723b: add the RTL8723B BB, RF and
 AGC tables
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael  
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <3ce6a66b25274fb0b58f259529359bfe@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-3-luka.gejak@linux.dev>
 <0a6ea4337e004faa97595b1b62d2cad9@realtek.com>
 <6c14fabffc6984a5e7cd91c9b7fe6e4caceeaf70@linux.dev>
 <3ce6a66b25274fb0b58f259529359bfe@realtek.com>

September 23, 2026 at 11:34, "Ping-Ke Shih" <pkshih@realtek.com mailto:pk=
shih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E >=
 wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> Luka Gejak <luka.gejak@linux.dev> wrote:
> >  > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> >  > +/*
> >  > + * Copyright(c) 2007-2017 Realtek Corporation
> >  > + * Copyright(c) Michael Straube <straube.linux@gmail.com>
> >  > + * Copyright(c) 2024-2026 Luka Gejak <luka.gejak@linux.dev>
> >  >
> >  I'm not sure if we should claim copyright year back to 2007?
> >=20=20
>=20>  What would you prefer, just tell me and I will change it?
> >=20
>=20You can reference what Bitterblue did [1]. I don't have much study
> about the copyright.=20
>=20
> [1] 1a7545784642 ("wifi: rtw88: Add rtw8814a.{c,h}")
>

He uses 2025, so should I copy his line for Realtek copyright header?

Also I will address all comments and send v4 tonight/tomorrow morning.

Best regards,
Luka Gejak
