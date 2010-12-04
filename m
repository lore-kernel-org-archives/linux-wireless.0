Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:52772 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0LDNrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 08:47:35 -0500
Date: Sat, 4 Dec 2010 09:47:32 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101204134732.GA24216@monopoli.naic.edu>
References: <AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com> <20101202002234.GA30670@monopoli.naic.edu> <AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com> <20101203001052.GA16808@monopoli.naic.edu> <AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com> <AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com> <20101203202321.GA21937@monopoli.naic.edu> <AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com> <20101204033646.GA22662@monopoli.naic.edu> <AANLkTik=nbdNUU7gzO9V17fHWZibc2LjuXDgpeRDztoM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTik=nbdNUU7gzO9V17fHWZibc2LjuXDgpeRDztoM@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 04, 2010 at 12:01:34PM +0000, Dave Kilroy wrote:
> >> I'm at a loss. I've looked at the wpa_supplicant code, and had another
> >> look at the driver. The scan should be a plain wildcard scan - which
> >> you've identified works.
> >>
> >> Does setting scan_ssid=1 in the wpa_supplicant network block change
> >> the behaviour? That's usually only necessary for hidden SSIDs - but
> >> I'd like to know if the scan succeeds in this case.
> >
> > No It doesn't work.
> > But I have more informations for you.
> >
> > I have been testing different versions of wpa_supplicant
> > and I have found that if a use wpa_supplicant 0.7.0 or earlier,
> > it works. With 0.7.1 or newer it fails.
> > wpa_supplicant 0.7.0 works even without applying your patch.
> 
> I've set myself up so I can test with orinoco_usb. I can reproduce the
> issue (or something that looks the same).
> 
> After much confusion, I suspect the initial scan is being triggered
> before the hardware is ready. Internally, wpa_supplicant will do an
> 'ifconfig eth1 up' followed by an 'iwlist eth1 scan', and it seems the
> driver/hardware wants more time between them.
> 
> Try the following (either in two command prompts, or with
> wpa_supplicant in the background):
> 
> prompt1$ wpa_supplicant -dd -ieth1 ....
> 
> prompt2$ ifconfig eth1 down
> prompt2$ ifconfig eth1 up
> 
> and see what wpa_supplicant is doing. If it has got scan results then
> you're probably seeing what I am.
 
You are right. After running ifconfig eth1 down,up on a second terminal,
while wpa_supplicant iis running on the first terminal, 
it succesfully associates with the AP.

Giacomo
