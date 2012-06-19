Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1579 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2FSTPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 15:15:46 -0400
Message-ID: <4FE0CFD4.4000300@broadcom.com> (sfid-20120619_211549_688777_94A7D856)
Date: Tue, 19 Jun 2012 21:15:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
References: <20120530172713.GH3908@burratino>
 <CAKprTDGtvUFSBb_XK01bi6bJa3dynu73Lq-jTs=E78E3QwSqpA@mail.gmail.com>
 <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino> <20120619181522.GB19354@burratino>
In-Reply-To: <20120619181522.GB19354@burratino>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2012 08:15 PM, Jonathan Nieder wrote:
> Hi again,
> 
> Jonathan Nieder wrote:
> 
>> As discussed at [1], Camaleón has been experiencing unwanted random
>> wireless reconnects with various 3.2.y kernels up to and including
>> 3.2.19:
> 
> This was first reproduced on a kernel closely based on 3.2.9.  It
> would typically happen pretty reliably once a day or so.  Four days of
> testing a kernel close to 3.2.2 haven't triggered it again[1].
> 
> The only brcm80211 change in that range is
> 
>   f96b08a7e6f6 brcmsmac: fix tx queue flush infinite loop
> 

The WARN_ONCE added by the commit above still triggers sometimes. Two
recent commits I did regarding this are in 3.4-stable. Not sure if they
have been ported to 3.2 as well.

85091fc brcm80211: smac: fix endless retry of A-MPDU transmissions
badc4f0 brcm80211: smac: resume transmit fifo upon receiving frames

However, I still observe the warning so I am looking what other event
trigger this issue.

> So maybe the timeout is too short and this safety is tripping when it
> shouldn't.  I've asked Camaleón to try a recent 3.2.y kernel with and
> without that commit reverted to test this guess.
> 
> That leaves another mystery: which of the 22 changes listed at [2] was
> providing relief in earlier tests?  E.g., does
> 
>>   c261bdf8acad brcm80211: smac: indicate severe problems to Mac80211
> 
> make it easier to recover from this kind of error?  Are there commands
> we should run or diagnostics to try to get a better sense of what is
> going on?

Not commends yet. We want to add debugfs support. The commit above only
notifies mac80211 that we have a problem. However, the recovery scenario
that mac80211 initiates upon this notification turns out to be killing
for brcmsmac.

Gr. AvS

