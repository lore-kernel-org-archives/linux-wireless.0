Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:35720 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934172AbdEOTDM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 15:03:12 -0400
Date: Mon, 15 May 2017 21:02:36 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: David Miller <davem@davemloft.net>
Cc: arnd@arndb.de, sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, dev@kresin.me, johannes.berg@intel.com,
        pozega.tomislav@gmail.com, vasilugin@yandex.ru, roman@advem.lv,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: improve calling conventions for register
 accessors
Message-ID: <20170515190235.GA1740@makrotopia.org> (sfid-20170515_210316_152034_066CA427)
References: <20170515134711.2770374-1-arnd@arndb.de>
 <20170515142520.GA13996@redhat.com>
 <CAK8P3a1xYah7_4=DAcN+M83noUQyLZ9hV=WWD0Q79sQrFsoroA@mail.gmail.com>
 <20170515.104052.1376354562934671974.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170515.104052.1376354562934671974.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 15, 2017 at 10:40:52AM -0400, David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Mon, 15 May 2017 16:36:45 +0200
> 
> > On Mon, May 15, 2017 at 4:28 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> On Mon, May 15, 2017 at 03:46:55PM +0200, Arnd Bergmann wrote:
> >>> With CONFIG_KASAN enabled and gcc-7, we get a warning about rather high
> >>> stack usage (with a private patch set I have to turn on this warning,
> >>> which I intend to get into the next kernel release):
> >>>
> >>> wireless/ralink/rt2x00/rt2800lib.c: In function 'rt2800_bw_filter_calibration':
> >>> wireless/ralink/rt2x00/rt2800lib.c:7990:1: error: the frame size of 2144 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
> >>>
> >>> The problem is that KASAN inserts a redzone around each local variable that
> >>> gets passed by reference, and the newly added function has a lot of them.
> >>> We can easily avoid that here by changing the calling convention to have
> >>> the output as the return value of the function. This should also results in
> >>> smaller object code, saving around 4KB in .text with KASAN, or 2KB without
> >>> KASAN.
> >>>
> >>> Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
> >>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >>> ---
> >>>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 319 +++++++++++++------------
> >>>  1 file changed, 164 insertions(+), 155 deletions(-)
> >>
> >> We have read(, &val) calling convention since forever in rt2x00 and that
> >> was never a problem. I dislike to change that now to make some tools
> >> happy, I think problem should be fixed in the tools instead.
> > 
> > How about adding 'depends on !KASAN' in Kconfig instead?
> 
> Please let's not go down that route and make such facilities less
> useful due to decreased coverage.

Being the one to blame for submitting the patch adding most of the
problem's footprint: Arnd's change looks good to me and I believe it
should be merged.
This is the type of feedback I was hoping for when submitting all the
long-forgotten and rotting patches from OpenWrt's mac80211 driver
patches! Thanks to Arnd for your efforts!

Consider this as
Acked-by: Daniel Golle <daniel@makrotopia.org>
for Arnd's original patch (and for NOT adding 'depends on !KASAN')

Cheers


Daniel

> 
> Thanks.
