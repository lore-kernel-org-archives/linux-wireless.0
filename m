Received: from mail-10698.protonmail.ch (mail-10698.protonmail.ch [79.135.106.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0404CA787
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602980; cv=none; b=Yvrq7f5AmyLJKFJ5BfUOGsDQVIRfwXLpLBl7YGIcmaLrnorxJUuL+s/IaOzTZiH06+J3UUyBsmYzQaHe+sBBmWgB9GzS3uT+yVtUbN43pZ8wP6mTgUVyw4W7t62Zi+f87zbecdOGNtz5oH02c1mACO6p4F+XEWzfKOg/lYccwlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602980; c=relaxed/simple;
	bh=b5b4nT0lasVhh8LZ17W/xUA0ZetiKOmUcfV0l+PgSaU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hp05kFewSUli7T0PEWgoRrDgwyIHaBpf8uSmKFodyIazrFoTvEoFLgT1lDfrhujB/KBY/wjf2g6eRPEyjWpxGssbjx28ekYgAV8yQJuXKl4IbSG5aAke56xDOW5jRd2IzCV2YlmrjhXSNmCeikWhwkTOUcHV62a0Np9RChpULvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=bukzr/ZU; arc=none smtp.client-ip=79.135.106.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="bukzr/ZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790602967; x=1790862167;
	bh=b5b4nT0lasVhh8LZ17W/xUA0ZetiKOmUcfV0l+PgSaU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bukzr/ZUPxhIC+nRyefTTXyl9Bu3+rSgNHdf7EGOez+iuBrbah14gvwyfWefC/Q9D
	 ywFmoY3W9srhGzcazQ/4Dw7ADL6Xe1lN0MaLb3tC9U+Fd9t/TWKjWPTjkMmj/ZegMg
	 9M2Z57ag24be+CIuOqZuuDHz8M8gzYrqCN8SqAOwijTM7isEablr08+7K6bXZAuOkP
	 H3gu0IJ5WeuAuF0zjGYxyJc7RgyDAAhcSZMYNNAkeu4k6S/RT2QEZhUo0WpbW1tr24
	 3SAETZCzb+ruZF/IGY+K2upg83g0tB2sOUk5cOp+0SZHthvC1kkc4XfzT7tCHZx/ZO
	 A/h0rJU8eplww==
Date: Mon, 28 Sep 2026 13:42:42 +0000
To: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
In-Reply-To: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: f1a41cc7eebde86c161a6d436ac62854c9386129
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,
I've been working on adding 802.11ac AC-PHY support to b43 for the BCM4360 =
(MacBookAir6,1), since b43's existing phy_ac.c has only ever been a skeleto=
n (allocate/free plumbing, no real init or tuning) and Broadcom's own wl dr=
iver is the only thing that's ever actually worked on this chip.

I want to be upfront about how I got there, since it directly affects what =
(if anything) is submittable: I reverse-engineered wl.ko =E2=80=94 decompil=
ing it and capturing its live register/SHM writes on real hardware =
=E2=80=94 and used that to write a working driver. That driver is not clean=
-room and I'm not proposing to submit it as-is; having the proprietary driv=
er's decompiled logic in view while writing it is a real provenance problem=
, not just a style one.

What I am hoping is more useful: I've since written up a functional specifi=
cation =E2=80=94 chip bring-up, channel tuning, TX/RX header formats, and t=
he specific pitfalls that cost real debugging time (a frame-lifetime regist=
er that silently stalls connections if left unset, an RX status bit that lo=
oks like "decrypt error" but fires on unencrypted frames too) =E2=80=94 des=
cribing the hardware's required behavior in my own words, with the intent t=
hat someone who's never seen wl.ko or my driver could implement a working d=
river from just that document and the 802.11 spec. It's honest about what i=
t doesn't include (the actual calibration/tuning table numbers, firmware, b=
43's existing generic infrastructure) and upfront that I'm not qualified to=
 judge its legal soundness alone.

The driver itself works: verified WPA2 association, DHCP, and sustained sta=
ble traffic on 2.4 GHz, on both the kernel this project started on and, as =
of today, kernel 7.2.7 with no code changes needed. 5 GHz, hardware crypto,=
 and full RF calibration are out of scope so far.
Given b43 is listed Orphan, I don't have a specific person to ask, so: has =
this kind of provenance situation =E2=80=94 a reverse-engineered spec inten=
ded to enable an independent clean-room implementation =E2=80=94 come up be=
fore for a wireless driver here? Is that a viable path at all, and if so, w=
hat would you want to see before it's worth anyone's time to attempt the cl=
ean-room side?

Thanks for reading this far.

Andreas
