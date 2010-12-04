Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:52454 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0LDDgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 22:36:50 -0500
Date: Fri, 3 Dec 2010 23:36:46 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101204033646.GA22662@monopoli.naic.edu>
References: <AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com> <20101130021911.GA18971@monopoli.naic.edu> <AANLkTi=1PXk4u37mPd6=F6mjYWLqo=wg7trVmmpfV_WV@mail.gmail.com> <20101202002234.GA30670@monopoli.naic.edu> <AANLkTi=YT1V-kr-tAmNfSBPPEGk39H37RoNkx5txhnD7@mail.gmail.com> <20101203001052.GA16808@monopoli.naic.edu> <AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com> <AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com> <20101203202321.GA21937@monopoli.naic.edu> <AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 10:49:55PM +0000, Dave Kilroy wrote:
> >> >> But after removing the line: ap_scan=2
> >> >> the association fails.
> >> >> The log is in the second attachment.
> >> >>
> >> >> Also I have included in the 3rd attachement wpa_supplicant.log when
> >> >> NetworkManager is used.
> >>
> >> > The failure and NM case are the same. There is still a problem with
> >> > scanning. wpa_supplicant initiates a scan, and it appears to time out.
> >> > Without scan results wpa_supplicant is not able to select an
> >> > appropriate AP.
> >> >
> >> > Is the driver reporting any scanning issues in dmesg while
> >> > wpa_supplicant is running?
> >
> > In dmesg there is:
> > ADDRCONF(NETDEV_UP): eth1: link is not ready
> >
> > and on standard error:
> > ioctl[SIOCSIWENCODEEXT]: Invalid argument
> 
> Those are expected.
> 
> I'm at a loss. I've looked at the wpa_supplicant code, and had another
> look at the driver. The scan should be a plain wildcard scan - which
> you've identified works.
> 
> Does setting scan_ssid=1 in the wpa_supplicant network block change
> the behaviour? That's usually only necessary for hidden SSIDs - but
> I'd like to know if the scan succeeds in this case.

No It doesn't work.
But I have more informations for you.

I have been testing different versions of wpa_supplicant
and I have found that if a use wpa_supplicant 0.7.0 or earlier,
it works. With 0.7.1 or newer it fails.
wpa_supplicant 0.7.0 works even without applying your patch.

I hope this helps.
Giacomo
