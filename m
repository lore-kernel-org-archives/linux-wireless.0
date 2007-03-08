Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:38075 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXCHH4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 02:56:19 -0500
Received: by nf-out-0910.google.com with SMTP id o25so540630nfa
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2007 23:56:18 -0800 (PST)
Message-ID: <1197ff4c0703072356s575058e3h50c6104ec7609ff4@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:56:17 +0800
From: "Yanbo Li" <dreamfly281@gmail.com>
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: Problem with USB1.1 Host cores with the mb tree for bcm43xx_mac80211
Cc: "Michael Buesch" <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <45EF4305.5060606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <45EF2015.8000802@lwfinger.net> <200703072328.06195.mb@bu3sch.de>
	 <45EF4305.5060606@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/8/07, Larry Finger <larry.finger@lwfinger.net> wrote:
> Michael Buesch wrote:
> > On Wednesday 07 March 2007 21:27, Larry Finger wrote:
> >> If you have a BCM4311 and are seeing an oops that looks like this when loading bcm43xx_mac80211:
> >>
> >> ssb: Switching to ChipCommon core, index 0
> >> ssb: Switching to PCI-E core, index 3
> >> ssb: Switching to USB 1.1 Host core, index 2
> >>
> >> Unable to handle kernel NULL pointer dereference at 00000000000002d0 RIP:
> >>  [<ffffffff8812fcfd>] :usbcore:usb_create_hcd+0x3b/0xe8
> >> PGD 3e792067 PUD 3ed66067 PMD 0
> >> Oops: 0002 [1] SMP
> >> ...
> >>
> >> there is a temporary, unofficial patch at
> >> ftp://lwfinger.dynalias.org/patches/mac80211_usb_problem.patch. Although it works, it attacks the
> >> symptom, not the cause, and will never be adopted into the code. Once a proper fix is applied, it
> >> will no longer be needed.
> >
> > A patch to disable the USB core on non-embedded devices is in my tree now.
> > The actual bug is still there, but nobody (except OpenWRT developers ;) )
> > should be able to hit it anymore now. :)
>
> Your patch works here. Thanks,
>
> Larry
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
After patch the
ftp://lwfinger.dynalias.org/patches/mac80211_usb_problem.patch to the
newest wireless-dev tree, It seemed my 4311 works without key
authrized.  The Ap is a D-link 624+. but it is unstable. If need any
more info. I will be glad to supply.
BR
lyb
