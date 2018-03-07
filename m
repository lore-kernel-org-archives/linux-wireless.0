Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34899 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934158AbeCGXaf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 18:30:35 -0500
Received: by mail-wm0-f51.google.com with SMTP id x7so7817198wmc.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2018 15:30:35 -0800 (PST)
Date: Thu, 8 Mar 2018 00:30:31 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Jamie Stuart <jamie@onebillion.org>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <7B51BD3B-CAC3-479B-B06E-637A1C3A678A@onebillion.org>
Message-ID: <alpine.LNX.2.21.99.1803080028590.13982@mStation.localdomain> (sfid-20180308_003040_422858_405B7EF3)
References: <20171221142558.GB4655@redhat.com> <alpine.LNX.2.21.99.1712241311370.28605@localhost.localdomain> <20180103113540.GA10306@redhat.com> <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain> <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain> <20180123132234.GC2520@redhat.com> <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain> <20180124100316.GB3101@redhat.com> <20180301153006.GJ1233@makrotopia.org> <20180307122701.GA10584@redhat.com>
 <7B51BD3B-CAC3-479B-B06E-637A1C3A678A@onebillion.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1255982535-1520465433=:13982"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1255982535-1520465433=:13982
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

Thank you very very much guys for keeping me up to date with the progress, it's important for me.
Even if I am not subscribed to the list.
Thank you for all guys.


On Wed, 7 Mar 2018, Jamie Stuart wrote:

> Date: Wed, 7 Mar 2018 16:47:34
> From: Jamie Stuart <jamie@onebillion.org>
> To: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Daniel Golle <daniel@makrotopia.org>, Enrico Mioso <mrkiko.rs@gmail.com>,
>     Tom Psyborg <pozega.tomislav@gmail.com>,
>     linux-wireless <linux-wireless@vger.kernel.org>,
>     Johannes Berg <johannes.berg@intel.com>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
>     Mathias Kresin <dev@kresin.me>
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>     frame due to full tx queue...?
> 
> Hi Stanis,
>
> Our environment has the following wireless config (MT7620A):
>
> config wifi-device 'radio0'
> 	option type 'mac80211'
> 	option channel 'auto'
> 	option hwmode '11g'
> 	option path 'platform/10180000.wmac'
> 	option txpower '20'
> 	option country 'GB'
> 	option htmode 'HT40'
> 	option noscan '1'
>
> config wifi-iface 'default_radio0'
> 	option device 'radio0'
> 	option network 'lan'
> 	option mode 'ap'
> 	option encryption 'psk2+aes'
> 	option key ‘KEY'
> 	option maxassoc '96'
> 	option ssid ’SSID'
> 	option disassoc_low_ack ‘0'
>
>
> The 30 clients are all Apple iPads (a mixture of iPad mini and mini 2, running iOS 9-11). During this testing period, all clients were simultaneously downloading files from the devices’ sdcard (served via nginx running on the device). Although this is not a typical use-case, it was useful in stress-testing the wireless setup.
>
> We’ll try your patches Stanis.
> Daniel - forgive the stupid question, but how do we apply Stanis’ patches atop your staging tree (or both yours and Stanis’ atop trunk?)
>
>
>
>> On 7 Mar 2018, at 14:27, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>
>> On Thu, Mar 01, 2018 at 04:30:10PM +0100, Daniel Golle wrote:
>>> [forwarding to all other involved players]
>>>
>>> On Thu, Mar 01, 2018 at 05:50:51PM +0300, Jamie Stuart wrote:
>>>> Hi Daniel,
>>>> The driver seems much improved after this fix.
>>>
>>> it's about those two
>>> [PATCH 1/2] rt2x00: pause almost full queue early
>>> [PATCH 2/2] rt2x00: do not pause queue unconditionally on error path
>>>
>>>> Under very heavy load (30 clients downloading multi-GB files from SD card on the server concurrently), wifi dies with errors:
>>
>> This is some testbed? Could you share how did you setup such
>> environment and what are client devices ?
>>
>>>> [ 7794.230376] ieee80211 phy0: rt2x00lib_rxdone_read_signal: Warning - Frame received with unrecognized signal, mode=0x0001, signal=0x010c, type=4
>>
>> This is indicator that HW/FW has a problem. There could be various
>> reasons for that. One possible I can also observe in my setup,is strange
>> mishmash of seq  on frames which were not acked in BlockACK and
>> had to be resent. This can happen when many frames are wrongly decoded
>> (i.e. when there is bad radio condition or we have not correct low level
>> RF/BBP setup for a Ralink device). To mitigate that problem we can
>> limit length of agreggeted AMPDU frame.
>>
>> I attached two patches which do that. One for RX side second for TX side.
>> Please check if they make a diffrent. You can also hardcode ba_size = 0
>> for those 30 clients setup.
>>
>> Note the patches can cause (possibly small) perfromance degradation on
>> good setups.
>>
>> Mathias, could you check them as well and see if they do not cause
>> performance regression on your device ? Lastly when I changed ba_size
>> setting, it was a problem on your setup.
>>
>>>> Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
>>>> Thu Mar  1 16:36:47 2018 kern.err kernel: [ 8702.146403] Please file bug report to http://rt2x00.serialmonkey.com
>>>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
>>>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.288149] Please file bug report to http://rt2x00.serialmonkey.com
>>>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2
>>>> Thu Mar  1 16:36:48 2018 kern.err kernel: [ 8702.380761] Please file bug report to http://rt2x00.serialmonkey.com
>>
>> For those errors I recommend to remove
>>
>> 600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
>>
>> patch. Whould be good if OpenWRT developers could apply this patch only
>> on target where it is really needed, not for all rt2800 devices.
>>
>> Thanks
>> Stanislaw
>
>
--8323329-1255982535-1520465433=:13982--
