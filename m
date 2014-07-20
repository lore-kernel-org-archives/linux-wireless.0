Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 246.111.88.91.rev.sfr.net ([91.88.111.246]:38088 "EHLO
	zimbra.duchein.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaGTOGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:06:50 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 00/10] add support for ack timeout estimation in ath9k driver
From: Philippe DUCHEIN <wireless-dev@duchein.net>
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Sun, 20 Jul 2014 16:05:43 +0200
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
Message-Id: <67728BC0-FBDC-43F9-B7A0-A876FE27EC4B@duchein.net> (sfid-20140720_160748_148233_3D5B3532)
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lorenzo,
Since friday I enable dynack on an AP who serve 35 sta (on 2 MIMO 2x2 5ghz wireless cards 12&23) in outdoor (up to 8 kms)
results are good. latency is good for all sta
I’ll take your new patches and make one for openwrt and, recompile 
Thanks;
Philippe




Le 20 juil. 2014 à 14:31, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> a écrit :

> This patchset adds support for estimation of the ack timeout (dynack) in ath9k
> driver. Ath9k dynack computes the ack timeout based on ack frame RX timestamp,
> TX frame timestamp and frame duration.
> 
> Ath9k dynack has been tested in indoor environment using AR9223/AR9280 chipset
> (running 3.16.0-rc5 kernel) and on 9Km PtoP link using AR9280 chipset
> (running OpenWRT trunk, compat-wireless-2014-05-22)
> 
> Changes since RFCv2:
> - disable dynack by default
> - add ath9k_enable_dynack() method to enable ack timeout estimation algorithm
> - remove dynack entry from ath9k debugfs
> 
> Changes since RFCv1:
> - use ISC license instead of GPLv2 one
> - use an inline method instead of a macro for EWMA calculation
> - use powers of two weights in EWMA calculation
> - fix typos
> - add ath_dynack_node_init/ath_dynack_node_deinit methods
> - use different logic to enable/disable dynack processing
> 
> Lorenzo Bianconi (10):
>  ath9k: export methods related to ack timeout estimation
>  ath9k: add duration field to ath_tx_status
>  ath9k: add dynamic ack timeout estimation
>  ath9k: add config for (en|dis)abling ack timeout estimation
>  ath9k: do not overwrite ack timeout estimation
>  ath9k: add sampling methods for (tx|rx) timestamp
>  ath9k: enable control frame reception
>  ath9k: add debugfs support for dynack
>  ath9k: add ath9k_enable_dynack() method
>  ath9k: initialize ath_node linked list
> 
> drivers/net/wireless/ath/ath.h              |   2 +
> drivers/net/wireless/ath/ath9k/Kconfig      |   7 +
> drivers/net/wireless/ath/ath9k/Makefile     |   3 +
> drivers/net/wireless/ath/ath9k/ar9002_mac.c |   7 +
> drivers/net/wireless/ath/ath9k/ar9003_mac.c |   9 +
> drivers/net/wireless/ath/ath9k/ath9k.h      |   3 +
> drivers/net/wireless/ath/ath9k/debug.c      |  28 +++
> drivers/net/wireless/ath/ath9k/dynack.c     | 345 ++++++++++++++++++++++++++++
> drivers/net/wireless/ath/ath9k/dynack.h     |  96 ++++++++
> drivers/net/wireless/ath/ath9k/hw.c         |  16 +-
> drivers/net/wireless/ath/ath9k/hw.h         |   7 +
> drivers/net/wireless/ath/ath9k/mac.h        |   1 +
> drivers/net/wireless/ath/ath9k/main.c       |  38 +++
> drivers/net/wireless/ath/ath9k/recv.c       |   7 +-
> drivers/net/wireless/ath/ath9k/xmit.c       |   5 +
> 15 files changed, 570 insertions(+), 4 deletions(-)
> create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
> create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h
> 
> -- 
> 1.9.1
> 

