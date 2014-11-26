Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaKZAKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 19:10:00 -0500
Message-ID: <1416960593.32537.2.camel@dcbw.local> (sfid-20141126_011003_863750_232F1BD4)
Subject: Re: Setting WLAN RF Sensitivity value
From: Dan Williams <dcbw@redhat.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Mohammad Ali Ma Abu Shattal <mohammad.a.shattal@wmich.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Date: Tue, 25 Nov 2014 18:09:53 -0600
In-Reply-To: <CAHNKnsRhPW2YGSTvmD-_hPci7V0hqCGyUHy4CfFr5QQtsF=FGw@mail.gmail.com>
References: <2109154365.18865892.1416932147808.JavaMail.root@wmich.edu>
	 <1013439490.18867944.1416932462547.JavaMail.root@wmich.edu>
	 <CAHNKnsRhPW2YGSTvmD-_hPci7V0hqCGyUHy4CfFr5QQtsF=FGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-26 at 02:12 +0300, Sergey Ryazanov wrote:
> 2014-11-25 19:21 GMT+03:00 Mohammad Ali Ma Abu Shattal
> <mohammad.a.shattal@wmich.edu>:
> > Dear Sir/Madam,
> >
> > I'm working on a project in which we need to set and get RF sensitivity of WLAN device.
> Could you specify, what exactly parameter do you want to control? In
> the your askubuntu post, you refer to "iwconfig wlan0 sens" command,
> which can control too many aspects, including the selection of the
> best AP and the detection of channel busy condition. And actual
> parameter "depends on the hardware implementation" as said in iwconfig
> manpage.

Indeed, only airo, ipw2200, hostap, and prism54 support this feature,
all of these are extremely old drivers.  mac80211 does not support it.
It appears to be used in the old drivers to ignore any signal quieter
than the given sensitivity.

Dan

> > I tried to set other settings such as operation mode, txpower and frequency using Linux commands : "ioctl" and "iwconfig" and it works fine.
> Consider using NL80211 and "iw" utility, since IOCTL based
> wireless-extensions interface is deprecated.
> 
> > Manufacturer of my device is Broadcom. It seems that either the hardware or the driver doesn't support setting and getting sensitivity. I need to know if there exists a device and/or device driver that support this feature. details of my current hardware and device driver are posted in the askubuntu question:
> > http://askubuntu.com/questions/553286/wlan-sensitivity-setting-is-not-supported
> > kindly send me your recommendation for such device or device driver.
> >
> > best regards,
> > Mohammad
> > ----------------------------
> > Mohammad Abu Shattal
> > Ph.D Student
> > Department of Electrical & Computer Engineering
> > Western Michigan University
> > Kalamazoo, MI 49008
> 


