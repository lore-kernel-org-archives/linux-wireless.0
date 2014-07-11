Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 246.111.88.91.rev.sfr.net ([91.88.111.246]:42364 "EHLO
	zimbra.duchein.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaGKWQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 18:16:21 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [ath9k-devel] [RFC 00/10] add support for ack timeout estimation in ath9k driver
From: Philippe DUCHEIN <wireless-dev@duchein.net>
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Sat, 12 Jul 2014 00:08:08 +0200
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Message-Id: <FE2A3D78-C82A-4338-B131-7D4E098B533F@duchein.net> (sfid-20140712_001629_379839_0B1E1B33)
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lorenzo,
i upgraded last night a point to pint of 9kms with dynack (it’s bullets 5M)
It works perfectly
I have better bandwidth ! yes, about 10% better!
next week, i’ll upgrade a point to multipoint with 20 STA. STA are around 6kms from the base station. Base station is a rocket 5M and CPE are Ubnt nanobridge.

Regards,
Philippe


Le 7 juil. 2014 à 11:31, Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> a écrit :

> This patchset adds support for estimation of the ack timeout (dynack) in ath9k
> driver. Ath9k dynack computes the ack timeout based on ack frame RX timestamp,
> TX frame timestamp and frame duration.
> 
> Ath9k dynack has been tested in indoor environment using AR9223 chipset
> (running 3.15.3 kernel) configured as AP and using AR9280 chipset
> (running 3.16.0-rc3) configured as STA. Ath9k dynack needs to be tested on a
> long distance link in outdoor environment.
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
>  ath9k: disable dynack algorithm when coverage class is set
>  ath9k: add ath_node linked list
> 
> drivers/net/wireless/ath/ath.h              |   2 +
> drivers/net/wireless/ath/ath9k/Kconfig      |   7 +
> drivers/net/wireless/ath/ath9k/Makefile     |   3 +
> drivers/net/wireless/ath/ath9k/ar9002_mac.c |   7 +
> drivers/net/wireless/ath/ath9k/ar9003_mac.c |   9 +
> drivers/net/wireless/ath/ath9k/ath9k.h      |   3 +
> drivers/net/wireless/ath/ath9k/debug.c      |  82 ++++++++
> drivers/net/wireless/ath/ath9k/dynack.c     | 293 ++++++++++++++++++++++++++++
> drivers/net/wireless/ath/ath9k/dynack.h     |  81 ++++++++
> drivers/net/wireless/ath/ath9k/hw.c         |  16 +-
> drivers/net/wireless/ath/ath9k/hw.h         |   7 +
> drivers/net/wireless/ath/ath9k/mac.h        |   1 +
> drivers/net/wireless/ath/ath9k/main.c       |  11 ++
> drivers/net/wireless/ath/ath9k/recv.c       |   7 +-
> drivers/net/wireless/ath/ath9k/xmit.c       |   5 +
> 15 files changed, 530 insertions(+), 4 deletions(-)
> create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
> create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h
> 
> -- 
> 1.9.1
> 
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel

