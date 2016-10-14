Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36346 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932245AbcJNGl6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 02:41:58 -0400
Received: by mail-lf0-f47.google.com with SMTP id b75so179054746lfg.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 23:41:57 -0700 (PDT)
Subject: Re: BCM43602 firmware reports multiple BRCMF_E_DEAUTH
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
References: <CACna6rzS4nDZ+H5kU71WwTTNLp5uZStpQHv4LLmWBDSdf5jpyw@mail.gmail.com>
 <f97678dc-2869-1b6a-33a3-f829cc30918a@gmail.com>
 <90e69e94-2210-22ec-3aec-67d9605b4b7c@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <b395146e-1917-e8d7-04e6-5d544f17531e@gmail.com> (sfid-20161014_084202_394031_9BE2FA0E)
Date: Fri, 14 Oct 2016 08:33:41 +0200
MIME-Version: 1.0
In-Reply-To: <90e69e94-2210-22ec-3aec-67d9605b4b7c@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2016 11:08 AM, Arend Van Spriel wrote:
> On 4-10-2016 20:15, Rafał Miłecki wrote:
>> On 09/28/2015 11:00 AM, Rafał Miłecki wrote:
>>> I'm using recent brcmfmac and brcmfmac43602-pcie.ap.bin that currently
>>> sits in linux-firmware.git.
>>>
>>> In OpenWrt we have hostapd with a feature of banning STAs. It works in
>>> a quite simple way. Whenever hostapd gets NL80211_CMD_NEW_STATION for
>>> STA that is banned it sends NL80211_CMD_DEL_STATION.
>>>
>>> The problem is that in such case BCM43602 firmware happens to randomly
>>> send more than 1 BRCMF_E_DEAUTH event. It seems it can send random
>>> amount between 1 and 3. Looks a bit like some kind of race. It's
>>> nothing really critical, just makes hostapd log a bit confusing.
>>>
>>> Could someone at Broadcom look at firmware source to see if you can
>>> fix this, please?
>>
>> Hey, I didn't get any reply on this for a year. I just saw similar
>> problem with
>> BCM4366. Below you will find a nice log with my extra comments.
>>
>> Could take a look at this issue this time, please?
>
> Can try.

Thank you and sorry for my late reply! I'm back home now ready to provide any
extra details.


>> I think it may be another problem related to the A-MPDU thing (bug?) I
>> reported
>> in "AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs" e-mail
>> thread.
>
> So what firmware version do you have? A colleague pointed me to firmware
> fix that may be related so I want to know the target string to build.
> Firmware version is in the bin file:
>
> $ hexdump -C fw.bin | tail -40

Well, I am pretty sure I was using the one released by Broadcom. Also my only
device with 4366b1 is DIR-885L. Once I was looking for 4366c0 firmware as
described in the kernel's bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=135321
but I don't think I replaced them or anything.

Anyway, I repeated my tests paying attention to the firmware file. I'm pretty
sure it's the same one you can find in:
https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/brcm/brcmfmac4366b-pcie.bin

root@lede:/# md5sum /lib/firmware/brcm/brcmfmac4366b-pcie.bin
596f13d84e0042035cdb41202cfc385a  /lib/firmware/brcm/brcmfmac4366b-pcie.bin

