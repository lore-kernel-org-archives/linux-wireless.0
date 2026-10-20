Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792471427;
	b=4E13rR/dl51mUyNaRvM50YFgUXPTx6dgyUP5QJQaPwHU/HIbS5Dc9z1ukyOcqArisylw
	 hcDFvI9X+LzIpRvojXSL7DPKLGq0ZuWx3RycPCyEp6bL6y5g40kAPJePtdzf2BZWhFA98
	 XOixWRSIvRHtY49INAIee3Hyj3eFH4N4f/OrRAMObUf1886Q64qFMj9FfgtUlX8A4bwqS
	 pbzkpmF4M6xcRa6HQAWld+NIcuPeDCPOgivS+CnggwonBnmc591XFTscRz6YtjmZUZU8t
	 L5GGV236AIs51yqhq+4gnR8ltGDbB72yCcZ81rL9lkpVSwHPH+yy88t0zxbLSTh0cvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792471427;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=TftrrPNtsyBwyu6P4BuDulXkrmUzNiS7FTTDkxdm9u4=;
	b=PR7RkC9inOzAYz67QGUulll7g2XsvFeoxRuyIBkLJJZszxqhJyoCMnqkE2olEE7ADAoi
	 66PTQpP+tqA50/Aei9fM1H0EBS14by7PbLpVNjPPNhjCCaiX5DAnZ+EO5UNArAMHyEWox
	 rZZhXmnMrA14iuOPpsYgy9KoDzASCWvmSpWiVfixzIlb890Tyx95HzR1hda0Rzha78eZl
	 N1Brm6Ju3N5d4rSMc6kNbCM1zpOH4oYX63jSYVqs8W39i/cgDiFZmKGHlTZDHXzealGBb
	 kn3EguvXHqNIPy+sARAGPhrhZUR+utsNrxNZahGvGldV87GSxwLryJ7vQGNoRKzo1NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CC8iYWGT;
	arc=none smtp.remote-ip=95.215.58.35
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4B606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 04:43:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B4B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CC8iYWGT
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dC7VvThPiocukbh7F9YYC7tvYdPI1VO2U/KFB7y+I0c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792471422; v=1; x=1793076222;
 b=CC8iYWGTEZHJuaXzGSPaexyEz3uudLE53kxfFS+2LWFS8cY8mDDBnjJSnPKyRND3Kvjny9cV
 HhUOconMknDSG+EmPp2p9y0ZpRKJMEYVy1wJRaKdR2MSwGo3pTX1OuqzQPwdfXw0jdtqm3Ublj3
 rWcPoMwzmVFysyv+KRwm44ag=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 398ce5b28278dd5a;
	Tue, 20 Oct 2026 04:43:42 +0000
X-Mizu-Trace-ID: 398ce5b28278dd5a
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 20 Oct 2026 04:43:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <334c6e785a5d242c6f168d57d042d63b777a242a@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Hungyu Lin"
 <dennylin0707@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 reza1234khan1234@gmail.com
In-Reply-To: <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
References: <20261019165103.5990-1-dennylin0707@gmail.com>
 <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>

Hi Ping-Ke,

October 20, 2026 at 4:07 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:

>=20
>=20Hungyu Lin <dennylin0707@gmail.com> wrote:
>=20
>=20>=20
>=20> rtw_ops_set_key() looks for a free CAM entry before checking the
> >  command. When all pairwise entries are in use, DISABLE_KEY returns
> >  -ENOSPC without clearing the existing entry.
> >=20
>=20Is this the actual case you met?
>=20

From=20my investigation it seems reachable.

As far as I undersrand, it needs all 28 pairwise entries (4-31) in
use at once, so AP mode with 28 secured stations (31 mac_ids are
left after the AP vif), or IBSS/TDLS with as many peers. Not
reachable as a plain client. Once it is hit its pairwise
DISABLE_KEY fails, mac80211 frees the key anyway after logging
"failed to remove key", the cam_map bit is never cleared, and the
table stays full until the driver is reloaded.

I think it can be tested with two clients by temporarily setting
sec.total_cam_num =3D 6.

> >=20
>=20> Move the allocation and bounds check into SET_KEY. DISABLE_KEY uses
> >  the existing key->hw_key_idx.
> >=20=20
>=20>  Fixes: 10d58823cb44 ("wifi: rtw88: fix out-of-bounds CAM write whe=
n key table is full")
> >=20
>=20Should it be ?
>=20
>=20Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
>=20

I=20think 10d58823cb44 is the right tag. In e3037485c68e the check was

      if (hw_key_idx > sec->total_cam_num) {

and rtw_sec_get_free_cam() returns at most RTW_MAX_SEC_CAM_NUM (32),
which equals total_cam_num, so the check never fired and DISABLE_KEY
always reached rtw_sec_clear_cam(). The bug there was the
out-of-bounds SET_KEY, which 10d58823cb44 fixed. DISABLE_KEY only
started failing once the check became ">=3D". This patch also does not
apply without 10d58823cb44, since its context has the ">=3D". Since
10d58823cb44 is tagged for stable, I think this one should carry
Cc: stable@vger.kernel.org too.

Best regards,
Luka Gejak
