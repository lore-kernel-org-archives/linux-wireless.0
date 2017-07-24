Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755615AbdGXPvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 11:51:14 -0400
Message-ID: <1500911422.4571.3.camel@redhat.com> (sfid-20170724_175118_896002_7A06BB98)
Subject: Re: brcfmac: add possibility to turn off powersave on wiphy
From: Dan Williams <dcbw@redhat.com>
To: Rafal <fatwildcat@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Jul 2017 10:50:22 -0500
In-Reply-To: <alpine.DEB.2.20.1707212252060.13284@wilk>
References: <alpine.DEB.2.20.1707211652430.10663@wilk>
         <1500655872.10725.1.camel@redhat.com>
         <alpine.DEB.2.20.1707212252060.13284@wilk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-07-21 at 23:19 +0200, Rafal wrote:
> On Fri, 21 Jul 2017, Dan Williams wrote:
> 
> > On Fri, 2017-07-21 at 16:56 +0200, Rafal wrote:
> > > I have a board with ap6212 chip and I have encountered two
> > > problems
> > > with the brcmfmac driver operating with this device. First
> > > problem I
> > > describe below, second one in separate mail.
> > > 
> > > 
> > > Namely, I have noticed quite poor connection with the device
> > > despite
> > > good signal strength. Ping to the device was very uneven, about
> > > 50 -
> > > 100 ms in average, 10 - 20% of packets loss. After some
> > > investigations I have found that problem is caused by powersave
> > > feature on wiphy (BRCMF_C_SET_PM command). When the value is set
> > > to
> > > PM_OFF, the problem does not appear - ping is quite stable, ~2ms.
> > > When set to PM_FAST, the ping is bad.
> > > 
> > > The brcmfmac driver currently does not have possibility to turn
> > > off
> > > the powersave feature. I have added the possibility on 4.11.6
> > > kernel
> > 
> > I don't think that's true?  The driver implements the nl80211
> > set_power_mgmt hook, which lets you turn off powersave with
> > 'iw'.  That
> > seems like a much better option than a module parameter.  I know
> > other
> > drivers have the module parameter, but I personally consider that
> > legacy/holdover, given that we have runtime toggles for this kind
> > of
> > thing.
> > 
> > brcmf_cfg80211_set_power_mgmt() should do what you need, right?
> 
> Yes, it does.
> 
> In fact, I needed only a parameter in OF database. This is a bug in
> the
> device or firmware and I needed to disable the feature for this chip.
> Many device drivers allow to specify in OF database that driver
> should
> use a quirk. This is similar situation.

Does the power management issue cause problems before any association
happens?  If not, then I'd suggest 'iw' in startup scripts somewhere. 
Or better yet, use the normal quirk method of detecting the hardware
version via IDs or detecting the firmware via version or feature
strings and quirking on that.

Dan

> I have added the kernel parameter as an additional feature. I thought
> that not all platforms are using devicetree database. But maybe it is
> a
> bad idea.
> 
> Rafal
> 
> > 
> > Dan
> > 
