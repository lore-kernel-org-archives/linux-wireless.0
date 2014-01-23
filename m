Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:42480 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaAWJfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:35:02 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Thu, 23 Jan 2014 09:34:59 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C3A05@ALA-MBB.corp.ad.wrs.com> (sfid-20140123_103517_029724_19C21DD7)
References: <52DF947E.40800@gmail.com>
 <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
 <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
 <52E0BA40.7090203@gmail.com>
 <CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>
 <52E0D7D5.6060504@gmail.com>
 <CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>
 <CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C3931@ALA-MBB.corp.ad.wrs.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C3977@ALA-MBB.corp.ad.wrs.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C39A2@ALA-MBB.corp.ad.wrs.com>
 <CANUX_P16BOvf9XDH41u8exNAQyyn2dKkPdN3kOBB+9N5Pu8T2Q@mail.gmail.com>,<CABPxzYLJwyXA+XZ+nHzoCZrSo99joTfhP7iQUbWMfcw403H_WA@mail.gmail.com>
In-Reply-To: <CABPxzYLJwyXA+XZ+nHzoCZrSo99joTfhP7iQUbWMfcw403H_WA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

But very pity, when running on the AP mode:wlan0     IEEE 802.11abgn  is the same....

~# iwconfig wlan0
wlan0     IEEE 802.11abgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Krishna Chaitanya [chaitanya.mgit@gmail.com]
Sent: Thursday, January 23, 2014 5:29 PM
To: Emmanuel Grumbach
Cc: Liu, Bopeng; zhuyj; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 2:57 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Thu, Jan 23, 2014 at 11:21 AM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
>>
>>
>> So,it that mean: there is no way to fix this problem by modify the kernel and driver codes?
> Yes
>
>>
>> Though #iwconfig wlan0 shows there is modes a ?
>
> In client mode - not in AP mode
>>
Well in Us channel 149/36 is a valid channel for AP operation. So ideally
it should work? Is there any specific feature blocking such in iwlwifi?

can you try building iwlwifi with CONFIG_IWLWIFI_DEBUG from make menuconfig?
It prints out the reg rules it read from eeprom? Also please post the
full dmesg.

>> iwconfig wlan0
>> wlan0     IEEE 802.11abgn  ESSID:"IDPDK-169c"
>>           Mode:Managed  Frequency:2.462 GHz  Access Point: A0:88:B4:1E:16:9C
>>           Bit Rate=1 Mb/s   Tx-Power=15 dBm
>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>           Encryption key:off
>>           Power Management:off
>>           Link Quality=60/70  Signal level=-50 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:0  Invalid misc:14   Missed beacon:0
>>
