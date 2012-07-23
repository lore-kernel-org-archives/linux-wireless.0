Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62659 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GWA2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 20:28:18 -0400
Received: by yhmm54 with SMTP id m54so4983914yhm.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 17:28:17 -0700 (PDT)
Date: Sun, 22 Jul 2012 19:28:08 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Roland Vossen <rvossen@broadcom.com>
Subject: Re: [3.2.y] Re: Brcmsmac driver woes, possible regression?
Message-ID: <20120723002808.GA3305@burratino> (sfid-20120723_022822_593736_9B524CAF)
References: <CAKprTDHepfbCKquvnG8CQ2=-tSNbgOSkT6R0GQmEx9UyuiZyMQ@mail.gmail.com>
 <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120611031544.GB3092@burratino>
 <4FE0CA49.3030909@broadcom.com>
 <20120716213122.GA3078@burratino>
 <50051A2F.3030206@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <50051A2F.3030206@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel wrote:
> On 07/16/2012 11:31 PM, Jonathan Nieder wrote:

>> With all the above patches applied on top of 3.2.21, Camaleón quickly
>> gets the reconnects and gnome-shell segfaults if she does not supply
>> the password to network-manager in time[1].  That means the patch that
>> prevents trouble is presumably one of the four listed below.
>>
>>>>   137dabed34a1 brcm80211: smac: remove smatch warnings from brcmsmac code
>>>>   2b0a53d51b5f brcm80211: smac: only print block-ack timeout message at
>>>>                trace level
>>>>   6b8da423315b brcm80211: smac: do not use US as fallback regulatory hint
>>>>   94a2ca311cf4 brcm80211: smac: only provide valid regulatory hint
>>
>> Thanks,
>> Jonathan
>>
>> [1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=295;bug=664767
>
> Thanks, Jonathan
>
> I guess the behaviour improved due to the last two patches listed above,
> but I also suspect that it is only an improvement and the root cause
> still exists.

I think you're right.  Camaleón tried with all patches except the last
one and still got the unwanted reconnects.

Would 6b8da423315b and 94a2ca311cf4 be good candidates for stable@ in
the meantime (for symptom relief and saner regulatory code) until the
root cause is found?

Thanks,
Jonathan
