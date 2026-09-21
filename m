Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5A03C10B3
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 23:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034835; cv=none; b=M0BjJjgWYTh4itc84OWrS6Xp7tiIt1zsmENlz3Aay4n8N0YQeqXS5PEoxjsqZ2Sx+LuW9TMjjjEfaErql6+mXVoEWykUBSaGqRwxWKjE1LvU0YNz3qWKoGyr5wged6mXbaH4H7r0Ry9ITS0mzcMGsNKt2Qq59ATV5AZMCAecqJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034835; c=relaxed/simple;
	bh=V8emTKoM/0GiIrwKe1z+gDxd9KQpEZV0x/a+ZoamoDQ=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=KqtecBalqDV1QrxEmLt19TfLhPXThQaAhkToJVR6VRRbiCVVtZEtJKeakhDjCxo/CMpDrUpgDvSG2womgta+USXwIfUEJoM40V5/cyFqevgIDhquyqfqusN3hTJYW7egTrKFB0XKphgjkKHjcyRd/QqH3QqjokEYaAyWi2HU9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KMWN7/2g; arc=none smtp.client-ip=91.218.175.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KMWN7/2g"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=V8emTKoM/0GiIrwKe1z+gDxd9KQpEZV0x/a+ZoamoDQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790034829; v=1; x=1790639629;
 b=KMWN7/2gtMHFF2INcbq1pcCDvOKvikdVbZB17XvntpbbC5HCr80Vlvl90c5eLHlQwOXJDmFb
 a5tplz6P18WVQuEqUMA5f1tGxi5uRfqJI27kbdlgGh0SptspNpEhuHvTKQ1f9soxU+souaFIxyq
 CCVgjsZRzNYQhq+bQ9af9f40=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5bb35089b14b2b69;
	Mon, 21 Sep 2026 23:53:49 +0000
X-Mizu-Trace-ID: 5bb35089b14b2b69
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 21 Sep 2026 23:53:48 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: "Jeff Johnson" <jeff.johnson@oss.qualcomm.com>, "Johannes Berg"
 <johannes@sipsolutions.net>, "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>

September 22, 2026 at 1:35 AM, "Jeff Johnson" <jeff.johnson@oss.qualcomm.=
com> wrote:


>=20
>=20On 9/21/2026 11:14 AM, Johannes Berg wrote:
>=20
>=20>=20
>=20> On Mon, 2026-09-21 at 16:49 +0000, Luka Gejak wrote:
> >=20
>=20> >=20
>=20> > It is supposed to work in the same way it works for other driver
> > >  maintainers. I would review patches and provide my acked by or
> > >  reviewed by them and Ping-Ke would apply them to his rtw-next bran=
ch.
> > >=20
>=20>=20=20
>=20>  I don't think we have a lot of folks below the driver maintainers =
who s
> >  end me pull requests (except Toke maybe?) - but as long as I don't n=
eed
> >  to deal with it I'm happy, you can figure it out between yourselves =
:)
> >=20
>=20For ath.git there are sub-maintainers for ath5k (Multiple), ath9k (To=
ke),
> carl9170 (Christian), and wcn36xx (Loic).
>=20
>=20Toke has a linux-wireless patchwork account so the ath9k patches are =
initially
> assigned to him in patchwork, and he Acks on the list and assigns the
> patchwork records to me when he approves patches.
>=20
>=20For the others the maintainers just Ack on the list, and I take them =
from there.
>=20
>=20So the question is do how do you want to handle this in patchwork?
>=20
>=20/jeff
>

What do you think makes more sense here: patchwork delegate
access like Toke has for ath9k, or on list ack based? I'd lean
towards delegate access if it's not a big ask on your end, but
happy to go with whatever works best operationally for you.

Best regards,
Luka Gejak
