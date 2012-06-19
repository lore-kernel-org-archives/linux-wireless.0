Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57003 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2FST21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 15:28:27 -0400
Received: by gglu4 with SMTP id u4so4998256ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 12:28:26 -0700 (PDT)
Date: Tue, 19 Jun 2012 14:28:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120619192818.GA19971@burratino> (sfid-20120619_212844_313339_68A8947A)
References: <20120601174237.GA31781@burratino>
 <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
 <20120619181522.GB19354@burratino>
 <4FE0CFD4.4000300@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4FE0CFD4.4000300@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> On 06/19/2012 08:15 PM, Jonathan Nieder wrote:

>> This was first reproduced on a kernel closely based on 3.2.9.  It
>> would typically happen pretty reliably once a day or so.  Four days of
>> testing a kernel close to 3.2.2 haven't triggered it again[1].
>>
>> The only brcm80211 change in that range is
>>
>>   f96b08a7e6f6 brcmsmac: fix tx queue flush infinite loop
>
> The WARN_ONCE added by the commit above still triggers sometimes. Two
> recent commits I did regarding this are in 3.4-stable. Not sure if they
> have been ported to 3.2 as well.
>
> 85091fc brcm80211: smac: fix endless retry of A-MPDU transmissions
> badc4f0 brcm80211: smac: resume transmit fifo upon receiving frames

Yep, both are in 3.2-stable (added in 3.2.18 and 3.2.17, respectively).

[...]
> However, I still observe the warning so I am looking what other event
> trigger this issue.

Feel free to contact Touko Korpela <touko.korpela@iki.fi> and Camaleón
if you need recent logs or other information about that[1].

I had been hoping that was mostly orthogonal until Camaleón mentioned
that 3.2.2 doesn't seem to trigger the random reconnects.

Thanks,
Jonathan

[1] tracked here: http://bugs.debian.org/672891
