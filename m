Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:43819 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750920AbeAUVq2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Jan 2018 16:46:28 -0500
Received: by mail-yb0-f176.google.com with SMTP id h9so2555557ybg.10
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jan 2018 13:46:28 -0800 (PST)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: RTL8723bu: poor signal and connection troubles
To: Barry Day <briselec@gmail.com>, Carlo Caione <carlo@endlessm.com>,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        mylene.josserand@free-electrons.com,
        Linux Upstreaming Team <linux@endlessm.com>
References: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
 <20180111103006.GA17574@thinktank.home.org>
Message-ID: <14c5f7f4-0d5b-cecd-b45b-3672b67da07a@gmail.com> (sfid-20180121_224635_408482_2C5B0DDB)
Date: Sun, 21 Jan 2018 16:46:25 -0500
MIME-Version: 1.0
In-Reply-To: <20180111103006.GA17574@thinktank.home.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2018 05:30 AM, Barry Day wrote:
> On Wed, Jan 10, 2018 at 12:15:51PM +0000, Carlo Caione wrote:
>> Hi,
>> this is a follow up email to [0] since the problem was never fully
>> investigated / solved and I keep seeing the same problem also on my
>> hardware.
>>
>> Also in my case the hardware is a rtl8723bt transceiver
>> (0x0bda:0xb720), this time shipped on the internal USB bus in a cheap
>> laptop branded Zyrex Sky 232.
>>
>> As already reported by Mylene the problem is that using this
>> transceiver and the latest Linus master you can barely see any WiFi
>> network around and also when a WiFi network is actually seen, the
>> connection is impossible since the signal strength is too low to have
>> a reliable connection. Of course during my tests BT is off and no BT
>> driver is probed at all.
>>
>> Using the downstream driver at [1] everything works correctly.
>>
>> I tried to debug a bit the issue, in particular comparing functions
>> and registers related to the antenna setup (.power_on, .enable_rf,
>> .phy_init_antenna_selection, .phy_iq_calibrate hooks) but everything
>> seems pretty much the same on the two drivers (even though slightly
>> differences do exist).
>>
>> Any idea / suggestion on how to debug this problem? I guess it's worth
>> to start looking at this since several platforms are being affected
>> now.
>>
>> Cheers,
>>
>> [0] https://www.spinics.net/lists/netdev/msg468028.html
>> [1] https://github.com/lwfinger/rtl8723bu
>>
>> -- 
>> Carlo Caione  |  +44.7384.69.16.04  |  Endless
> 
> I've found the same. The signal strength using the original driver
> from Realtek is significantly higher than when using rtl8xxxu.
> I also was not able to find anything wrong in the rtl8xxxu source code
> that would be causing the difference, which leads to the thought it is
> missing something that exists in the original driver.

One issue with rtl8723bu is that it needs to coexist with the bluetooth
driver. When I wrote the rtl8723bu support that was no BT support for
the chip in the kernel and it worked fine, at least for me. However if
you load the BT driver for the dongle which someone pushed into the
kernel since then, it is likely to hijack the antennas causing the weak
signal you describe.

Jes
