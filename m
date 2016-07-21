Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38015 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbcGUSLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 14:11:05 -0400
Received: by mail-wm0-f46.google.com with SMTP id o80so35349564wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 11:11:04 -0700 (PDT)
From: Christopher Williamson <home@chrisaw.com>
In-Reply-To: <1469115440.29944.1.camel@redhat.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com> <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
 <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com>
 <1469033825.3004.8.camel@redhat.com> <1469033825.3004.8.camel@redhat.com>
 <CANXHH3minohF3z9bWc2NAghiU=w4DbsH1jU8iE8=v7H1pGdFcg@mail.gmail.com>
 <1469051432.3286.4.camel@redhat.com> <1469051432.3286.4.camel@redhat.com>
 <CANXHH3n0=dmV+2D9FeOoGuqDvKJHdpnOMdYH1Ecr3TACJ5FXYQ@mail.gmail.com> <1469115440.29944.1.camel@redhat.com>
MIME-Version: 1.0
Date: Thu, 21 Jul 2016 11:10:56 -0700
Message-ID: <CANXHH3kHFDkRUTMyOheFwpJasqOmtGrQ3dG7LP_L0CBN87Aagw@mail.gmail.com> (sfid-20160721_201110_852821_3C88A856)
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure, here are the results:

http://termbin.com/e8e2

Christopher Williamson


On 21 July 2016 at 16:37:24, Dan Williams
(dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:

> On Wed, 2016-07-20 at 15:16 -0700, Christopher Williamson wrote:
> > I used NetworkManager in the previous test.
> >
> > This time around I have used wpa_supplicant directly and get the
> > following results:
> >
> > http://termbin.com/j8ea
> >
> > Thought I’d throw them on a pastebin since it’s over 700 lines.
>
> Can you try with "-D nl80211" instead of using the WEXT supplicant
> driver? NM is likely going to use nl80211 since the driver has some
> support for cfg80211/nl80211 and only does WEXT through the glue
> layer.
>
> Dan
>
> > Christopher Williamson
> >
> >
> >
> >
> > On 20 July 2016 at 22:50:34, Dan Williams
> > (dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:
> >
> > >
> > > On Wed, 2016-07-20 at 13:06 -0700, Christopher Williamson wrote:
> > > >
> > > > Hi Dan,
> > > >
> > > > Ah - yeah I hadn’t thought it may be a kernel build option. I’ve
> > > > now
> > > > built that and dmesg is a much more lively place!
> > > >
> > > > I’ve provided output logs for both when the device is connected
> > > > and
> > > > when a connection attempt is made - hopefully this is useful.
> > >
> > >
> > > The card is scanning and only finds 'shaunthesheep' 20 seconds
> > > after
> > > you "connect for the first time". The logs stop 3 seconds later.
> > > Are
> > > you connecting with wicd or something else?
> > >
> > > Can you run wpa_supplicant with the "-dddtu" option so we can get
> > > debug
> > > log output from it?
> > >
> > > Dan
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
