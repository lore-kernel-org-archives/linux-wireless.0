Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35218 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbcGUVAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 17:00:05 -0400
Received: by mail-wm0-f43.google.com with SMTP id f65so34884436wmi.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 14:00:04 -0700 (PDT)
Date: Thu, 21 Jul 2016 22:00:01 +0100
From: Christopher Williamson <home@chrisaw.com>
To: "=?utf-8?Q?linux-wireless=40vger.kernel.org?="
	<linux-wireless@vger.kernel.org>, Dan Williams <dcbw@redhat.com>
Message-ID: <etPan.579137d1.40bb3278.381a@chrisaw.com> (sfid-20160721_230011_153243_895D14CA)
In-Reply-To: <1469133499.18298.8.camel@redhat.com>
References: <CANXHH3n7Gp+0NA8j9ji0S2dsYqbR9SE0MEuB5oKENE6Asz9j=w@mail.gmail.com>
 <1468946312.5661.2.camel@redhat.com>
 <CANXHH3kKV4m6rw9O=6x_QT2vwr7Tnx9EddpFq1VXfhnVdg9pFg@mail.gmail.com>
 <CANXHH3k4x1QWY9H4n=hDeLmVMxdi4HOuVxHTv1ztX0AhZF7B-Q@mail.gmail.com>
 <CANXHH3k3wSYYc2xS1rk9JqeWmekC+79YCYshMcXA-yz4rX_+Hw@mail.gmail.com>
 <1469033825.3004.8.camel@redhat.com> <1469033825.3004.8.camel@redhat.com>
 <CANXHH3minohF3z9bWc2NAghiU=w4DbsH1jU8iE8=v7H1pGdFcg@mail.gmail.com>
 <1469051432.3286.4.camel@redhat.com> <1469051432.3286.4.camel@redhat.com>
 <CANXHH3n0=dmV+2D9FeOoGuqDvKJHdpnOMdYH1Ecr3TACJ5FXYQ@mail.gmail.com>
 <1469115440.29944.1.camel@redhat.com>
 <CANXHH3kHFDkRUTMyOheFwpJasqOmtGrQ3dG7LP_L0CBN87Aagw@mail.gmail.com>
 <CANXHH3kwH_A-45D9ZsT3Afz3LxYW6Pgz06qBzfnK+jtcg8FiNg@mail.gmail.com>
 <1469133499.18298.8.camel@redhat.com>
 <1469133499.18298.8.camel@redhat.com>
Subject: Re: Problem connecting to wifi on libertas_cpio (sd8686)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure! 

wpa_supplicant logs: 
http://termbin.com/z1hg 

dmesg logs (grepped for libertas): 
http://termbin.com/7rt5 


Christopher Williamson




On 21 July 2016 at 21:38:26, Dan Williams (dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:

> On Thu, 2016-07-21 at 11:55 -0700, Christopher Williamson wrote:
> > Just to confirm - I can connect to the same network using the same
> > configurations using a USB wifi adapter I tried.
>  
> Can you grab simultaneous driver debug logging and supplicant debug
> logging? Unfortunately the 'status 1' is an unspecified failure, which
> could be from the AP or the firmware.
>  
> Dan
>  
>  
> > Unfortunately it’s not ideal since the point of the Viliv N5 is that
> > it’s ultra portable so I would really like to get the inbuilt wifi
> > card working.
> >
> > It seems odd that wpa_supplicant reports the connection being
> > “rejected” as seen below:
> >
> > wlan0: CTRL-EVENT-ASSOC-REJECT bssid=a0:63:91:1e:ee:43 status_code=1
> >
> > Most of the debug output sadly doesn’t mean a great deal to me - wifi
> > isn’t really my area of expertise.
> >
> > On 21 July 2016 at 19:10:56, Christopher Williamson
> > (home@chrisaw.com(mailto:home@chrisaw.com)) wrote:
> >
> > >
> > >
> > > Sure, here are the results:
> > >
> > > http://termbin.com/e8e2
> > >
> > > Christopher Williamson
> > >
> > >
> > > On 21 July 2016 at 16:37:24, Dan Williams (dcbw@redhat.com(mailto:d
> > > cbw@redhat.com)) wrote:
> > >
> > > >
> > > > On Wed, 2016-07-20 at 15:16 -0700, Christopher Williamson wrote:
> > > > >
> > > > > I used NetworkManager in the previous test.
> > > > >
> > > > > This time around I have used wpa_supplicant directly and get
> > > > > the
> > > > > following results:
> > > > >
> > > > > http://termbin.com/j8ea
> > > > >
> > > > > Thought I’d throw them on a pastebin since it’s over 700 lines.
> > > > Can you try with "-D nl80211" instead of using the WEXT
> > > > supplicant
> > > > driver? NM is likely going to use nl80211 since the driver has
> > > > some
> > > > support for cfg80211/nl80211 and only does WEXT through the glue
> > > > layer.
> > > >
> > > > Dan
> > > >
> > > > >
> > > > > Christopher Williamson
> > > > >
> > > > >
> > > > >
> > > > >
> > > > > On 20 July 2016 at 22:50:34, Dan Williams
> > > > > (dcbw@redhat.com(mailto:dcbw@redhat.com)) wrote:
> > > > >
> > > > > >
> > > > > >
> > > > > > On Wed, 2016-07-20 at 13:06 -0700, Christopher Williamson
> > > > > > wrote:
> > > > > > >
> > > > > > >
> > > > > > > Hi Dan,
> > > > > > >
> > > > > > > Ah - yeah I hadn’t thought it may be a kernel build option.
> > > > > > > I’ve
> > > > > > > now
> > > > > > > built that and dmesg is a much more lively place!
> > > > > > >
> > > > > > > I’ve provided output logs for both when the device is
> > > > > > > connected
> > > > > > > and
> > > > > > > when a connection attempt is made - hopefully this is
> > > > > > > useful.
> > > > > >
> > > > > > The card is scanning and only finds 'shaunthesheep' 20
> > > > > > seconds
> > > > > > after
> > > > > > you "connect for the first time". The logs stop 3 seconds
> > > > > > later.
> > > > > > Are
> > > > > > you connecting with wicd or something else?
> > > > > >
> > > > > > Can you run wpa_supplicant with the "-dddtu" option so we can
> > > > > > get
> > > > > > debug
> > > > > > log output from it?
> > > > > >
> > > > > > Dan
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe
> > > > > linux-
> > > > > wireless" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at http://vger.kernel.org/majordomo-info.ht
> > > > > ml
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

