Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA5239060F;
	Wed,  1 Jul 2026 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782918493; cv=none; b=U3PxBM0NAxC22HnwlffcHsh0D3VRjzxZ5jJSxJPighqHwx6Z8hzJIXJRbFTg1gBieLdr6v/oggRUK32bGtZGiwrtJaRCZqWPUXtSrzO+0SnUdW+hyzHpbN7T3pcvCTimAEHaP+2FqjcmvLcTTvI/2nDc9DyVvubV0UK5DY+ZgwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782918493; c=relaxed/simple;
	bh=n4frkwAq+5P0uEWR5WFhkRIJO8quwC2aYaGdGlPpXc4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aYqaFRORpGZkwgYYkGSsajw1Ee+dpveLkRR3D53rBtRaof0tdpC330Bhz+inbp2LMWRkQTKP8gzobI0sk2xUEf+hTpabdlM97xFxqbkPeDndIX2941bX1wb0yovv1J3cfRUg3/BOw558YcHxQAxaAgAG95JVYsoQ4NcGlE5p0lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=cC7q0JXt; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="cC7q0JXt"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4gr3D31GkKz9tW1;
	Wed,  1 Jul 2026 17:02:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782918179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n4frkwAq+5P0uEWR5WFhkRIJO8quwC2aYaGdGlPpXc4=;
	b=cC7q0JXtE5Ws3+O6rYpVzPKZCUV4c1RcQRnb4az+fNoLb0rQukpjG3MD/Jk0vdggz5k3Vb
	cMKzO0883aTNQK9U4ssInwYAs9PqdXe+Y3Acw8DG42eOSpUFIPi/o6wO7dnzdEHFaS+U2w
	P4YH1odc1YsKS7MBOSTPEbmi9fPsXykJMfK2L3/bY+jJWsNFy03uajHpJnMStIO6R8yRR/
	mek0QjA6vfGoxh35F/w2Wk6tYp7RIcpcPI3QikJHnFtyAO6HPTDaYhpHsAMfUudLhjBehs
	46CZSWRuBBks0cnxVFsGh1HQOUrE9JR28xpNnVk/eLbpsO4TuGS2308tYXy9Yg==
Message-ID: <c3ae1ee8f393d20843818e8a19b163179a98edf1.camel@mailbox.org>
Subject: Re: [PATCH 0/4] usb: fix UAF related to dynamic ID
From: Manuel Ebner <manuelebner@mailbox.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  "Rafael J. Wysocki"	 <rafael@kernel.org>,
 Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,  Johan Hovold
 <johan@kernel.org>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-usb@vger.kernel.org,
 driver-core@lists.linux.dev
Date: Wed, 01 Jul 2026 17:02:53 +0200
In-Reply-To: <DJMFC6N91KK9.6Y2UKU1Q0TWA@kernel.org>
References: <20260630-usb_dyn_id_uaf-v1-0-160a02be5ac2@garyguo.net>
	 <6d1b5937df1fe002c47b226640f57fda2c0ee862.camel@mailbox.org>
	 <DJMFC6N91KK9.6Y2UKU1Q0TWA@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MBO-RS-ID: 48eaa12b366e30c57f6
X-MBO-RS-META: ny4ah5oycj1oe3aq9ec38njwd9or5amg

On Tue, 2026-06-30 at 15:39 +0200, Danilo Krummrich wrote:
> Hi Manuel,
>=20
> On Tue Jun 30, 2026 at 3:26 PM CEST, Manuel Ebner wrote:
> > On Tue, 2026-06-30 at 12:38 +0100, Gary Guo wrote:
> > > [...]
> > >=20
> > > Signed-off-by: Gary Guo <gary@garyguo.net>
> >=20
> > For all four patches:
> > LGTM.
> >=20
> > I guess I'm not in a position to Acked-by or Reviewed-by.
>=20
> I don't know your background and I don't want to make any assumptions, so=
 please
> don't interpret anything in my attempt to clarify a bit.
>=20
> As documented in [1] "any interested reviewer (who has done the work and =
is a
> person with known identity) can offer a Reviewed-by tag for a patch".
>=20
> An offer from anyone who has done this work is much appreciated.
>=20
Then you can add my
Reviewed-by: Manuel Ebner <manuelebner@mailbox.org>
to all 4 patches.

 Manuel

> Acked-by is usually used by stakeholders of the code (most commonly maint=
ainers)
> to indicate acceptance, e.g. for patch routing purposes. There are more d=
etails
> in [2].
>=20
> [1]
> https://docs.kernel.org/process/submitting-patches.html#reviewer-s-statem=
ent-of-oversight
> [2]
> https://docs.kernel.org/process/submitting-patches.html#when-to-use-acked=
-by-cc-and-co-developed-by
