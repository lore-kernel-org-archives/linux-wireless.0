Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:53277 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbZIPO5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 10:57:44 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1205482fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 07:57:47 -0700 (PDT)
From: Fabio Coatti <fabio.coatti@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwlagn rfkill and 2.6.31 on Intel Corporation PRO/Wireless 5100 AGN
Date: Wed, 16 Sep 2009 16:57:44 +0200
Cc: linux-wireless@vger.kernel.org, mjg@redhat.com
References: <200909161521.15710.fabio.coatti@gmail.com> <20090916132549.GA10634@tuxdriver.com>
In-Reply-To: <20090916132549.GA10634@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909161657.44453.fabio.coatti@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the answer;

In fact, it wasn't loaded.

I've inserted that module and the behaviour changed: now the rfkill switch 
reacts in the correct way and I'm able to turn on and off bluetooth system.

But the behaviour of wifi sybsystem is still weird, (maybe for some faults on 
my side). Basically if the laptop starts with wifi enabled (rfkill off) 
wpa_supplicant can establish a connection, that can be killed by rfkill switch 
(both wifi and bluetooth seems to be killed). But when I turn off rfkill 
switch wpa_supplicant is unable to connect again; looking at syslog/dmesg I 
can see activity in bt stack, but no messages regarding wlan0.

Any suggestion?

dmeIn data mercoledì 16 settembre 2009 15:25:49, John W. Linville ha scritto:
> Is the hp-wmi module loaded?
> 
> On Wed, Sep 16, 2009 at 03:21:15PM +0200, Fabio Coatti wrote:
> > Hi all,
> > I'm experiencing a bad behaviour of rfkill / iwlang driver. Here the
> > description:
> >
> > Kernels: 2.6.30.[5,6] 2.6.31
> > Hardware: HP EliteBook 6930p
> >
> > Behaviour: once a working wireless is killed activating the rfkill
> > button, there is no way to turn off the rfkill and riactivate wifi
> > network. Even a reboot is not able to reset the situation; to get again
> > the control of rfkill button is to reboot under windows xp and activate
> > wifi. After that I can boot inder linux with wifi active and kill it with
> > rfkill button and the loop starts again :)
> > I'm pretty sure that this issue is present since some kernel before the
> > one I've reported, but I'm not sure about the versions.
> >
> > I don't know if this is iwlagn or acpi related bug (or my fault), I'm
> > available for any test.
> >
> > HW:
> > Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh]
> > Network Connection
> >         Subsystem: Intel Corporation Device 1211
> >         Flags: bus master, fast devsel, latency 0, IRQ 33
> >         Memory at d0100000 (64-bit, non-prefetchable) [size=8K]
> >         Capabilities: [c8] Power Management version 3
> >         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> >         Capabilities: [e0] Express Endpoint, MSI 00
> >         Capabilities: [100] Advanced Error Reporting
> >         Capabilities: [140] Device Serial Number 00-21-6b-ff-ff-74-2b-28
> >         Kernel driver in use: iwlagn
> >         Kernel modules: iwlagn
> >
> > Let me know if more information are needed.
> >
> > Thanks for any answer (I'm not subscribed to this list, so please CC me
> > on answers, thanks)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
