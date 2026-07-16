Received: from helium.openadk.org (helium.openadk.org [89.238.66.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D79B30E84F;
	Thu, 16 Jul 2026 22:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.238.66.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784240225; cv=none; b=rOMUXcBReWQBETlBQO7ZRIUQKUZ6Ne44PUXFi2dXrwt1IuQzovObYg0dHrviXYDuxIN9Ohb+ciT1JDs5o1W02BqpDbRywGKfPwm50BptcJUlojPtoXCFAqKHMwac6XnEUZg83UKwLYZJudIOcBv8ErIV+FulXth0ldTYA8g0maw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784240225; c=relaxed/simple;
	bh=AltTvc/TLqbsT2epEE94vx4WMX3H56zKHtx3vgICEI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apjxYcYdHjds3RMTuuVXmpt9JDwsMmVMuBKURBA5sza6dFPvSCbtceRkHn3BIKv/EiTKzcrHde+nZCjQYZc3OZxjnwhB577XyC4djtlDUI9onCC2lpapK24UnbSYl51cK4Bu7Y3YTAQ56+kpLajRZVZzZw1zC077xZPLgeraoGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=openadk.org; spf=pass smtp.mailfrom=openadk.org; dkim=fail (0-bit key) header.d=openadk.org header.i=@openadk.org header.b=XtDZ/xCJ reason="key not found in DNS"; arc=none smtp.client-ip=89.238.66.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=openadk.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openadk.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=openadk.org header.i=@openadk.org header.b="XtDZ/xCJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openadk.org; s=2022;
	t=1784240215; bh=AltTvc/TLqbsT2epEE94vx4WMX3H56zKHtx3vgICEI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtDZ/xCJVJ5yE3LW7jnkOI8NUiIdFjdenoKEJYSCKpjUyvxNVw/toXHG3T35dNp04
	 sEL6SCbSGx9faLd+7fHKMwiMYlgI9XgcIVUEAYSr6XfuN4B7D2bwzuLhx+2q4wG4tr
	 zVmh4hj0LlLxY4d5SkxpSwR1z+SW6SV+d6HVk0KALGtKWmI4IeLghfbBwr7OIxYpep
	 3CmzY4mwf+8cc+n/dGtCVh20JDgIC6aIkJF3XO81UrVOviy4YjFCHAv8tWwuLmxT87
	 jSAMDuvO4w/2wLawTy3Xgla+cWLmOEtCHPgeZFXBXf5Xm6PDnOPvfLNZUE41akW4P0
	 r79zuIHlxfceQ==
Received: by helium.openadk.org (Postfix, from userid 1000)
	id A818331E0B32; Fri, 17 Jul 2026 00:16:55 +0200 (CEST)
Date: Fri, 17 Jul 2026 00:16:55 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael =?utf-8?B?QsO8c2No?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v2 0/3] MIPS: BCM47XX: convert buttons to software nodes
Message-ID: <allYV8D0vmepaIKl@waldemar-brodkorb.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael =?utf-8?B?QsO8c2No?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Waldemar Brodkorb <wbx@openadk.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
References: <20260713-b4-bcm47xx-swnode-v2-0-2b879f0c193c@gmail.com>
 <4a8d64e1-5f8c-4ac0-afb0-2d68c3f53ada@app.fastmail.com>
 <ala9C6XMB3-ywpph@waldemar-brodkorb.de>
 <alci_45CzdVznaN2@google.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alci_45CzdVznaN2@google.com>
X-Operating-System: Linux 6.12.90+deb13.1-amd64 x86_64

Hi Dmitry, all,
Dmitry Torokhov wrote,

> Hi Waldemar,
> 
> On Wed, Jul 15, 2026 at 12:49:47AM +0200, Waldemar Brodkorb wrote:
> > Hi,
> > Arnd Bergmann wrote,
> > 
> > > On Mon, Jul 13, 2026, at 23:58, Dmitry Torokhov wrote:
> > > > This series converts the legacy gpio-keys platform device on BCM47XX
> > > > boards to use software nodes and static properties.
> > > >
> > > > To do this properly without relying on legacy name-based matching
> > > > (which is being removed from gpiolib), we introduce and register
> > > > software nodes for the underlying GPIO controllers (BCMA and SSB)
> > > > and reference them in the button properties.
> > > >
> > > > The first two patches add the software nodes to bcma-gpio and
> > > > ssb-gpio respectively. The third patch performs the conversion
> > > > for the BCM47XX buttons.
> > > >
> > > > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > > ---
> > > > As Johannes mentioned on v1 this best should go through MIPS tree.
> > > 
> > > Adding Waldemar to Cc. He has recently done some work to
> > > get this platform working again in FreeWRT and should
> > > be able to test your patches on hardware.
> > 
> > I normally use LTS kernel on the hardware (Linksys WRT54GS v1.0).
> > But for testing I updated to 7.1.3. Attached is the dmesg without
> > Dmitry's patches.  Button works, I can go into failsafe mode after
> > pressing the reset button on bootup.
> > 
> > With Dmitry's three patches applied I directly getting into failsafe
> > mode without pressing any button. Dmesg looks similar, but I get
> > following kernel message:
> > platform gpio-keys.0: deferred probe pending: gpio-keys: failed to get gpio
> > 
> > Looking at /dev I see no /dev/input/event0 device node anymore.
> > 
> > Attached is the small failsafe script I use on bootup.
> > Hope this helps.
> > 
> > Do I need to change my failsafe script for the new stuff or is
> > something else broken now? Do I miss some new kernel config option?
> > Or is the patch only for latest Linus git repo.
> 
> Thank you very much for testing. I think 7.1 should work. Could you
> please apply the test patch below and send me new dmesg? Hopefully I'll
> be able to figure out where I messed up.

We found the reason it was not working for me with 7.1.3.
The commit fe221742e388 is needed for 7.1.3. With that applied the
reset button works as usual.

So you can add:
Tested-by: Waldemar Brodkorb <wbx@openadk.org>

best regards
 Waldemar
