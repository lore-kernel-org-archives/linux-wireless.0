Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4403F36BCDD
	for <linux-wireless@vger.kernel.org>; Thu,  4 Jun 2026 10:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780567723; cv=none; b=JEjJc288l8gck7kloLrRz4bXlZcBQ52jgW8CpTL3a18sv8LDWgdYwZBpMt5b3nwifa9R/YwZX/RVq01DGDMRG6JIOXlSIzBa4GHCwfT3FZjagRYMrTzVnEliWkoT39RXj4eJCqL356fdFAIcSUT82MIcA5kICDVv5OS7pVdf20w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780567723; c=relaxed/simple;
	bh=iSsxXisOrJFOU6MXZnNPNCQbvyIe2nFYOvnCDWjxDgw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJStmf5BJqJyO4LhZ1kl3tHWj7F4DPu11k6czm2usQIw004lf67jdR+YbuPvlUmMcWypKHX1sTJ8pYITufLS8qano8nRiux1vF3I3SFV8tlRu43IYnCWCWomtO7125Na7JJ393Bg2v8FtpTiLnGDZPwvdCzweRJDe3ChXHY3XTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=eQjR5xcy; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="eQjR5xcy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Cc:From:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID;
	bh=XxAOGp8CsUt5BS7jVjtSRtEo8BbbFuevAKL87jkLvmw=; b=eQjR5xcyf6wY6hEmCM2VuS/w88
	LaWnXXPs1hpSWT4rkByYpq1VQrke1OQTC0mztWPdDq09sDiNGNNe9wSZxFCF6uLjQDgHNarFJlnin
	OtJRfh+/N4drUAnnB9QbLGnndWzlfp2xwiN3FotGZXWKeDLrXgQtB/fKwuZc2NXEuo1DEmEC8N4Sl
	ApktnOxaYhm4T3jlqZ9g0L3ZzmXxbdayailGorg3frPiQQhvnKTXIskN+rIAyYoDsj0RylbTAgnYW
	uec3YjW4clhs1FbYtV2NS4c95K0ZtGwRJcIROwC8Il/WMdcdP8SwZUE16S9sFXCiRmrNMPHx5f/Mr
	04g8cmcw==;
Date: Thu, 4 Jun 2026 12:08:34 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Peter =?UTF-8?B?w4VzdHJhbmQ=?= <astrand@lysator.liu.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: wlcore: Add support for IGTK key
Message-ID: <20260604120834.508f606f@kemnade.info>
In-Reply-To: <a2040dcc-af47-1de0-b731-defffe3ce4cd@lysator.liu.se>
References: <0d3df7ab-6c41-c3cc-83cc-5ba55fe4e4bd@lysator.liu.se>
	<20260508102403.4e2fb1bc@kemnade.info>
	<a2040dcc-af47-1de0-b731-defffe3ce4cd@lysator.liu.se>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 8 May 2026 15:55:07 +0200 (CEST)
Peter =C3=85strand <astrand@lysator.liu.se> wrote:

> On Fri, 8 May 2026, Andreas Kemnade wrote:
>=20
> > Hi,
> >=20
> > On Fri, 16 Jan 2026 18:58:58 +0100 (CET)
> > Peter =C3=85strand <astrand@lysator.liu.se> wrote:
> >  =20
> > > This change re-applies commit 2b7aadd3b9e1 ("wlcore: Adding suppoprt =
for IGTK key in
> > > wlcore driver") (sic), but only enables WLAN_CIPHER_SUITE_AES_CMAC wi=
th modern
> > > firmware. This patch is required to support WPA3 connections.
> > >  =20
> >=20
> > I have seen this after this patch:
> > [  484.113311] wlcore: WARNING could not set keys
> > [  484.117828] wlcore: ERROR Could not add or replace key
> > [  484.123016] wlan0: failed to set key (5, ff:ff:ff:ff:ff:ff) to hardw=
are (-5)
> > [  484.123046] wlcore: Hardware recovery in progress. FW ver: Rev 7.3.1=
0.0.142
> > [  484.139923] wlcore: pc: 0x0, hint_sts: 0x00000048 count: 1
> > [  484.145721] wlcore: down
> > [  484.148986] ieee80211 phy0: Hardware restart was requested
> > [  484.610473] wlcore: firmware booted (Rev 7.3.10.0.142)
> > [  484.633758] wlcore: Association completed.
> > [  484.690490] wlcore: ERROR command execute failure 14
> > [  484.690490] ------------[ cut here ]------------
> > [  484.700195] WARNING: drivers/net/wireless/ti/wlcore/main.c:872 at wl=
12xx_queue_recovery_work+0x64/0x74 [wlcore], CPU#0: kworker/0:0/892
> >=20
> > This repeats endlessly.
> > As soon as I set pmf to 1 in wpa_supplciant, once per second. Reverting=
 this patch helps. Seen this
> > on the Epson Moverio BT-200. =20
>=20
> Thanks for this feedback. From the firmware version, I assume that this i=
s=20
> not wl18xx but probably wl12xx? Unfortunately I have no experience with=20
> that module. So, while my patch is an improvement over the original patch=
=20
> because it checks firmware version, it did not consider non-wl18xx=20
> modules.=20
>=20
> I guess we need to throw in something like:
>=20
> strcmp(pdev_data->family->name, "wl18xx")
>=20
> ...in the if statement.=20
>=20
btw: if the firmware is started for a second time, it will also decrement a=
gain.
So after some reboots we end up without any cipher.
And afaik the firmware ups at any ifup.

Regards,
Andreas
