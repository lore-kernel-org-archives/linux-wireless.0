Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:44100 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423640AbeCBTN4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 14:13:56 -0500
Received: by mail-wr0-f175.google.com with SMTP id v65so11137833wrc.11
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 11:13:55 -0800 (PST)
Date: Fri, 2 Mar 2018 20:13:34 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Daniel Golle <daniel@makrotopia.org>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20180301153006.GJ1233@makrotopia.org>
Message-ID: <alpine.LNX.2.21.99.1803022007260.22404@mStation.localdomain> (sfid-20180302_202118_117622_FC982444)
References: <alpine.LNX.2.21.99.1712201848250.21776@localhost.localdomain> <20171221142558.GB4655@redhat.com> <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain> <20180103113540.GA10306@redhat.com> <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com> <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain> <20180123132234.GC2520@redhat.com> <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain> <20180124100316.GB3101@redhat.com>
 <20180301153006.GJ1233@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello to all of you.
I would be very happy if this problem could be sorted out.
But I should be honest: when the only possibility seemd to run a git bisect on openwrt,I was discouraged.
too many builds, and some patching would be needed if you consider that this thing worked with 3.9 kernel or something like that, and I might be wrong (i.e.: it could be 3.6 or something).
That's why I actually didn't start this - sorry to all guys.
Stanislaw's help has been greatly apreciated, and invaluable.
The problem seems to verify differently depending on the card: on an MT7620A-based SOC, namely the TP-LINK Archer MR200, the error occurs but seems not to get the card stuck.
Different story is for the wireless NIC found in the Asus WL-330N3G device.
The circumnstances on which the problem verifies itself are not clear to me. Still, it would be very importantto get this solved, due to the mainstream presence of the hardware itself.
I don't have so many wi-fi clients here: the iPhone still has been a good tool to cause some problems.
I am available for code testing. As some of you will already know, I may be slow on responding and testing overall, and having the problem verify can take some time.
Still, I am available.

Thank you for your work, time and patience.
On Thu, 1 Mar 2018, Daniel Golle wrote:

> Date: Thu, 1 Mar 2018 16:30:10
> From: Daniel Golle <daniel@makrotopia.org>
> To: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
>     Tom Psyborg <pozega.tomislav@gmail.com>,
>     linux-wireless <linux-wireless@vger.kernel.org>,
>     Johannes Berg <johannes.berg@intel.com>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
>     Jamie Stuart <jamie@onebillion.org>
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>     frame due to full tx queue...?
> 
> [forwarding to all other involved players]
>
> On Thu, Mar 01, 2018 at 05:50:51PM +0300, Jamie Stuart wrote:
>> Hi Daniel,
>> The driver seems much improved after this fix.
>
> it's about those two
> [PATCH 1/2] rt2x00: pause almost full queue early
> [PATCH 2/2] rt2x00: do not pause queue unconditionally on error path
>
>> Under very heavy load (30 clients downloading multi-GB files from SD card on the server concurrently), wifi dies with errors:
>>
>> [ 7794.230376] ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010c, type=4
>>
>> Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
>> Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] Please file bug report to http://rt2x00.serialmonkey.com
>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] Please file bug report to http://rt2x00.serialmonkey.com
>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] Please file bug report to http://rt2x00.serialmonkey.com
>>
>>
>>> On 20 Dec 2017, at 06:00, Daniel Golle <daniel@makrotopia.org> wrote:
>>>
>>> Hi Jamie,
>>>
>>> there was another round of discussion regarding the queue management
>>> problem and Stanislaw Gruszka (the main rt2x00 maintainer) suggested
>>> two patches which would be a more correct fix for the
>>> rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue
>>> message and consecutive problems.
>>>
>>> I imported them to my staging tree. Please retest and join the
>>> discussion on
>>> https://wireless.wiki.kernel.org/en/developers/mailinglists#linux-wireless_online_archives
>>> see posts
>>> https://marc.info/?l=linux-wireless&m=151368325114059&w=2
>>> https://marc.info/?l=linux-wireless&m=151368325914062&w=2
>>> and
>>> https://marc.info/?l=linux-wireless&m=151368992716169&w=2
>>>
>>>
>>> Cheers
>>>
>>>
>>> Daniel
>>>
>>>
>
