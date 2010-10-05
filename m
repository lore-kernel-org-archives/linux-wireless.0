Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40129 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab0JEUGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:06:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 13:06:37 -0700
Date: Tue, 5 Oct 2010 13:06:43 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Gabor Juhos <juhosg@openwrt.org>,
	Cliff Holden <Cliff.Holden@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Shu Hwa Shen <shensh@zcomm.com.cn>
Subject: Re: [ath9k-devel] [PATCH] ath9k: get correct tx gain type in
 ath9k_hw_4k_get_eeprom
Message-ID: <20101005200643.GH11831@tux>
References: <1286271137-10861-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286271137-10861-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 02:32:17AM -0700, Gabor Juhos wrote:
> The base_eep_header_4k structure contains information that the
> device supports high power tx gain table or not. However the
> ath9k_hw_4k_get_eeprom function does not return that value when
> it is called with EEP_TXGAIN_TYPE. This leads to that the tx gain
> initialization will use the init values from the original tx gain
> table even if the device inidicates that the high power table
> should be used.
> 
> Changes-licensed-under: ISC
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Shu Hwa Shen <shensh@zcomm.com.cn>

Thanks for the patch, I'm reviewing this internally, I don't see
it used on our HAL for ar5416/ so just want to double check this
is correct.

 Luis
