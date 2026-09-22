Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9141CAAC
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 01:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039277; cv=none; b=VxEbssE0wwbGtQVvIPmq6pHRD3md24LeCanfJHrHRlfEMrfrFnAs+oaQdx7jIC71rQ0WjVo+wKvX0UK3duByFzmqLyM0HzF083yK41DaIXnnGe4F5GIX078s1tunhrkMv6w48uqa4QXcJ6VyQm91M3hHmqdYL5dkP4X3IctUl5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039277; c=relaxed/simple;
	bh=l7KQLj3893ZGS3xxgpLpKxm8xm632+Oija+8hydNf4o=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=DnoL8+jy/Ir0GAQ3pEDRj5jZM8nzB9b5/mAHuwktbUEn+nsNmeFhfO5iM/R2eziG0N09lxE7Lxu0R9m8IxD3SOeFogpkp3+HOUUitI65PU+g3ww1hqeql9v0FUOYPhL+fL7tcVzovb7ljK+s63jJOHgRe2b2jEh9iI0dPS8y7CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WLm9/wqQ; arc=none smtp.client-ip=91.218.175.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WLm9/wqQ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=l7KQLj3893ZGS3xxgpLpKxm8xm632+Oija+8hydNf4o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790039273; v=1; x=1790644073;
 b=WLm9/wqQ8+yjtELpTaG5r0NIQF2CZsYdWNrhvJqD0/iAXKFoZB56CVxxwktcrECRWLzejHYz
 5RHjXtbmomCYxZbgqoU31bstlqbgymztVlVTXLtcy41m5rTfgvv1PLZ6aC87q40bSMgpZj0a0WU
 R3CRSPrn3AZxG+1JcVVDihCg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c3addaacdd50d9a0;
	Tue, 22 Sep 2026 01:07:53 +0000
X-Mizu-Trace-ID: c3addaacdd50d9a0
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 22 Sep 2026 01:07:53 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <a4339de07daae1d3ad274067006ed6dfc021434d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Jeff Johnson"
 <jeff.johnson@oss.qualcomm.com>, "Johannes Berg"
 <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael  
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <2694defa2e284ee894005c59197325a0@realtek.com>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
 <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
 <c208152fc5cb45e19ae7d4660394dbf2bc5e0271.camel@sipsolutions.net>
 <bcd5a280-8184-4457-ae52-47a9e0fe763c@oss.qualcomm.com>
 <ffe834a8a469d5febb7e73de371d662f9a0d115f@linux.dev>
 <fe3c6884a96b476799f415a06314f1ba@realtek.com>
 <c419df59280e52baa5e25f665eff599592f3cdff@linux.dev>
 <2694defa2e284ee894005c59197325a0@realtek.com>

September 22, 2026 at 03:50, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> September 22, 2026 at 03:28, "Ping-Ke Shih" <pkshih@realtek.com> wr=
ote:
> >=20=20
>=20>=20=20
>=20>=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20
>=20>  >
> >  > September 22, 2026 at 1:35 AM, "Jeff Johnson" <jeff.johnson@oss.qu=
alcomm.com> wrote:
> >  >
> >  >
> >  >
> >  > On 9/21/2026 11:14 AM, Johannes Berg wrote:
> >  >
> >  > >
> >  > > On Mon, 2026-09-21 at 16:49 +0000, Luka Gejak wrote:
> >  > >
> >  > > >
> >  > > > It is supposed to work in the same way it works for other driv=
er
> >  > > > maintainers. I would review patches and provide my acked by or
> >  > > > reviewed by them and Ping-Ke would apply them to his rtw-next =
branch.
> >  > > >
> >  > >
> >  > > I don't think we have a lot of folks below the driver maintainer=
s who s
> >  > > end me pull requests (except Toke maybe?) - but as long as I don=
't need
> >  > > to deal with it I'm happy, you can figure it out between yoursel=
ves :)
> >  > >
> >  > For ath.git there are sub-maintainers for ath5k (Multiple), ath9k =
(Toke),
> >  > carl9170 (Christian), and wcn36xx (Loic).
> >  >
> >  > Toke has a linux-wireless patchwork account so the ath9k patches a=
re initially
> >  > assigned to him in patchwork, and he Acks on the list and assigns =
the
> >  > patchwork records to me when he approves patches.
> >  >
> >  > For the others the maintainers just Ack on the list, and I take th=
em from there.
> >  >
> >  > So the question is do how do you want to handle this in patchwork?
> >  >
> >  > /jeff
> >  >
> >  >
> >  > What do you think makes more sense here: patchwork delegate
> >  > access like Toke has for ath9k, or on list ack based? I'd lean
> >  > towards delegate access if it's not a big ask on your end, but
> >  > happy to go with whatever works best operationally for you.
> >  >
> >  I'm happy that people join rtw88 reviewers.
> >=20
>=20>  Personally I prefer people give Reviewed-by tag to the patches, an=
d
> >  I can myself take the patches by patchwork state and send pull-reque=
st
> >  to Johannes.
> >=20
>=20>  With additional flows of patchwork and pull-request, it looks much
> >  hard to maintain, since I don't think there will be a lot of patches=
 of
> >  drivers/net/wireless/realtek/rtw88/rtw8723b*.{c,h}
> >=20
>=20>  By the way, if you are interested in rtw88, maybe add a "R:"
> >  entry to be a reviewer of rtw88?
> >=20
>=20>  Ping-Ke
> >=20
>=20>=20=20
>=20>  Hi Ping-Ke,
> >=20=20
>=20>  I agree that approach is simpler and I am perfectly fine with
> >  it, if it works better for you. And about being rtw88 reviewer: I
> >  would happily take that role, so I will send a separate patch
> >  outside this series.
> >=20
>=20I think you can change the content of this patch to add yourself to
> rtw88 reviewer. No need other patch.=20

I=20understand. I will modify this patch to also add myself as R
for rtw88 and I will send updated version in v4 of this series.

>=20
>=20In fact, even you aren't in list of MAINTAINERS, you can still review
> patches. Just subscribe linux-wireless mailing list (I think you did),
> and reply patches you have reviewed.=20

I=20would prefer to be listed as a reviewer because as such I am
CC'd on each patch for rtw88. I'm not subscribed to wireless
mailing list as linux.dev service provided by linux foundation
states that we shouldn't subscribe to high volume lists.

Best regards,
Luka Gejak

>=20
>=20Ping-Ke
>
