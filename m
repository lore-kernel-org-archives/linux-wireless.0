Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27552 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZCJD0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 23:26:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 20:26:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18869.56538.642763.326813@gargle.gargle.HOWL> (sfid-20090310_042615_251749_6AFFAA59)
Date: Tue, 10 Mar 2009 08:52:02 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: make few eeprom and calib items static
In-Reply-To: <1236650982-11520-3-git-send-email-lrodriguez@atheros.com>
References: <1236650982-11520-1-git-send-email-lrodriguez@atheros.com>
	<1236650982-11520-3-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> This fixes the sparse complaints:
> 
> drivers/net/wireless/ath9k/eeprom.c:1407:5: warning: symbol
> 'ath9k_hw_4k_get_spur_channel' was not declared. Should it be static?
> drivers/net/wireless/ath9k/eeprom.c:1436:19: warning: symbol
> 'eep_4k_ops' was not declared. Should it be static?
> drivers/net/wireless/ath9k/eeprom.c:2808:5: warning: symbol
> 'ath9k_hw_def_get_spur_channel' was not declared. Should it be static?
> drivers/net/wireless/ath9k/eeprom.c:2837:19: warning: symbol
> 'eep_def_ops' was not declared. Should it be static?
>   CC [M]  drivers/net/wireless/ath9k/eeprom.o
>   CHECK   drivers/net/wireless/ath9k/mac.c
>   CC [M]  drivers/net/wireless/ath9k/mac.o
>   CHECK   drivers/net/wireless/ath9k/calib.c
> drivers/net/wireless/ath9k/calib.c:883:6: warning: symbol 'ar9285_clc'
> was not declared. Should it be static?

Commit 93f726a90d1446c9e5a40fe8f88086542b273e7c in net-next-2.6 fixes a couple
of warnings (in eeprom.c).

Sujith
