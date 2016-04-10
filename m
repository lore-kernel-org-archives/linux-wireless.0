Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33244 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbcDJJDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 05:03:24 -0400
Received: by mail-wm0-f44.google.com with SMTP id f198so109838035wme.0
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2016 02:03:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459863253.21527.2.camel@intel.com>
References: <CANfLQrYTqUQGoj+Xr1XrKJrh8oaBB+qt8YeFwo0EyhbC-RpnNg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EAA379D@hasmsx107.ger.corp.intel.com>
	<CANfLQrad-1C3Wzy9M+=J7nzjQOcgam9CdJVDR2KC=KipZRpbkA@mail.gmail.com>
	<1459863253.21527.2.camel@intel.com>
Date: Sun, 10 Apr 2016 12:03:22 +0300
Message-ID: <CANfLQrbjCYaVa7-pq3xxPhmjM+MY5ky-isV7+yYLLFVkDCMr2Q@mail.gmail.com> (sfid-20160410_110817_325747_9999BD88)
Subject: Re: iwlwifi monitor mode: No data frame captured on 5 Ghz
From: Gucea Doru <gucea.doru@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gucea, Doru" <doru.gucea@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 5, 2016 at 4:34 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
> On Tue, 2016-04-05 at 16:25 +0300, Gucea Doru wrote:
>> On Tue, Apr 5, 2016 at 1:00 PM, Grumbach, Emmanuel
>> <emmanuel.grumbach@intel.com> wrote:
>> > >
>> > > Hello,
>> > >
>> > > I am trying to capture packets that are exchanged between an AP
>> > > and a
>> > > smartphone on the 5Ghz frequency. For generating traffic, I
>> > > upload UDP
>> > > traffic from a laptop PC towards the smartphone using iperf.
>> > >
>> > > The problem is that I can see _only_ the control frames like
>> > > RTS/CTS, Block
>> > > ACK, while the data packets are not captured. I uploaded the
>> > > Wireshark
>> > > capture files at [1] (located inside the folders whose name
>> > > starts with 5Ghz).
>> >
>> > Most likely the packets on A band have a VHT preamble and your SKU
>> > is 11N only.
>>
>> My card, Intel 7260 [1]  supports 802.11 ac. So it should also
>> support
>> VHT, right? Is there any interface in user-space for checking after
>> VHT?
>
> 7260 has several flavors. The one you have doesn't support VHT:
>> iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless N 7260
>
> Dual Band means you have support for 5.2GHz, but Wireless N, means no
> VHT.

One of my colleagues had an Intel 7260 AC card so I repeated the experiments:
- if I set the channel width to 20Mhz from the AP and the monitor
interface using the command iw wlan0 set freq 5240 HT20+ I can see
data frames and the Block ACKs for these frames;
- if I set the channel width to 40Mhz from the AP and the monitor
interface using the command iw wlan0 set freq 5240 HT40- I can see
data frames and the Block ACKs for these frames;
- If I set the channel width to 80Mhz from the AP I don't how to set
up the monitor interface. I tried with iw wlan0 set freq 5240 HT40+
but it tells me that the argument is invalid.

Is the iwlwifi driver capable of capturing data frames when the
channel bonding is set to 80Mhz?

>
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
>>
>> Also, the maximum bit rate reported by iwconfig is 150 Mb/s, so my
>> assumption is that the card can't enter into the 802.11 ac mode, it
>> just stays into 802.11n.
>>
>> doru@doru-N551JK:~$ iwconfig wlan0
>> wlan0     IEEE 802.11abgn  ESSID:"5_mptcp"
>>           Mode:Managed  Frequency:5.24 GHz  Access Point:
>> C4:6E:1F:4B:10:A2
>>           Bit Rate=150 Mb/s   Tx-Power=22 dBm
>>           Retry short limit:7   RTS thr:off   Fragment thr:off
>>           Power Management:on
>>           Link Quality=70/70  Signal level=-36 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:22   Missed beacon:0
>>
>>
>> [1] http://www.intel.com/content/www/us/en/wireless-products/dual-ban
>> d-wireless-ac-7260-bluetooth-brief.html
>>
>> > Another option is that the traffic uses LDPC encoding and this
>> > device doesn't support it.
>> >
>> >
>> > >
>> > > If I use the 2.4 frequency, all the frames are captured. I also
>> > > uploaded the
>> > > Wireshark packet traces for 2.4Ghz at [1] (located inside the
>> > > folders whose
>> > > name starts with 2.4 Ghz).
>> > >
>> > > Is this a known bug or am I doing something wrong?
>> > >
>> > > Additional details:
>> > > Wi-Fi card:  iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
>> > > Wireless N 7260,
>> > > REV=0x144 Firmware version: iwlwifi 0000:04:00.0: loaded firmware
>> > > version
>> > > 25.228.9.0 op_mode iwlmvm
>> > > Traffic encryption: WPA & WPA2 Personal
>> > > Setting up the card in wireless mode:
>> > > ip link set dev wlan0 down
>> > > iw wlan0 set type monitor
>> > > ip link set dev wlan0 up
>> > > iw wlan0 set freq 5240
>> > >
>> > > [1] https://drive.google.com/open?id=0B5SBH08PU_Chek9rOHY0VkxFRUE
>> > >
>> > > Thank you, Doru
