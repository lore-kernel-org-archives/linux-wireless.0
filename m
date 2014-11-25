Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46045 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbaKYISE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:18:04 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 0/2] add TPC capability for AR9003 based chips
From: =?utf-8?Q?Thomas_H=C3=BChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1416871301-9595-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Tue, 25 Nov 2014 09:10:36 +0100
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org,
	adrian@freebsd.org
Message-Id: <88DB02F5-D8BE-4E79-BBE8-788E1C52B81F@net.t-labs.tu-berlin.de> (sfid-20141125_091809_040850_4065C9E5)
References: <1416871301-9595-1-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lerenzo,

This series look good to me.

Greetings 
Thomas


> Am 25.11.2014 um 00:21 schrieb Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>:
> 
> This patchset adds TPC capability to ath9k for AR9003 based chips. For the time
> being some FCC checks are missing in ar9003_hw_init_txpower_stbc() and CDD mode
> is not supported.
> 
> *[PATCH 1/2]: add TX power per-rate tables to cap TX power in TX descriptor path
> *[PATCH 2/2]: cap per-packet TX power according to TX power per-rate tables
> 
> This pachset is based on Adrian Chadd's hints
> (https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)
> 
> Changes since RFC:
> - make the ah->txpower array one-dimensional and store max TX power for the
>  current chainmask only
> 
> Lorenzo Bianconi (2):
>  ath9k: add TX power per-rate tables
>  ath9k: add TPC capability to TX descriptor path
> 
> drivers/net/wireless/ath/ath9k/ar9002_mac.c    |   8 +-
> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  47 +++++++
> drivers/net/wireless/ath/ath9k/ar9003_mac.c    |   8 +-
> drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 174 +++++++++++++++++++++++++
> drivers/net/wireless/ath/ath9k/ath9k.h         |   1 +
> drivers/net/wireless/ath/ath9k/beacon.c        |   5 +-
> drivers/net/wireless/ath/ath9k/hw.h            |   6 +
> drivers/net/wireless/ath/ath9k/mac.h           |   2 +-
> drivers/net/wireless/ath/ath9k/reg.h           |   2 +
> drivers/net/wireless/ath/ath9k/xmit.c          |  37 +++++-
> 10 files changed, 278 insertions(+), 12 deletions(-)
> 
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

