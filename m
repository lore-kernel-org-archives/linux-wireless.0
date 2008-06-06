Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922AbYFFQFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 12:05:16 -0400
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
From: Dan Williams <dcbw@redhat.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Ian Schram <ischram@telenet.be>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <48495E85.9050608@mandriva.org>
References: <4848289D.1080205@mandriva.org> <48482BC3.4070402@mandriva.org>
	 <4848482C.2080208@mandriva.org> <48485F12.2050908@mandriva.org>
	 <48488878.5040708@telenet.be>
	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>
	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>
	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com>
	 <48494EF6.4020506@mandriva.org>
	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>
	 <1212765720.28631.19.camel@localhost.localdomain>
	 <48495E85.9050608@mandriva.org>
Content-Type: text/plain; charset=utf8
Date: Fri, 06 Jun 2008 12:04:59 -0400
Message-Id: <1212768299.14803.2.camel@localhost.localdomain> (sfid-20080606_180522_016351_61C166A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-06 at 18:57 +0300, Thomas Backlund wrote:
> Dan Williams skrev:
> > On Fri, 2008-06-06 at 18:12 +0300, Tomas Winkler wrote:
> >> On Fri, Jun 6, 2008 at 5:51 PM, Thomas Backlund <tmb@mandriva.org>=
 wrote:
> >>> Tomas Winkler skrev:
> >>>> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.or=
g> wrote:
> >>>>> Thomas Backlund skrev:
> >>>>>> Tomas Winkler skrev:
> >>>>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.b=
e> wrote:
> >>>>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
> >>>>>>>>
> >>>>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
> >>>>>>>>
> >>>>>>>> invalid length of webkey that would/should be handled in mac=
80211?
> >>>>>>>>
> >>>>>>>> ian
> >>>>>>> Yes, it looks like.
> >>>>>> Ummm, what has a wep key to do with me trying to access a WPA2=
-Personal
> >>>>>> encrypted net ?
> >>>> Not sure yet, but mac is trying to assign default/static wep key=
=2E
> >>>>
> >>>> :iwlcore:iwl_send_static_wepkey_cmd+0xcb/0xd5
> >>>> :iwlcore:iwl_set_default_wep_key+0xa2/0xbc
> >>>>
> >>>> Try to set the encryption explicitly
> >>>> network=3D{
> >>>>    psk=3D"*************************"
> >>>>    scan_ssid=3D1
> >>>>    ssid=3D"dlink"
> >>>>    pairwise=3DCCMP
> >>>>   group=3DCCMP
> >>>>  }
> >>>>
> >>>>
> >>> That didn't help at all...
> >>>
> >>> What's more it prevented the wifi to work on 2.6.24.7 so I had to=
 remove the
> >>> lines again...
> >>>
> >> So what's your AP configuration TKIP?
> >=20
> > Yeah, the supplicant log he posted clearly shows that the GTK is TK=
IP.
> >=20
> > =EF=BB=BF> 1212763152.516781: wpa_driver_wext_set_key: alg=3D2 key_=
idx=3D1 set_tx=3D0 seq_len=3D6 key_len=3D32
> >> 1212763152.516790: WPA: Key negotiation completed with 00:xx:xx:xx=
:xx:xx [PTK=3DCCMP GTK=3DTKIP]
> >=20
>=20
> The AP is actually set for TKIP+AES
>=20
> BTW, is that better or worse than a clean AES ?
> I'm reading up on it, but I get a lot of conflicting info...

It's less secure than straight AES.

WEP < TKIP < AES/CCMP

Dan

> > Dan
> >=20
> >> Second try also with sw decryption:
> >>
> >> in /etc/modprobe.conf
> >> options iwl4965 swcrypto=3D1
> >>
> >>
> >> Tomas
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-wi=
reless" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> Thomas

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
