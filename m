Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbYF0SLu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 14:11:50 -0400
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joonwoo Park <joonwpark81@gmail.com>,
	JMF <tolas_feup@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806270922u3975220ehb122f33497a69607@mail.gmail.com>
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <loom.20080527T105701-941@post.gmane.org>
	 <1ba2fa240805270541wadf0f16t2001528f39b37ea8@mail.gmail.com>
	 <1211896423.1746.9.camel@localhost.localdomain>
	 <20080528004100.GG7779@tuxdriver.com> <20080615164617.GA27699@tp64>
	 <1ba2fa240806150953t4b61b213y3488940ef05b762e@mail.gmail.com>
	 <1213605989.3803.24.camel@johannes.berg>
	 <20080627152843.GA16003@tuxdriver.com>
	 <1214582853.10355.28.camel@localhost.localdomain>
	 <1ba2fa240806270922u3975220ehb122f33497a69607@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Jun 2008 14:10:19 -0400
Message-Id: <1214590219.24579.7.camel@localhost.localdomain> (sfid-20080627_201155_027987_35875E42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-27 at 19:22 +0300, Tomas Winkler wrote:
> On Fri, Jun 27, 2008 at 7:07 PM, Dan Williams <dcbw@redhat.com> wrote=
:
> > On Fri, 2008-06-27 at 11:28 -0400, John W. Linville wrote:
> >> On Mon, Jun 16, 2008 at 10:46:29AM +0200, Johannes Berg wrote:
> >> >
> >> > > > [PATCH] wireless: Limit wep key size to 128/104-bits
> >> > > >
> >> > > > This patch prevents overflow which is occured by invalid lon=
g wep key
> >> > > > insertion
> >> > > >
> >> > > > $sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-=
AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA
> >> > > >
> >> > > > BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000000
> >> > > > IP: [memcpy_c+0xb/0x20] memcpy_c+0xb/0x20
> >> > > > PGD 13a590067 PUD 12e471067 PMD 0
> >> > > > Oops: 0000 [1] PREEMPT SMP
> >> > > > CPU 1
> >> > > > ...
> >> > > > Pid: 10, comm: events/1 Not tainted 2.6.26-rc2 #9
> >> > > > ...
> >> > > > Call Trace:
> >> > > >  [iwl4965:iwl4965_rx_scan_start_notif+0xb/0x20] ? :iwl4965:i=
wl4965_enqueue_hcmd+0x12b/0x220
> >> > > >  [hci_usb:init_module+0xe97/0x28cb0] :iwlcore:iwl_send_cmd_s=
ync+0x67/0x290
> >> > > >  [save_trace+0x3f/0xb0] ? save_trace+0x3f/0xb0
> >> > > > ...
> >> > > >
> >> > > > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> >> > > > ---
> >> > > >  net/wireless/wext.c |   11 ++++++++++-
> >> >
> >> > I'm sure Jean will cry murder because he expects there are some =
stupid
> >> > full-mac cards that actually support other sizes.
> >> >
> >> > Can't somebody just post a patch to mac80211 that only accepts t=
he two
> >> > correct sizes like cfg80211 does?
> >>
> >> Strawman patch below...
> >
> > You need to allow 0 through, since you can just set the transmit ke=
y
> > index via ENCODE without setting the key.  So the legal values are =
0, 5,
> > and 13.  Add 'case 0: /* just setting TX index */' or something and=
 I'll
> > definitely ack it.
> >
> > Dan
> >
> >> ---
> >>
> >> From: John W. Linville <linville@tuxdriver.com>
> >> Subject: [PATCH] mac80211: allow only standard size WEP keys throu=
gh WEXT
> >>
> >> Limit ieee80211_ioctl_siwencode to only accept standard sized WEP =
keys.
> >>
> >> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> >> ---
> >>  net/mac80211/wext.c |   10 ++++++++++
> >>  1 files changed, 10 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> >> index 5af3862..d16b975 100644
> >> --- a/net/mac80211/wext.c
> >> +++ b/net/mac80211/wext.c
> >> @@ -26,6 +26,8 @@
> >>  #include "wpa.h"
> >>  #include "aes_ccm.h"
> >>
> >> +#define KEY_SIZE_WEP104 13      /* 104/128-bit WEP keys */
> >> +#define KEY_SIZE_WEP40  5       /* 40/64-bit WEP keys */
> >>
> >>  static int ieee80211_set_encryption(struct net_device *dev, u8 *s=
ta_addr,
> >>                                   int idx, int alg, int remove,
> >> @@ -879,6 +881,14 @@ static int ieee80211_ioctl_siwencode(struct n=
et_device *dev,
> >>       u8 bcaddr[ETH_ALEN] =3D { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff=
 };
> >>       int remove =3D 0;
> >>
> >> +     switch (erq->length) {
> >> +     case KEY_SIZE_WEP40:
> >> +     case KEY_SIZE_WEP104:
> >> +             break;
> >> +     default:
> >> +             return -EINVAL;
> >> +     }
> >> +
> >>       sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> >>
> >>       idx =3D erq->flags & IW_ENCODE_INDEX;
> >> --
> >> 1.5.5.1
>=20
> I'm not against this patch just I thought we agreed to support the
> weird WEP keys in the  software. We fixed this in the driver with
> similar check so now it falls back to software encryption in mac80211=
=2E

I thought we agreed to ignore > 104/128-bit WEP keys [1][2] until enoug=
h
people yelled about it (I've heard from 1 or 2 people in the past three
years about this for NetworkManager).

I'm personally of the opinion that since so few APs support it, it's
going to be another codepath that's just not going to get tested becaus=
e
nobody has the client or AP hardware and nobody cares enough.  I don't
really care one way or the other; if you guys need to support it for
customers that's fine.

Dan

[1] "=EF=BB=BFWe decided not to care about those right now, but I didn'=
t
think that would impact TKIP at all" from "=EF=BB=BFRe: iwl4965 oops in
2.6.26-rc5 x86_64"

[2] =EF=BB=BFRe: [PATCH] iwlwifi: fix oops on wep key insertion (=EF=BB=
=BFMon, 16 Jun
2008 10:30:59 -0400)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
