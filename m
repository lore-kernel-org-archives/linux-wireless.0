Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34438 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799AbcDFJX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:23:57 -0400
Received: by mail-wm0-f51.google.com with SMTP id l6so56263775wml.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 02:23:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAA5faFt+web-E4-qMW5n3EGDqtG2ZuzJkh+bZYFF_td6Jh91w@mail.gmail.com>
References: <CANfLQrYTqUQGoj+Xr1XrKJrh8oaBB+qt8YeFwo0EyhbC-RpnNg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EAA379D@hasmsx107.ger.corp.intel.com>
	<CANfLQrad-1C3Wzy9M+=J7nzjQOcgam9CdJVDR2KC=KipZRpbkA@mail.gmail.com>
	<CAAA5faFt+web-E4-qMW5n3EGDqtG2ZuzJkh+bZYFF_td6Jh91w@mail.gmail.com>
Date: Wed, 6 Apr 2016 12:23:55 +0300
Message-ID: <CANfLQrY5TwJC_AV9Dy+zRsTy0c6tqza+P7X30jGkBp62ucmx7w@mail.gmail.com> (sfid-20160406_112403_682904_32443901)
Subject: Re: iwlwifi monitor mode: No data frame captured on 5 Ghz
From: Gucea Doru <gucea.doru@gmail.com>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gucea, Doru" <doru.gucea@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2016 at 12:39 AM, Reinoud Koornstra
<reinoudkoornstra@gmail.com> wrote:
> On Tue, Apr 5, 2016 at 7:25 AM, Gucea Doru <gucea.doru@gmail.com> wrote:
>> On Tue, Apr 5, 2016 at 1:00 PM, Grumbach, Emmanuel
>> <emmanuel.grumbach@intel.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> I am trying to capture packets that are exchanged between an AP and a
>>>> smartphone on the 5Ghz frequency. For generating traffic, I upload UDP
>>>> traffic from a laptop PC towards the smartphone using iperf.
>>>>
>>>> The problem is that I can see _only_ the control frames like RTS/CTS, Block
>>>> ACK, while the data packets are not captured. I uploaded the Wireshark
>>>> capture files at [1] (located inside the folders whose name starts with 5Ghz).
>>>
>>> Most likely the packets on A band have a VHT preamble and your SKU is 11N only.
>>
>> My card, Intel 7260 [1]  supports 802.11 ac. So it should also support
>> VHT, right? Is there any interface in user-space for checking after
>> VHT?
>>
>> However, I noticed a "failure" message in dmesg:
>> [    4.030428] Intel(R) Wireless WiFi driver for Linux, in-tree:
>> [    4.030570] iwlwifi 0000:04:00.0: irq 37 for MSI/MSI-X
>> [    4.030760] iwlwifi 0000:04:00.0: Direct firmware load for
>> iwlwifi-7260-10.ucode failed with error -2
>> [    4.035509] iwlwifi 0000:04:00.0: loaded firmware version
>> 25.228.9.0 op_mode iwlmvm
>> [    4.454772] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
>> Wireless N 7260, REV=0x144
>> [    4.454825] iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
>> [    4.455055] iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
>> [   15.049933] iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
>> [   15.050269] iwlwifi 0000:04:00.0: L1 Disabled - LTR Enabled
>
> The ucode failure isn't a problem, you'll likely find that another
> firmware does load.
> I've got also a 7620, but mine does support 11ac, so mine does support VHT.
>
> [    9.820637] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
>
> I also got a firmware load failure, but that's ok
>
> [    8.399101] iwlwifi 0000:04:00.0: Direct firmware load for
> iwlwifi-7260-17.ucode failed with error -2
>
> Cause here it does load the one it needs:
>
> [    9.110486] iwlwifi 0000:04:00.0: loaded firmware version
> 16.242414.0 op_mode iwlmvm
>
> I did fetch recent firmware by git to be up to date.
> I also added some instrumentation to get to see the unsupported splx
> structure and in my case it's just because of the package.count isn't
> what it should be.
> This isn't a problem as well really.
>
> Mar 14 00:32:36 router-dev kernel: [    8.273274] iwlwifi
> 0000:04:00.0: Unsupported splx structure
> Mar 14 00:32:36 router-dev kernel: [    8.273276] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: splx->type is 0x04
> Mar 14 00:32:36 router-dev kernel: [    8.273277] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: splx->package.count is 4
> Mar 14 00:32:36 router-dev kernel: [    8.273277] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: splx->package.elements[0].type is 0x01
> Mar 14 00:32:36 router-dev kernel: [    8.273278] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: splx->package.elements[0].integer.value is 0
> Mar 14 00:32:36 router-dev kernel: [    8.273279] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: limits->type is 0x04
> Mar 14 00:32:36 router-dev kernel: [    8.273280] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: limits->package.count is 3
> Mar 14 00:32:36 router-dev kernel: [    8.273281] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: limits->package.elements[0].type is 0x01
> Mar 14 00:32:36 router-dev kernel: [    8.273281] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: limits->package.elements[1].type is 0x01
> Mar 14 00:32:36 router-dev kernel: [    8.273282] iwlwifi
> 0000:04:00.0: drivers/net/wireless/iwlwifi/pcie/drv.c,
> splx_get_pwr_limit: WiFi power is not limited,
> domain_type->integer.value is 0
>
> I compiled wpa_supplicant and it connects without trouble to several
> access points.
> I mostly do it this way, because I maintain the mtk driver I use in
> the access point here so I get to see extensive info from both sides
> when things go pearshape. :)
>

Thanks a lot for your support: as Emmanuel pointed out the problem
comes from my Wi-Fi flavour card.

>>
>> Also, the maximum bit rate reported by iwconfig is 150 Mb/s, so my
>> assumption is that the card can't enter into the 802.11 ac mode, it
>> just stays into 802.11n.
>>
>> doru@doru-N551JK:~$ iwconfig wlan0
>> wlan0     IEEE 802.11abgn  ESSID:"5_mptcp"
>>           Mode:Managed  Frequency:5.24 GHz  Access Point: C4:6E:1F:4B:10:A2
>>           Bit Rate=150 Mb/s   Tx-Power=22 dBm
>>           Retry short limit:7   RTS thr:off   Fragment thr:off
>>           Power Management:on
>>           Link Quality=70/70  Signal level=-36 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:22   Missed beacon:0
>>
>>
>> [1] http://www.intel.com/content/www/us/en/wireless-products/dual-band-wireless-ac-7260-bluetooth-brief.html
>>
>>> Another option is that the traffic uses LDPC encoding and this device doesn't support it.
>>>
>>>
>>>>
>>>> If I use the 2.4 frequency, all the frames are captured. I also uploaded the
>>>> Wireshark packet traces for 2.4Ghz at [1] (located inside the folders whose
>>>> name starts with 2.4 Ghz).
>>>>
>>>> Is this a known bug or am I doing something wrong?
>>>>
>>>> Additional details:
>>>> Wi-Fi card:  iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless N 7260,
>>>> REV=0x144 Firmware version: iwlwifi 0000:04:00.0: loaded firmware version
>>>> 25.228.9.0 op_mode iwlmvm
>>>> Traffic encryption: WPA & WPA2 Personal
>>>> Setting up the card in wireless mode:
>>>> ip link set dev wlan0 down
>>>> iw wlan0 set type monitor
>>>> ip link set dev wlan0 up
>>>> iw wlan0 set freq 5240
>>>>
>>>> [1] https://drive.google.com/open?id=0B5SBH08PU_Chek9rOHY0VkxFRUE
>>>>
>>>> Thank you, Doru
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
