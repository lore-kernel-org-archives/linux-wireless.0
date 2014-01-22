Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34689 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaAVQmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 11:42:23 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so3948318ead.27
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 08:42:22 -0800 (PST)
Date: Wed, 22 Jan 2014 17:41:22 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
Message-ID: <20140122164122.GC18365@magnum.frso.rivierawaves.com> (sfid-20140122_174227_916322_02E4D0F9)
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
 <1390394079.4334.30.camel@jlt4.sipsolutions.net>
 <20140122130924.GA18365@magnum.frso.rivierawaves.com>
 <CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com>
 <20140122152845.GB18365@magnum.frso.rivierawaves.com>
 <CAGXE3d8_qukp_gb4P0PnJkQJT8MtsypYgzPojE+RqpzEK_R62Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGXE3d8_qukp_gb4P0PnJkQJT8MtsypYgzPojE+RqpzEK_R62Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 04:36:14PM +0100, Helmut Schaa wrote:
> On Wed, Jan 22, 2014 at 4:28 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> > On Wed, Jan 22, 2014 at 02:33:14PM +0100, Helmut Schaa wrote:
> >> On Wed, Jan 22, 2014 at 2:09 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> >> > On Wed, Jan 22, 2014 at 01:34:39PM +0100, Johannes Berg wrote:
> >> >> Hmm. I guess you're right about the spec, but I vaguely remember races
> >> >> in this with the delBA going out too soon or so?
> >> >>
> >> >
> >> > Indeed, this was intended by cf6bb79 ("Use appropriate TID for sending
> >> > BAR, ADDBA and DELBA frames") and I overlooked it .. will look into it,
> >> > thanks.
> >> > I Cced Helmut who authored the said commit.
> >>
> >> You're right. There were some issues with that, but that was 2 years ago :)
> >>
> >> Sending ADDBA over AV_VO should be safe.
> >> If a DELBA is sent as AC_VO it might get received before the last AMPDU
> >> of the BlockAck session. So, the pending AMPDUs will get dropped at the
> >> receiver.
> >>
> >> In theory this could also be avoided by properly flushing all pending AMPDUs
> >> of the TID in question from the hw queues or by waiting for the tx status
> >> of all pending AMPDUs.
> >>
> >
> > I just looked at the code with your change in mind and couldn't find any
> > issue caused by sending {add,del}ba on AC_VO.
> > As of today, a delba is sent only after a driver has called 'purposely'
> > ieee80211_stop_tx_ba_cb_irqsafe so I see no issue with the delba either,
> > do you see one today ?
> 
> If the driver does the right thing by flushing the right frames in the
> hw tx queues
> I think this should be ok. At least rt2x00 is not doing that, but
> maybe that's just
> an issue in rt2x00 :(
> 


I see you are one of the maintainers of the ralink drivers, do you
intend to fix it in those ?

Callers of ieee80211_stop_tx_ba_cb_irqsafe are:
ath9k
ath9k_htc
carl9170
wcn36xx
brcm80211
iwlegacy
iwlwifi
mwl8k
rt2x00
rtlwifi

Johannes, what is your impression ?

 
Karl