root@lede:/# hexdump -C /lib/firmware/brcm/brcmfmac4366b-pcie.bin | tail -40
000f1670  40 00 03 07 07 07 40 00  03 07 07 07 40 00 03 07  |@.....@.....@...|
000f1680  07 07 40 00 72 61 74 65  73 65 6c 00 73 74 66 00  |..@.ratesel.stf.|
000f1690  63 63 6b 5f 6f 6e 65 63  6f 72 65 5f 74 78 00 74  |cck_onecore_tx.t|
000f16a0  65 6d 70 73 5f 70 65 72  69 6f 64 00 74 78 63 68  |emps_period.txch|
000f16b0  61 69 6e 00 72 78 63 68  61 69 6e 00 4d cc 07 00  |ain.rxchain.M...|
000f16c0  69 44 26 00 71 c9 07 00  91 c6 07 00 2d e9 ff 41  |iD&.q.......-..A|
000f16d0  80 46 4f f4 40 70 0d 46  17 46 1e 46 1f f5 4c ff  |.FO.@p.F.F.F..L.|
000f16e0  04 46 48 b9 28 46 1f f5  4d ff 02 46 23 49 24 48  |.FH.(F..M..F#I$H|
000f16f0  13 f7 24 fb 1e 20 3e e0  00 21 4f f4 40 72 12 f5  |..$.. >..!O.@r..|
000f1700  9d fd 0a 9b 40 46 00 93  04 f1 f8 03 01 93 04 f1  |....@F..........|
000f1710  fc 03 02 93 29 46 3a 46  33 46 e0 f7 5f fa c4 f8  |....)F:F3F.._...|
000f1720  f4 00 28 b9 17 48 15 49  0b 25 13 f7 07 fb 1e e0  |..(..H.I.%......|
000f1730  00 22 40 f6 12 01 00 25  22 f5 26 fb c4 f8 00 01  |."@....%".&.....|
000f1740  40 f6 12 01 d4 f8 f4 00  22 f5 06 fa c4 f8 e8 00  |@.......".......|
000f1750  20 46 51 f7 8d fb 0c 21  00 22 20 46 51 f7 94 fb  | FQ....!." FQ...|
000f1760  20 46 4d f7 69 f8 d4 f8  f4 00 df f7 d1 fe 20 46  | FM.i......... F|
000f1770  1f f5 16 ff 28 46 04 b0  bd e8 f0 81 88 17 2f 00  |....(F......../.|
000f1780  97 1b 2a 00 e2 f1 29 00  77 6c 63 5f 62 6d 61 63  |..*...).wlc_bmac|
000f1790  5f 70 72 6f 63 65 73 73  5f 75 63 6f 64 65 5f 73  |_process_ucode_s|
000f17a0  72 00 00 00 84 73 3b b4  0a 0a 45 ed 3d 22 90 56  |r....s;...E.=".V|
000f17b0  00 00 07 00 00 00 00 00  00 00 00 00 00 00 00 a4  |................|
000f17c0  91 7a c4 13 01 bd 32 08  01 00 34 33 36 36 62 31  |.z....2...4366b1|
000f17d0  2d 72 6f 6d 6c 2f 70 63  69 65 2d 61 67 2d 73 70  |-roml/pcie-ag-sp|
000f17e0  6c 69 74 72 78 2d 66 64  61 70 2d 6d 62 73 73 2d  |litrx-fdap-mbss-|
000f17f0  6d 66 70 2d 77 6e 6d 2d  6f 73 65 6e 2d 77 6c 31  |mfp-wnm-osen-wl1|
000f1800  31 6b 2d 77 6c 31 31 75  2d 74 78 62 66 2d 70 6b  |1k-wl11u-txbf-pk|
000f1810  74 63 74 78 2d 61 6d 73  64 75 74 78 2d 61 6d 70  |tctx-amsdutx-amp|
000f1820  64 75 72 65 74 72 79 2d  63 68 6b 64 32 68 64 6d  |duretry-chkd2hdm|
000f1830  61 2d 70 72 6f 70 74 78  73 74 61 74 75 73 2d 31  |a-proptxstatus-1|
000f1840  31 6e 70 72 6f 70 2d 6f  62 73 73 2d 64 62 77 73  |1nprop-obss-dbws|
000f1850  77 2d 72 69 6e 67 65 72  2d 64 6d 61 69 6e 64 65  |w-ringer-dmainde|
000f1860  78 31 36 2d 62 67 64 66  73 20 56 65 72 73 69 6f  |x16-bgdfs Versio|
000f1870  6e 3a 20 31 30 2e 31 30  2e 36 39 2e 32 33 37 20  |n: 10.10.69.237 |
000f1880  43 52 43 3a 20 34 62 63  34 38 63 37 62 20 44 61  |CRC: 4bc48c7b Da|
000f1890  74 65 3a 20 46 72 69 20  32 30 31 36 2d 30 31 2d  |te: Fri 2016-01-|
000f18a0  30 38 20 31 32 3a 35 35  3a 32 35 20 50 53 54 20  |08 12:55:25 PST |
000f18b0  55 63 6f 64 65 20 56 65  72 3a 20 31 30 37 33 2e  |Ucode Ver: 1073.|
000f18c0  35 33 31 20 46 57 49 44  3a 20 30 31 2d 63 34 37  |531 FWID: 01-c47|
000f18d0  61 39 31 61 34 0a 00 0d  01                       |a91a4....|
000f18d9

And there is a log using that very firmware I verified above.

# I got some timeouts, this time without ampdu_dbg or wlc_ampdu_watchdog
Fri Oct 14 06:09:07 2016 kern.err kernel: [  437.579199] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
Fri Oct 14 06:09:08 2016 kern.err kernel: [  438.529199] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets

# Firmware sends BRCMF_E_DEAUTH and BRCMF_E_DISASSOC_IND events.
# My smartphone never receives deauth/disassoc and it believes it's still
# connected to the AP.
Fri Oct 14 06:09:12 2016 kern.debug kernel: [  442.276363] brcmfmac: CONSOLE: 027172.113 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
Fri Oct 14 06:09:12 2016 kern.err kernel: [  442.276405] brcmfmac: brcmf_notify_connect_status_ap: event 5, reason 3
Fri Oct 14 06:09:12 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Fri Oct 14 06:09:12 2016 kern.err kernel: [  442.276447] brcmfmac: brcmf_notify_connect_status_ap: event 5, reason 3
Fri Oct 14 06:09:12 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated

# My smartphone starts sending packets. Firmware reacts by sending
# BRCMF_E_DEAUTH events to the driver.
Fri Oct 14 06:10:57 2016 kern.err kernel: [  547.213534] brcmfmac: brcmf_notify_connect_status_ap: event 5, reason 7
Fri Oct 14 06:10:57 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Fri Oct 14 06:10:57 2016 kern.err kernel: [  547.321590] brcmfmac: brcmf_notify_connect_status_ap: event 5, reason 7
Fri Oct 14 06:10:57 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
Fri Oct 14 06:10:57 2016 kern.err kernel: [  547.321918] brcmfmac: brcmf_notify_connect_status_ap: event 5, reason 7
Fri Oct 14 06:10:57 2016 daemon.info hostapd: wlan1-1: STA 78:d6:f0:9b:ba:bc IEEE 802.11: disassociated
