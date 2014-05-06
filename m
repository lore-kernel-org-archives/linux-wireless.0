Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56022 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaEFTAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 15:00:10 -0400
Date: Tue, 6 May 2014 14:48:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ashish Patro <patro@cs.wisc.edu>
Cc: linux-wireless@vger.kernel.org, linux@rempel-privat.de
Subject: Re: [PATCH 0/3] Refactoring spectral scan code and adding spectral
 scan support for ath9k_htc
Message-ID: <20140506184839.GH3518@tuxdriver.com> (sfid-20140506_210015_128926_FC2A56D3)
References: <1398870683-15701-1-git-send-email-patro@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1398870683-15701-1-git-send-email-patro@cs.wisc.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any comments from the ath9k guys on this patchset?

Also, could you post your patches with more concise subject lines
and possibly more verbose changelog entries?

John

On Wed, Apr 30, 2014 at 10:11:20AM -0500, Ashish Patro wrote:
> These patches move the common components of spectral scan funcationality to common-spectral.c.
> 
> Also added spectral scan support to ath9k_htc using the same mechanism to collect spectral scan data as used by ath9k driver.
> 
> This work was done at the Wisconsin Wireless and NetworkinG Systems (WiNGS) Lab at the University of Wisconsin Madison.
> 
> I've also worked with Oleksij Rempel (linux@rempel-privat.de) to get these patches tested and verified with a AR9271 chipset device.
> 
> Ashish Patro (3):
>   Moving the ath9k specific spectral functions to ath9k.h from
>     spectral.h. Renamed spectral.h to common-spectral.h
>   Refactoring the ath9k driver to move common spectral functions to
>     common-spectral.c
>   Update spectral scan calls to support both ath9k and ath9k_htc.
>     Adding spectral scan functionality to ath9k_htc driver. Tested
>     using a AR9271 WiFi card.
> 
>  drivers/net/wireless/ath/ath9k/Makefile           |    3 +-
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c       |   11 +-
>  drivers/net/wireless/ath/ath9k/ath9k.h            |    9 +-
>  drivers/net/wireless/ath/ath9k/common-spectral.c  |  213 +++++++++++++
>  drivers/net/wireless/ath/ath9k/common-spectral.h  |  199 ++++++++++++
>  drivers/net/wireless/ath/ath9k/htc.h              |   13 +
>  drivers/net/wireless/ath/ath9k/htc_drv_debug.c    |    3 +
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c     |    8 +
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c     |   75 +++++
>  drivers/net/wireless/ath/ath9k/htc_drv_spectral.c |  353 +++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c     |   17 +
>  drivers/net/wireless/ath/ath9k/recv.c             |    7 +-
>  drivers/net/wireless/ath/ath9k/spectral.c         |  187 -----------
>  drivers/net/wireless/ath/ath9k/spectral.h         |  212 ------------
>  14 files changed, 905 insertions(+), 405 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath9k/common-spectral.c
>  create mode 100644 drivers/net/wireless/ath/ath9k/common-spectral.h
>  create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_spectral.c
>  delete mode 100644 drivers/net/wireless/ath/ath9k/spectral.h
> 
> -- 
> 1.7.5.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
