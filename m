Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:41260 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbaAVP3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 10:29:48 -0500
Received: by mail-we0-f179.google.com with SMTP id w62so425524wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 07:29:47 -0800 (PST)
Date: Wed, 22 Jan 2014 16:28:46 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
Message-ID: <20140122152845.GB18365@magnum.frso.rivierawaves.com> (sfid-20140122_162952_028623_7AC5943E)
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
 <1390394079.4334.30.camel@jlt4.sipsolutions.net>
 <20140122130924.GA18365@magnum.frso.rivierawaves.com>
 <CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGXE3d_V2vST4nkFLUeXgTwbzB_GfPYM3HzBC1QjLuG_=LP2Kw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 02:33:14PM +0100, Helmut Schaa wrote:
> On Wed, Jan 22, 2014 at 2:09 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> > On Wed, Jan 22, 2014 at 01:34:39PM +0100, Johannes Berg wrote:
> >> Hmm. I guess you're right about the spec, but I vaguely remember races
> >> in this with the delBA going out too soon or so?
> >>
> >
> > Indeed, this was intended by cf6bb79 ("Use appropriate TID for sending
> > BAR, ADDBA and DELBA frames") and I overlooked it .. will look into it,
> > thanks.
> > I Cced Helmut who authored the said commit.
> 
> You're right. There were some issues with that, but that was 2 years ago :)
> 
> Sending ADDBA over AV_VO should be safe.
> If a DELBA is sent as AC_VO it might get received before the last AMPDU
> of the BlockAck session. So, the pending AMPDUs will get dropped at the
> receiver.
> 
> In theory this could also be avoided by properly flushing all pending AMPDUs
> of the TID in question from the hw queues or by waiting for the tx status
> of all pending AMPDUs.
> 

I just looked at the code with your change in mind and couldn't find any
issue caused by sending {add,del}ba on AC_VO.
As of today, a delba is sent only after a driver has called 'purposely'
ieee80211_stop_tx_ba_cb_irqsafe so I see no issue with the delba either,
do you see one today ?

Johannes, does it look good to you ? maybe add some comments in the
changelog relating to cf6bb79 ?

 
Karl
