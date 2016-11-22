Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35305 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932297AbcKVJnm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 04:43:42 -0500
Received: by mail-oi0-f49.google.com with SMTP id b126so12578447oia.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 01:43:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHdg3xYFWiC1YegR8U9WJ52zjYK242eYWHvx8rsuY6RZvD+9og@mail.gmail.com>
References: <CAHdg3xaCnAp8rgMs3mVYvV6TFadNjwBtCo+rpHgH_-L8JUo-dw@mail.gmail.com>
 <20161120010740.GB3581@localhost> <CA+BoTQm9DBc_tkQnXwLVuV6dbsEixn73t_TRk1akktTiwRm_0w@mail.gmail.com>
 <CAHdg3xZMJw47Zyh9ubawysGqo6N2qcNUXX1o19GyFYOHv8GivA@mail.gmail.com>
 <CA+BoTQ=xCmYtqrMZpoqtNUTN8e_WE=AFpqU3LQdopiSik5eODA@mail.gmail.com> <CAHdg3xYFWiC1YegR8U9WJ52zjYK242eYWHvx8rsuY6RZvD+9og@mail.gmail.com>
From: Matteo Grandi <iu5bdp@gmail.com>
Date: Tue, 22 Nov 2016 10:43:00 +0100
Message-ID: <CAHdg3xadDx=+Yc+vPKtyOG6-w-BRa09OyrE_N09p9juipuur0w@mail.gmail.com> (sfid-20161122_104348_582540_9CB5D784)
Subject: Re: ath10k stuck in mesh mode
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Bob Copeland <me@bobcopeland.com>,
        LinuxWireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Bob, Michal, all

I've finally managed to have a 80MHz channel bandwidth, thanks to your hint!
The problem was related to the CRDA that even if it looks correctly
installed, it actually doesn't work as supposed.
I downloaded and recompiled the CRDA-3.18
(http://drvbp1.linux-foundation.org/~mcgrof/rel-html/crda/) and set-up
the regulatory domain.
Notice that without setting up the reg. domain all the available
channels have the "passive scanning" label because the CRDA prevent
beaconing so mesh mode is not possible (maybe it's otherwise possible
to operate in STA mode that doesn't require to send frames(?)).

Now I can have a mesh communication using 80MHz channel bandwidth, but
MIMO still doesn't work.
In fact the highest MCS reached was MCS9 that is the highest MCS with
Single Spatial Stream, and I can't managed to have MIMO.
I played with the antennas position and distance, with the
polarization and the presence or not of LOS, but by sniffing the
transmissions I sow only MCS9 even if in the radiotap header field
there are Antenna 0 and Antenna 1.
However the radio information field report "Spatial streams: 1".

Does anyone experienced something similar with the use of MIMO in mesh
mode with the ath10k fw?
I will thank any light you can shed to this!
Thank you very much

Best Regards

Matteo

2016-11-21 13:53 GMT+01:00 Matteo Grandi <iu5bdp@gmail.com>:
> Yes, I noticed it, in fact it seems to be the reg. domain of the ath9k
> (there is also an ath9k card plugged on the same board).
> But it is in contrast with what I found in the syslog:
>
> Nov 21 07:53:23 MrProper kernel: [    9.591563] ath: Regpair used: 0x3a
> Nov 21 07:53:23 MrProper kernel: [    9.591573] cfg80211: Updating
> information on frequency 5180 MHz with regulatory rule:
> Nov 21 07:53:23 MrProper kernel: [    9.591581] cfg80211: (5140000 KHz
> - 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
> [...]
> - 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
> Nov 21 07:53:23 MrProper kernel: [    9.591654] cfg80211: Updating
> information on frequency 5300 MHz with regulatory rule:
> Nov 21 07:53:23 MrProper kernel: [    9.591661] cfg80211: (5140000 KHz
> - 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm)
> Nov 21 07:53:23 MrProper kernel: [    9.591668] cfg80211: Updating
> information on frequency 5320 MHz with regulatory rule:
> Nov 21 07:53:23 MrProper kernel: [    9.591675] cfg80211: (5140000 KHz
> - 5360000 KHz @ 80000 KHz), (N/A, 3000 mBm
>
> where there are @80MHz frequency slots.
>
> Is it possible that the system, showing all these different reg.
> domains from different cards, chose the most constrained one?
>
> 2016-11-21 11:53 GMT+01:00 Michal Kazior <michal.kazior@tieto.com>:
>> On 21 November 2016 at 10:46, Matteo Grandi <iu5bdp@gmail.com> wrote:
>>> Dear Bob, Michal, all,
>>>
>>> I've just tried your advices (actually I already tried it following
>>> the wireless.wiki.kernel web pages) and I had a look at the syslog
>>> while I was typing the commands
>>> At the beginning I have this
>> [...]
>>> Other (hopefully) useful info:
>>> root@MrProper:~# iw reg get
>>> global
>>> country US: DFS-UNSET
>>>     (2402 - 2472 @ 40), (3, 27), (N/A)
>>>     (5170 - 5250 @ 40), (3, 17), (N/A)
>>>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>>>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>>>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>>>     (5735 - 5835 @ 40), (3, 30), (N/A)
>>>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>>>
>>> phy#2
>>> country US: DFS-UNSET
>>>     (2402 - 2472 @ 40), (3, 27), (N/A)
>>>     (5170 - 5250 @ 40), (3, 17), (N/A)
>>>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>>>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>>>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>>>     (5735 - 5835 @ 40), (3, 30), (N/A)
>>>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>>>
>>> phy#0
>>> country US: DFS-UNSET
>>>     (2402 - 2472 @ 40), (3, 27), (N/A)
>>>     (5170 - 5250 @ 40), (3, 17), (N/A)
>>>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>>>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>>>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>>>     (5735 - 5835 @ 40), (3, 30), (N/A)
>>>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>>>
>>> phy#1
>>> country US: DFS-UNSET
>>>     (2402 - 2472 @ 40), (3, 27), (N/A)
>>>     (5170 - 5250 @ 40), (3, 17), (N/A)
>>>     (5250 - 5330 @ 40), (3, 20), (0 ms), DFS
>>>     (5490 - 5600 @ 40), (3, 20), (0 ms), DFS
>>>     (5650 - 5710 @ 40), (3, 20), (0 ms), DFS
>>>     (5735 - 5835 @ 40), (3, 30), (N/A)
>>>     (57240 - 63720 @ 2160), (N/A, 40), (N/A)
>>>[...]
>>>
>>> Checking on Internet I didn't find a working solution, and the data
>>> rate stucks to 120Mbps MCS7.
>>> For me it still a mistery, I hope in your help.
>>
>> Note the "@ 40" for all frequency ranges (except 60GHz band). Your
>> regulatory database seems to be limiting you to 40 MHz (it's probably
>> very old/ out of date). You'll need to update it to be able to use 80
>> MHz.
>>
>>
>> Michal
