Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:55983 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab2FHNcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 09:32:02 -0400
Received: by lbbgh12 with SMTP id gh12so1172987lbb.25
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 06:31:57 -0700 (PDT)
Message-ID: <1339162315.7078.144.camel@cumari.coelho.fi> (sfid-20120608_153207_327297_5E986DE4)
Subject: Re: [PATCH 0/9] wl18xx: debugfs additions and a new conf file
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Date: Fri, 08 Jun 2012 16:31:55 +0300
In-Reply-To: <1339101568-25346-1-git-send-email-coelho@ti.com>
References: <1339101568-25346-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 23:39 +0300, Luciano Coelho wrote:
> Hi,
> 
> A few more patches for wl18xx (or directly related to it).
> 
> Eyal added a new control file in debugfs that we use during the R&D
> phase, for debugging and fine-tuning.
> 
> I added another file in debugfs that allows us to reset the firmware
> statistics data, so we can clear it and start counting from a
> a certain point in time.
> 
> I also added a new conf binary file, which contains driver and
> firmware configuration values that are currently hardcoded in the
> driver.  With this file we will have much more flexibility and, with
> the help of a new userspace tool I implemented, we will be able to
> change any of these settings much more easily.  This file will
> eventually replace all the hardcoded values and the NVS binary file
> that we currently use.
> 
> Cheers,
> Luca.
> 
> Eyal Shapira (2):
>   wlcore: add support macros to easily add conf debugfs entries
>   wlcore: add debugfs control over rx interrupt pacing
> 
> Luciano Coelho (7):
>   wl18xx: add support to clear FW statistics
>   wlcore: export raw binary with the FW statistics in debugfs
>   wlcore/wl18xx/wl12xx: use u8 instead of bool for
>     host_fast_wakeup_support
>   wlcore: use u8 instead of enum for bcn_filt_mode
>   wlcore/wl18xx: the conf structs must be packed so they can be
>     exported
>   wlcore/wl18xx: export conf struct in a debugfs file
>   wl18xx: read configuration structure from a binary file
> 
>  drivers/net/wireless/ti/wl12xx/main.c    |    2 +-
>  drivers/net/wireless/ti/wl18xx/acx.c     |   24 +++++++
>  drivers/net/wireless/ti/wl18xx/acx.h     |    9 +++
>  drivers/net/wireless/ti/wl18xx/conf.h    |   10 ++-
>  drivers/net/wireless/ti/wl18xx/debugfs.c |   74 +++++++++++++++++++++
>  drivers/net/wireless/ti/wl18xx/main.c    |   70 ++++++++++++++++++--
>  drivers/net/wireless/ti/wlcore/conf.h    |   75 ++++++++++++++-------
>  drivers/net/wireless/ti/wlcore/debugfs.c |  106 ++++++++++++++++++++++++++++++
>  8 files changed, 337 insertions(+), 33 deletions(-)

Applied and pushed this series to wl12xx.git/master.

--
Luca.

