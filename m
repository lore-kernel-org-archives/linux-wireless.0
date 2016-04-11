Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34384 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbcDKUEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 16:04:23 -0400
Received: by mail-wm0-f66.google.com with SMTP id n3so111338wmn.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 13:04:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EACFDF2@hasmsx107.ger.corp.intel.com>
References: <CANfLQrYTqUQGoj+Xr1XrKJrh8oaBB+qt8YeFwo0EyhbC-RpnNg@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EAA379D@hasmsx107.ger.corp.intel.com>
	<CANfLQrad-1C3Wzy9M+=J7nzjQOcgam9CdJVDR2KC=KipZRpbkA@mail.gmail.com>
	<1459863253.21527.2.camel@intel.com>
	<CANfLQrbjCYaVa7-pq3xxPhmjM+MY5ky-isV7+yYLLFVkDCMr2Q@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32EACFDF2@hasmsx107.ger.corp.intel.com>
Date: Mon, 11 Apr 2016 23:04:16 +0300
Message-ID: <CANfLQrYgSUpbxc2_SgJ1PSB84mMjriUAg4cafiMTzEz+gaEJcQ@mail.gmail.com> (sfid-20160411_220442_925920_E9B95B8C)
Subject: Re: iwlwifi monitor mode: No data frame captured on 5 Ghz
From: Gucea Doru <gucea.doru@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gucea, Doru" <doru.gucea@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 10, 2016 at 1:28 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>> > On Tue, 2016-04-05 at 16:25 +0300, Gucea Doru wrote:
>> Is the iwlwifi driver capable of capturing data frames when the channel
>> bonding is set to 80Mhz?
>
> dev <devname> set freq <control freq> [20|40|80|80+80|160] [<center freq 1>] [<center freq 2>]
>
> You can take center_freq1 from the output of iw dev on a device that is associated to the same AP.

Thanks a lot, Emmanuel. My iw binary that came default with my Ubuntu
distribution was very old (3.4) and it didn't have support for channel
bonding larger than 40Mhz.
I compiled the latest iw version from sources then I took the
center_freq1 from the beacon advertised by the AP. That's because the
iw dev on a device associated to the same AP gave me the control
frequency. After that, I was able to capture the data frames.

One more question that I promise to be the last one:
- I am trying to capture the Wi-Fi Direct traffic between two
smartphones: iw shows me that the p2p interface from one of the
smartphones uses 2.4Ghz, channel 1 so I set the monitor interface on
2.4, channel 1. The problem is that, again, I can't see the data
frames. Instead, I can see the Association/Authentication Request,
RTS/CTS, Block ACK (I attached the Wireshark capture at [1]).

Analyzing the capture, I noticed that the HT capabilities advertised
in the beacon frames indicates 802.11n D1.10. Does this trigger any
indication for you on how to setup the monitor interface?

[1] https://drive.google.com/file/d/0B5SBH08PU_ChNllaVHRienBSVlE/view?usp=sharing

Regards,
Doru
