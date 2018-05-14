Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:54065 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbeENShN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 14:37:13 -0400
Received: by mail-wm0-f67.google.com with SMTP id a67-v6so15168780wmf.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2018 11:37:13 -0700 (PDT)
Date: Mon, 14 May 2018 19:37:10 +0100
From: Chris Vine <vine35792468@gmail.com>
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: Regression: bcm4312 lp-phy device not working in 4.17-rc5
 kernel
Message-Id: <20180514193710.39101e4d30d2282fb1a73f10@gmail.com> (sfid-20180514_203717_434818_DEE31B28)
In-Reply-To: <20180514200205.47814f60@wiggum>
References: <20180514184953.001c06412efcf2b16fdc59ac@gmail.com>
        <20180514195539.74686870@wiggum>
        <20180514200205.47814f60@wiggum>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 14 May 2018 20:02:05 +0200
Michael B=FCsch <m@bues.ch> wrote:
> On Mon, 14 May 2018 19:55:39 +0200
> Michael B=FCsch <m@bues.ch> wrote:
>=20
> > On Mon, 14 May 2018 18:49:53 +0100
> > Chris Vine <vine35792468@gmail.com> wrote:
> >=20
> > > I have an old netbook with a Broadcom bcm4312 802.11b/g lp-phy
> > > [14e4:4315] (rev 01) wifi device.  This works up to and including the
> > > 4.16 kernel, but not with 4.17-rc5.
> > >=20
> > > The b43, mac80211, cfg80211, ssb and mmc_core modules are loaded OK, =
as
> > > is the firmware, and the wlan0 interface will come up, but any attempt
> > > to use the interface fails and it cannot (for example) scan.
> > >=20
> > > No useful error messages are given.  The interface (wlan0) is just
> > > reported as not being ready. =20
> >=20
> > Hi,
> >=20
> > thanks for your report.
> >=20
> > Can you please provide all kernel log messages anyway?
> > And what does "not ready" mean exactly?
> >=20
> > It would be extremely helpful if you'd do a git bisect to find the
> > commit that broke it.
> >=20
>=20
> Ok, I just noticed that mainline still contains the ssb breakage.
>=20
> So you are most likely hitting this:
> https://patchwork.kernel.org/patch/10393729/

Yes thanks, applying that patch resolves the issue fine.  There was a
similar problem with disabled PCI support for b43 which found its way
into the 4.15.0/4.15.1 kernels:
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/=
commit/?id=3Da9e6d44ddeccd3522670e641f1ed9b068e746ff7
At least this bug should avoid getting into the mainline release.

Chris
