Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375AC4BD35C
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790348324; cv=none; b=U04d5gyiXvY/lA79zYCYiynUSU4WCM0fHwHPvjyMbFXCVkxJKQ1vJj8P+gNaonPJKoCByUnEEfa0TkErw9eMJonXQErpHLh1TFKLL3ZNcTdD1aDAnbM7L5fjqPP8p+U2fMA7ViFsOcj7l9p42pLqmuZKHExxJAg6IwFYQTsxOPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790348324; c=relaxed/simple;
	bh=ISO2r3LSrVjP+2GtbGKn7zWHlfSH2y+uLxJccrg4co8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcOZk2qkhHZUa5k+/uAINk2A/su5erL+kGp9ePhXsIF1l9dnheR4UHUCaejKoQXDOYlKZpHj0m2WXOYpwF4CpuaVPlT97UxxbWfXACIHQ3Wg9C5HiaBVAAT71DSIgA4jjs7M4ehEVDjN3GiFtKt9Kzz34VB3nEYG/MtMA1nnBg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=pBDeLF6U; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="pBDeLF6U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=kPXiUxCV0Vzv1bVQjf1oXRhN7a0+bYmXasc3VjAxWB8=; t=1790348321; x=1791557921; 
	b=pBDeLF6UU0Th0iZC1I+OyzEHQVIbu/elNIoPhwpqwS0AnUESOKS4vVTx3ib5iii36R9tByQ8Hjx
	kCEeg4nId/5PoQOiQyJeaQmvMhUoh4qDR2HQJfkFkfOSuCf27EdAiOOLRJOgRZoa3xEBQRi4F619V
	qKIQcrTgB1SyU/mLD8PwHP+EpXwfV1leNhgZn+TtvLIjEZ5CzdT6Vp0cYJqU2o9Do6wsJzutFw7J3
	5UhDKrKmR56ed8At3hSjn72Q62Uc4MeyXk+kqaUoLZlJjD0ltCAkLHe0yESQUsPkFNjDw0irWkboz
	ZtIKtq9gqxI18XiMBOpc7871J4SJ/gXDPLxQ==;
Date: Fri, 25 Sep 2026 16:58:14 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: David Lin <yu-hao.lin@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>, Neeraj Sanjay Kale
 <neeraj.sanjaykale@nxp.com>, =?UTF-8?B?VGFtw6FzIFN6xbFjcw==?=
 <tszucs@protonmail.ch>, "linux-firmware@kernel.org"
 <linux-firmware@kernel.org>, "briannorris@chromium.org"
 <briannorris@chromium.org>, "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>, "lukas@wunner.de" <lukas@wunner.de>
Subject: Re: [EXT] Re: mwifiex firmware mrvl/sd8987_uapsta.bin missing in
 the firmware git
Message-ID: <20260925165814.567c9ab7@kemnade.info>
In-Reply-To: <PA4PR04MB96381A69AD86ED9C9E4AD9CDD1CD2@PA4PR04MB9638.eurprd04.prod.outlook.com>
References: <20240605160013.6bea8d4d@aktux>
	<_pNnwoI9WHlb2EY635KdIv6t_goU-ZYp9Vav31jkFOCf9fCE9EeKdyCea2m-L8pgfsKIQvODlnQLhQqmWSYip9e6FFZwaJHL5-u5rdOS_kY=@protonmail.ch>
	<20240605174709.5043af8f@akair>
	<20240606101839.GA76158@francesco-nb>
	<PA4PR04MB9638D1FD47BFBFDDB096C778D1C02@PA4PR04MB9638.eurprd04.prod.outlook.com>
	<ZmlEny2W0nArOf1T@gaggiata.pivistrello.it>
	<PA4PR04MB96381A69AD86ED9C9E4AD9CDD1CD2@PA4PR04MB9638.eurprd04.prod.outlook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Jun 2024 02:13:22 +0000
David Lin <yu-hao.lin@nxp.com> wrote:

> > From: Francesco Dolcini <francesco@dolcini.it>
> > Sent: Wednesday, June 12, 2024 2:48 PM
> > To: David Lin <yu-hao.lin@nxp.com>
> > Cc: Francesco Dolcini <francesco@dolcini.it>; Andreas Kemnade
> > <andreas@kemnade.info>; Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>;
> > Tam=C3=A1s Sz=C5=B1cs <tszucs@protonmail.ch>; linux-firmware@kernel.org;
> > briannorris@chromium.org; linux-wireless@vger.kernel.org; lukas@wunner.=
de
> > Subject: Re: [EXT] Re: mwifiex firmware mrvl/sd8987_uapsta.bin missing =
in the
> > firmware git
> >
> > Caution: This is an external email. Please take care when clicking link=
s or
> > opening attachments. When in doubt, report the message using the 'Report
> > this email' button
> >
> >
> > Hello David,
> >
> > On Wed, Jun 12, 2024 at 02:17:46AM +0000, David Lin wrote: =20
> > > > From: Francesco Dolcini <francesco@dolcini.it> On Wed, Jun 05, 2024
> > > > at 05:47:09PM +0200, Andreas Kemnade wrote: =20
> > > > > But that is all legalese and I am not a lawyer... Best is of
> > > > > course something officially added from NXP. No idea if it can be
> > > > > done otherwise. How to make NXP add something? =20
> > > >
> > > > Would it be possible for you to get these firmware files added to
> > > > the official linux-firmware git repo?
> > > >
> > > > I am not using sd8987 myself, from what I read in the thread
> > > > probably some file name would need to be corrected (I would say in =
the =20
> > mwifiex driver). =20
> > >
> > > I am not responsible for firmware release.
> > > You can get updated firmware from =20
> > https://github.co/
> > m%2Fnxp-imx%2Fimx-firmware%2F&data=3D05%7C02%7Cyu-hao.lin%40nxp.co
> > m%7C10acf638ebf04b0979ed08dc8aab99d5%7C686ea1d3bc2b4c6fa92cd99c5
> > c301635%7C0%7C0%7C638537716818815780%7CUnknown%7CTWFpbGZsb3d
> > 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> > D%7C0%7C%7C%7C&sdata=3DZrU82HbKZ%2Ff87IG2tgInfq7kbyCuV8PcksxvTWiM
> > HtQ%3D&reserved=3D0.
> > Yes, I am aware of both, and most of the people in this thread is aware=
 of the
> > second.
> >
> > I was wondering if you could facilitate within NXP having these firmwar=
e files
> > added to the linux firmware git repository, where they should be for va=
rious
> > reasons. To whom should I write such a request? Can you help in any way?
> >
> > Francesco =20
>=20
> I reported this issue just like Neeraj did.
>=20
This thing seems to be stalled.

How is the most practical way to deal with the situation? For people buildi=
ng OE
images for machines with these devices it seems clear. But if you do not sp=
read
full images, but have an archive of packages.=20
Lets say the Alpine linux distribution.

The License terms have in 2.3(b):
"(b)     to copy and distribute as needed, solely in connection with an
Authorized System and for use in combination with a NXP Product,"

If I read it correctly, the firmware cannot life in such a repository, since
the repository is used by different machines. Is my interpretation correct?
So would a downloader in a post-install hook be an alternative?

Regards,
Andreas
