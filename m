Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34680 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbbEKLIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 07:08:32 -0400
Received: by wgic8 with SMTP id c8so98005979wgi.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 04:08:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
Date: Mon, 11 May 2015 13:08:31 +0200
Message-ID: <CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com> (sfid-20150511_130836_977364_4F17A50D)
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: Michal Kazior <michal.kazior@tieto.com>
To: s prasad <sprasad.kandregula@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2015 at 12:51, s prasad <sprasad.kandregula@gmail.com> wrote:
> Hi,
>
> On Mon, May 11, 2015 at 1:50 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 10 May 2015 at 22:56, s prasad <sprasad.kandregula@gmail.com> wrote:
>>> Hi,
>>>
>>> When we are trying to send De-authentication  packets using
>>> aireplay-ng(aircrack tools) firmware getting crashed in sniffer mode.
>>>
>>> Kernel: "3.18.1"
>>> Drivers: "compat-wireless-2015-03-09"
>>>
>>> Please find given below logs:
>>>
>>> [791495.150000] ath10k_pci: Unknown symbol ath10k_warn (err 0)
>>> [791495.160000] ath10k_pci: Unknown symbol ath10k_err (err 0)
>>> [791495.170000] ath10k_pci: Unknown symbol ath10k_print_driver_info (err 0)
>>> [791495.170000] ath10k_pci: Unknown symbol
>>> ath10k_debug_get_new_fw_crash_data (err 0)
>>> [791495.180000] ath10k_pci: Unknown symbol ath10k_core_create (err 0)
>>> [791495.190000] ath10k_pci: Unknown symbol ath10k_core_destroy (err 0)
>>> [791495.190000] ath10k_pci: Unknown symbol ath10k_core_register (err 0)
>>> [791495.200000] ath10k_pci: Unknown symbol ath10k_info (err 0)
>>> [791495.210000] ath10k_pci: Unknown symbol ath10k_core_unregister (err 0)
>>> [791504.600000] ath10k_pci 0000:01:00.0: pci irq legacy interrupts 0
>>> irq_mode 0 reset_mode 0
>>> [791504.820000] ath10k_pci 0000:01:00.0: Direct firmware load for
>>> ath10k/cal-pci-0000:01:00.0.bin failed with error -2
>>> [791504.830000] ath10k_pci 0000:01:00.0: Falling back to user helper
>>> [791504.900000] firmware ath10k!cal-pci-0000:01:00.0.bin:
>>> firmware_loading_store: map pages failed
>>> [791505.060000] ath10k_pci 0000:01:00.0: otp stream is empty, using
>>> board.bin contents
>>
>> You're probably using OpenWRT, aren't you? Are you positive you have
>> proper board.bin, i.e. based of NAND flash partition containing
>> calibration data?
>>
>>
>
> Yes I am using OpenWrt
> I got board.bin from the following git path:
> https://github.com/kvalo/ath10k-firmware/tree/master/ath10k/QCA988X/hw2.0/
>
> About board.bin, checked md5sum of both OpenWrt and from above git
> path, both have same md5sum.

This is the wrong way to do it. You're using your card without correct
calibration data. No wonder it crashes. I bet you have a
00:03:07:12:34:56 mac address on your ath10k wlan interface.

You need to extract board.bin from NAND flash of the router you have.
OpenWRT does this automatically for some devices (e.g. TP-Link Archer
C5/C7) as far as I know. You should either allow OpenWRT to extract
the file itself (probably deleting the existing board.bin and
rebooting the system) or look at script responsible for that and do it
yourself.


>>> [791505.910000] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
>>> 0x043202ff) fw 10.1.467.2-1 api 4 htt 2.1 wmi 2 cal otp max_sta 128
>>> [791505.920000] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
>>> dfs 1 testmode 1
>>> [791506.030000] ath: EEPROM regdomain: 0x0
>>> [791506.030000] ath: EEPROM indicates default country code should be used
>>> [791506.030000] ath: doing EEPROM country->regdmn map search
>>> [791506.030000] ath: country maps to regdmn code: 0x3a
>>> [791506.030000] ath: Country alpha2 being used: US
>>> [791506.030000] ath: Regpair used: 0x3a
>>> [791551.530000] ath10k_pci 0000:01:00.0: otp stream is empty, using
>>> board.bin contents
>>> [791718.130000] device wlan1 entered promiscuous mode
>>> [791718.340000] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
>>> b4593209-111f-446c-a134-120ce3b2e37d)
>>> [791718.350000] ath10k_pci 0000:01:00.0: qca988x hw2.0 (0x4100016c,
>>> 0x043202ff) fw 10.1.467.2-1 api 4 htt 2.1 wmi 2 cal otp max_sta 128
>>> [791718.360000] ath10k_pci 0000:01:00.0: debug 0 debugfs 1 tracing 0
>>> dfs 1 testmode 1
>> [...]
>>> Please let me know if any further information required.
>>
>> Can you get debug logs or traces, please?
>>
>
> Sure, will send them, If possible may I know how to enable debug logs or traces.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/debug#tracing

>From the driver info string it looks you'll need to recompile the driver.


>> Does 10.2-00082 or 10.2.4.xx crash as well?
>
> Will check and let you know.

Before you start getting traces or testing 10.2 firmware make sure you
fix your board.bin first, please.


Michał
