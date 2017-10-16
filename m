Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdJPHuC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 03:50:02 -0400
Date: Mon, 16 Oct 2017 09:50:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pkshih <pkshih@realtek.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: Two rtlwifi drivers?
Message-ID: <20171016075010.GB3044@kroah.com> (sfid-20171016_095006_608898_225260D0)
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
 <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
 <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 16, 2017 at 02:41:38AM +0000, Pkshih wrote:
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, October 12, 2017 6:35 PM
> > To: Kalle Valo
> > Cc: Larry Finger; Dan Carpenter; Pkshih; 莊彥宣; Johannes Berg; Souptick Joarder;
> > devel@driverdev.osuosl.org; linux-wireless@vger.kernel.org; kernel-janitors@vger.kernel.org
> > Subject: Re: Two rtlwifi drivers?
> > 
> > On Thu, Oct 12, 2017 at 11:38:06AM +0300, Kalle Valo wrote:
> > > > So what to do?  Any ideas?  What makes your life easier?  You can just
> > > > ignore the staging tree, as it should not affect your portion of the
> > > > kernel at all, right?
> > >
> > > Yes, I automatically ignore anything staging related. But the problem is
> > > that we now have two drivers with the same name and people don't always
> > > remember to prefix the patch with "staging: ". So on a bad day I might
> > > accidentally apply a patch which was meant for your tree. Of course I
> > > immediately revert it as soon as I, or someone else, catches that but
> > > annoying still.
> > 
> > It doesn't bother me if you apply staging patches, I can handle the
> > merge issues :)
> > 
> > > I think we have two options here:
> > >
> > > 1) We set a deadline (like 12 months or something) for the
> > >    drivers/staging/rtlwifi and after that you refuse to take any patches
> > >    for it. Hopefully this makes it clear for everyone that this fork is
> > >    just temporary. I think Larry is trying to do this, which is great.
> > 
> > Fine with me, if Larry is ok with it.
> > 
> > > 2) We move the whole rtlwifi driver to staging. A very bad option but
> > >    still better than forking the drivers.
> > 
> > Ick, I don't want that to have to happen, that would not be good for the
> > users of other devices that the "real" rtlwifi driver supports.
> > 
> 
> Hi Larry, Kalle and Gerg,
> 
> This is Realtek engineer, PK. I appreciate your support to submit, review 
> and merge patch. Since I'm a Linux newbie, I'll describe the situation of 
> rtlwifi and need your suggestions.
> 
> 
> 1) New modules in rtlwifi
>    We add two modules named phydm and halmac, when adding rtl8822be in 
>    staging. The phydm is BB/RF related module containing the parameters
>    and APIs of BB/RF, and a dynamic mechanism to adapt to different
>    field environment. The halmac consists of MAC APIs.
>    The two modules are used by many OSs, so '#ifdef', CamelCase and
>    so on are existing in original files. Hence, we convert them to Linux 
>    form by script, but it's not perfect. Do you have suggestion to deal
>    with this problem?

Yes, use a script like you are doing, and then just work from the Linux
versions from then on.  Trying to do an OS independant layer almost
never works well over time, the only people that I have seen doing it
successfully is the ACPI core code, and for that, those developers do
have lots of scripts to turn their internal version into Linux-friendly
patches.

It takes a lot more work and time to try to do this, just working
directly on Linux is easier and cheaper over time :)

> 2) The rtlwifi in staging
>    In staging, the module phydm v13 contains bugs, so I want to upgrade
>    to v21 (Realtek internal version number). This upgrade contains a
>    big patch that the difference between v13 and v21, and there are 
>    40+ patches to support this upgrade. I have three options, and
>    I want to know which one is prefer.
> 
> 2.1) apply 40+ patches to both staging and wireless tree, and apply
>      the big patch to staging only. After reviewing, we move the module
>      to wireless tree.

I don't want a "big patch" for staging.

> 2.2) apply 40+ patches to wireless tree, and apply a single bigger 
>      patch containing 40+ patches and the big patch to staging. I think
>      this can be seen as a new driver in staging. After reviewing, 
>      we move the module to wireless tree.
> 
> 2.3) don't apply anything to staging. Just apply 40+ patches and add
>      phydm v21 to wireless.

This last option seems good to me, then move the driver that is in
staging to use the wireless core version instead?

> 3) Coming drivers -- rtl8723de and rtl8821ce
>    We're developing the two drivers, and rtl8723de and rtl8821ce will
>    be ready on 2017Q4 and 2018Q1 respectively. The drivers are based on
>    rtl8822be that in staging now, so the line of code will be fewer.
>    The new files will be a new IC folder and IC supported files of 
>    three modules that btcoexist, phydm and halmac. Could I submit
>    them to wirless tree when they're ready?

Sure, please submit them when they are ready, as long as they follow the
correct Linux style rules.

> 4) As Kalle mentioned, rtlwifi contains many magic numbers, and I 
>    plan to fix them after rtl8723de and rtl8821ce. Because the drivers
>    are developing, the changes will make us hard to integrate. However,
>    I don't have plan to process the magic numbers in the module phydm,
>    because the most of BB/RF registers contain many functions. And
>    it doesn't have a register name but a bit field name instead.
>    Our BB team guys say the use of enumeration or defined name will
>    be unreadable, and the name is meaningless for most people.

Don't be so sure that names are "meaningless", there are people here
that have been doing network drivers and development for longer than
anyone else in the world.  It's best to at least name values, even if
they do not seem to make sense, as that way the value can be tracked
correctly, and possibly be understood later by someone else, or even
you!

thanks,

greg k-h
