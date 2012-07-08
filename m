Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36140 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab2GHNk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 09:40:59 -0400
Received: by lboj14 with SMTP id j14so13406156lbo.7
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 06:40:56 -0700 (PDT)
Message-ID: <1341754854.4354.45.camel@cumari.coelho.fi> (sfid-20120708_154102_586537_E37820C6)
Subject: Re: pull request: TI wireless drivers 2012-07-08 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com
Date: Sun, 08 Jul 2012 16:40:54 +0300
In-Reply-To: <1341754768.4354.44.camel@cumari.coelho.fi>
References: <1341754768.4354.44.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, fixed the subject, which was obviously sent with the wrong date.
Sorry for the mix up.

Luca.

On Sun, 2012-07-08 at 16:39 +0300, Luciano Coelho wrote:
> Hi John,
> 
> A few more patches with some bugfixes and an update in the firmware APIs
> intended for 3.6.  The new firmware has already been applied in
> linux-firmware.git and renamed, so this should work with the latest
> stuff from there.
> 
> Please let me know if there are any problems with this.
> 
> 
> The following changes since commit abb14fc399bb895bc5ab86af5d4defc2dfec4e70:
> 
>   Merge tag 'nfc-next-3.6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0 (2012-07-06 16:20:33 -0400)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linville
> 
> for you to fetch changes up to b950b01308bdcb07b16eb0ea63a76901d029bfd8:
> 
>   Merge branch 'wl12xx-next' into for-linville (2012-07-08 16:27:26 +0300)
> 
> ----------------------------------------------------------------
> 
> Arik Nemtsov (9):
>       wlcore/wl12xx/wl18xx: check min FW version
>       wlcore: don't stop tx queue via watermark if already stopped
>       wlcore: remove recover cmd from testmode
>       wlcore: avoid debug prints during intended FW recovery
>       wlcore: always clear recovery flag during recovery_work
>       wlcore: don't set SDIO_FAILED flag when driver state is off
>       wlcore: define number of supported bands internally
>       wl12xx/wl18xx: use a dynamic PS timeout of 1.5sec
>       wlcore: determine AP extra rates correctly
> 
> Dan Carpenter (1):
>       wlcore: fix a couple small memory leaks
> 
> Eliad Peller (2):
>       wlcore: implement .flush callback
>       wlcore: check ssid length against the correct element
> 
> Ido Yariv (1):
>       wlcore: Prevent processing of work items during op_stop
> 
> Luciano Coelho (2):
>       wl12xx/wlcore: increase FW filename version
>       Merge branch 'wl12xx-next' into for-linville
> 
> Victor Goldenshtein (1):
>       wlcore: enable sched scan while connected
> 
> Yoni Divinsky (2):
>       wlcore: add probe request templates for sched and one-shot scans
>       wlcore: change the wait for event mechanism
> 
>  drivers/net/wireless/ti/wl12xx/main.c     |   26 ++++++++++++++-----
>  drivers/net/wireless/ti/wl12xx/wl12xx.h   |   14 ++++++++++
>  drivers/net/wireless/ti/wl18xx/main.c     |   27 ++++++++++++++-----
>  drivers/net/wireless/ti/wl18xx/wl18xx.h   |    7 +++++
>  drivers/net/wireless/ti/wlcore/boot.c     |   55 +++++++++++++++++++++++++++++++++++++--
>  drivers/net/wireless/ti/wlcore/cmd.c      |   22 +++++++++++++---
>  drivers/net/wireless/ti/wlcore/cmd.h      |    6 ++---
>  drivers/net/wireless/ti/wlcore/init.c     |   16 ++++++++++++
>  drivers/net/wireless/ti/wlcore/io.c       |    6 +++++
>  drivers/net/wireless/ti/wlcore/io.h       |   13 +++++-----
>  drivers/net/wireless/ti/wlcore/main.c     |   75 ++++++++++++++++++++++++++++++-----------------------
>  drivers/net/wireless/ti/wlcore/scan.c     |   11 ++++----
>  drivers/net/wireless/ti/wlcore/sdio.c     |    6 -----
>  drivers/net/wireless/ti/wlcore/spi.c      |    6 -----
>  drivers/net/wireless/ti/wlcore/testmode.c |   13 +---------
>  drivers/net/wireless/ti/wlcore/wlcore.h   |   25 ++++++++++++++++--
>  drivers/net/wireless/ti/wlcore/wlcore_i.h |   16 ++++--------
>  17 files changed, 242 insertions(+), 102 deletions(-)
> 
> 


