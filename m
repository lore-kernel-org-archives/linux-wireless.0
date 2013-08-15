Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49473 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719Ab3HOUPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 16:15:10 -0400
Date: Thu, 15 Aug 2013 16:04:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH-resend 0/9] ath5k/ath9k: respin/resend 5/10 MHz and CSA
 patches
Message-ID: <20130815200404.GH2133@tuxdriver.com> (sfid-20130815_221515_541459_0DCE4F6E)
References: <1376460098-26648-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1376460098-26648-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 14, 2013 at 08:01:29AM +0200, Simon Wunderlich wrote:
> This series contains the rebased patches for 5/10 MHz and channel switch
> announcement for ath5k/ath9k as sent in their respective series earlier. No
> modification was made. Since Johannes picked the nl/cfg/mac80211 parts
> only, these patches are still missing in the tree. John reported some
> trouble building with these patches, but I couldn't see any problems here.
> 
> The series is based on wireless-testing of todays master. Please tell
> me if there are any problems (including compiler errors and kernel config)
> so I can rework if neccesary.

  CC      drivers/net/wireless/ath/ath9k/rc.o
drivers/net/wireless/ath/ath9k/rc.c: In function ‘ath_rate_update’:
drivers/net/wireless/ath/ath9k/rc.c:1333:3: error: invalid type argument of ‘->’ (have ‘struct cfg80211_chan_def’)
make[2]: *** [drivers/net/wireless/ath/ath9k/rc.o] Error 1

> 
> Thanks!
> 	Simon
> 
> Simon Wunderlich (9):
>   ath9k: always use SIFS times from OFDM for 5/10 MHz
>   ath9k: use chandef instead of channel_type
>   ath9k: report 5/10 MHz channels
>   ath9k: set 5/10 MHz supported channels and fix bitrate
>   ath9k: announce that ath9k supports 5/10 MHz
>   ath5k: report 5/10 MHz channels
>   ath5k: set 5/10 MHz supported channels and fix duration
>   ath5k: enable support for 5 MHz and 10 MHz channels
>   ath9k: enable CSA functionality in ath9k
> 
>  drivers/net/wireless/ath/ath5k/ath5k.h        |    1 +
>  drivers/net/wireless/ath/ath5k/base.c         |   59 ++++++++++++++++++----
>  drivers/net/wireless/ath/ath5k/base.h         |    2 +-
>  drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
>  drivers/net/wireless/ath/ath5k/pcu.c          |    2 +
>  drivers/net/wireless/ath/ath5k/qcu.c          |   25 ++++++++-
>  drivers/net/wireless/ath/ath9k/ath9k.h        |    2 +
>  drivers/net/wireless/ath/ath9k/beacon.c       |   21 ++++++++
>  drivers/net/wireless/ath/ath9k/common.c       |   67 +++++++++++++++----------
>  drivers/net/wireless/ath/ath9k/common.h       |    3 +-
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
>  drivers/net/wireless/ath/ath9k/hw.c           |    5 +-
>  drivers/net/wireless/ath/ath9k/init.c         |   30 +++++++----
>  drivers/net/wireless/ath/ath9k/main.c         |   25 +++++++--
>  drivers/net/wireless/ath/ath9k/rc.c           |    9 +++-
>  drivers/net/wireless/ath/ath9k/recv.c         |   11 ++++
>  drivers/net/wireless/ath/ath9k/xmit.c         |    2 +
>  17 files changed, 206 insertions(+), 65 deletions(-)
> 
> -- 
> 1.7.10.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
