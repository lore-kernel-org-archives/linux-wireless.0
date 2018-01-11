Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36181 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754153AbeAKKbC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 05:31:02 -0500
Received: by mail-pf0-f195.google.com with SMTP id 23so1335586pfp.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jan 2018 02:31:02 -0800 (PST)
Date: Thu, 11 Jan 2018 20:30:09 +1000
From: Barry Day <briselec@gmail.com>
To: Carlo Caione <carlo@endlessm.com>
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        mylene.josserand@free-electrons.com,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: RTL8723bu: poor signal and connection troubles
Message-ID: <20180111103006.GA17574@thinktank.home.org> (sfid-20180111_113106_194212_DE2E6877)
References: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:15:51PM +0000, Carlo Caione wrote:
> Hi,
> this is a follow up email to [0] since the problem was never fully
> investigated / solved and I keep seeing the same problem also on my
> hardware.
> 
> Also in my case the hardware is a rtl8723bt transceiver
> (0x0bda:0xb720), this time shipped on the internal USB bus in a cheap
> laptop branded Zyrex Sky 232.
> 
> As already reported by Mylene the problem is that using this
> transceiver and the latest Linus master you can barely see any WiFi
> network around and also when a WiFi network is actually seen, the
> connection is impossible since the signal strength is too low to have
> a reliable connection. Of course during my tests BT is off and no BT
> driver is probed at all.
> 
> Using the downstream driver at [1] everything works correctly.
> 
> I tried to debug a bit the issue, in particular comparing functions
> and registers related to the antenna setup (.power_on, .enable_rf,
> .phy_init_antenna_selection, .phy_iq_calibrate hooks) but everything
> seems pretty much the same on the two drivers (even though slightly
> differences do exist).
> 
> Any idea / suggestion on how to debug this problem? I guess it's worth
> to start looking at this since several platforms are being affected
> now.
> 
> Cheers,
> 
> [0] https://www.spinics.net/lists/netdev/msg468028.html
> [1] https://github.com/lwfinger/rtl8723bu
> 
> -- 
> Carlo Caione  |  +44.7384.69.16.04  |  Endless

I've found the same. The signal strength using the original driver
from Realtek is significantly higher than when using rtl8xxxu.
I also was not able to find anything wrong in the rtl8xxxu source code
that would be causing the difference, which leads to the thought it is
missing something that exists in the original driver.


Barry Day
