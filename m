Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39471 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbCLMj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:39:58 -0400
Message-ID: <55018919.3050902@m4x.org> (sfid-20150312_134014_069993_A72FF84D)
Date: Thu, 12 Mar 2015 20:39:53 +0800
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
CC: netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: wl18xx: Bad format for rx_frames_per_rates in debugfs?
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

While adding __printf attributes to several functions in the kernel, I
got a surprising gcc warning in drivers/net/wireless/ti/wl18xx/debugfs.c
about "format '%u' expects argument of type 'unsigned int', but argument
5 has type 'u32 *'".

Indeed it seems that commit c5d94169e818 ("wl18xx: use new fw stats
structures") [1] introduced an array field "u32 rx_frames_per_rates[50]"
in struct wl18xx_acx_rx_rate_stat but is using
WL18XX_DEBUGFS_FWSTATS_FILE(rx_rate, rx_frames_per_rates, "%u"); instead
of something like WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(rx_rate,
rx_frames_per_rates, 50); for displaying this value.  So I believe that
currently the rx_rate entry in debugfs contains a kernel pointer instead
of the actual data.  As I don't have the hardware to test I can't be
sure of it.

Is this a real bug which needs to be fixed or something weird I haven't
understood yet?

Thanks

--
Nicolas

[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c5d94169e8189d02dfbd6143411908357865d777

PS: I got this gcc warning by adding __printf(4, 5) to
wl1271_format_buffer() prototype in
drivers/net/wireless/ti/wlcore/debugfs.h:

In file included from
/usr/src/linux/drivers/net/wireless/ti/wl18xx/debugfs.c:23:0:
    /usr/src/linux/drivers/net/wireless/ti/wl18xx/debugfs.c: In function
'rx_rate_rx_frames_per_rates_read':
    /usr/src/linux/drivers/net/wireless/ti/wl18xx/debugfs.c:34:32:
error: format '%u' expects argument of type 'unsigned int', but argument
5 has type 'u32 *' [-Werror=format=]
      DEBUGFS_FWSTATS_FILE(a, b, c, wl18xx_acx_statistics)
                                    ^

/usr/src/linux/drivers/net/wireless/ti/wl18xx/../wlcore/debugfs.h:77:9:
note: in definition of macro 'DEBUGFS_FWSTATS_FILE'
      struct struct_type *stats = wl->stats.fw_stats;   \
             ^
    /usr/src/linux/drivers/net/wireless/ti/wl18xx/debugfs.c:142:1: note:
in expansion of macro 'WL18XX_DEBUGFS_FWSTATS_FILE'
     WL18XX_DEBUGFS_FWSTATS_FILE(rx_rate, rx_frames_per_rates, "%u");
     ^
