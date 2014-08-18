Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:35932 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaHRU6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 16:58:19 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so5632887wev.27
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2014 13:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnY1wV2DFrs4P6F+oz2vPH+tbziSGc-Gq=QOQfsrbf6wQ@mail.gmail.com>
References: <CAHqTa-10bc+AtFbifObfqHXwzfcbrA5w9Z6LL53kUdDWeq=7ig@mail.gmail.com>
 <CA+BoTQnY1wV2DFrs4P6F+oz2vPH+tbziSGc-Gq=QOQfsrbf6wQ@mail.gmail.com>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 18 Aug 2014 16:57:57 -0400
Message-ID: <CAHqTa-3e4qeutKPaZ--s2kiwBWjsz=j71tPPJDp9vUJdRK+qsw@mail.gmail.com> (sfid-20140818_225831_287868_CBC3FD51)
Subject: Re: Best choice of primary channels when using 40- or 80 MHz wide channels
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2014 at 5:14 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 16 August 2014 01:42, Avery Pennarun <apenwarr@gmail.com> wrote:
>> or perhaps this (40 Mhz uses upper half instead of lower half):
>>
>> channel=157
>> ht_capab=[HT20][HT40+][RX-STBC1]
>> vht_capab=[MAX-A-MPDU-LEN-EXP4]
>> vht_oper_chwidth=1
>> vht_oper_centr_freq_seg0_idx=155
>>
>> But when I try to do this, hostapd seems to abort and claim it can't
>> register to use the channels.  Am I doing something wrong?  Is it
>> hostapd version related?
>
> All following configs work for me:
>
> http://pastebin.com/w1LKTDGn
> http://pastebin.com/McquAcCf
> http://pastebin.com/1RNWHAAS
> http://pastebin.com/kDd2RybJ
>
> My hostapd is at 6d00ab04302df257cb3092b2b31b4eac42e77569.

Hmm, let me try your configurations and see what happens.  Maybe I
just did something silly.  That would be good news :)

>> Also, hostapd contains code to swap the primary/secondary 20 MHz
>> channels in the 40 MHz channel, based on what other APs are around.
>> If I read correctly, it seems to want to use the same primary channel
>> as everyone else.  Wouldn't it be better to equailze things to try to
>> get about half the APs using each sub channel?
>
> That would break 20/40 coex, wouldn't it?

I'm certainly not the expert on this, but here's what I *think* I read
about it: in 40 MHz mode, you have to send an (identical I guess)
802.11g-compatible frame-start header on both 20 MHz subchannels at
the beginning of the frame.  You also have to do carrier detection on
both subchannels before transmitting, of course.  Then you can
transmit the actual content on the single 40 MHz wide channel now that
you know it's clear.

If it doesn't work this way, then if you have 802.11g APs on, say,
channels 1 and 5, and you set up a 40 MHz AP on channels 1+5 (with
either one being the primary), you will cause problems for anyone on
the secondary channel.

Am I misremembering/misunderstanding what I read?  Or maybe devices
aren't actually implemented like that?

I guess the best approach is to actually benchmark it with/without the
channel swap and find out how bad the interference is.

Thanks,

Avery
