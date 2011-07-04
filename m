Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36597 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab1GDKpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 06:45:13 -0400
Message-ID: <4E1199A9.2040008@openwrt.org> (sfid-20110704_124516_838413_3BBFF174)
Date: Mon, 04 Jul 2011 17:44:57 +0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 4/8] ath5k: initialize common->clockrate
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org> <1309758467-1712-2-git-send-email-nbd@openwrt.org> <1309758467-1712-3-git-send-email-nbd@openwrt.org> <1309758467-1712-4-git-send-email-nbd@openwrt.org> <CAFtRNNzHqQLYxoZBBgpyttLgXRp1SWabPdQvNr4gvRPvPpPOBw@mail.gmail.com>
In-Reply-To: <CAFtRNNzHqQLYxoZBBgpyttLgXRp1SWabPdQvNr4gvRPvPpPOBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-07-04 5:40 PM, Nick Kossifidis wrote:
> 2011/7/4 Felix Fietkau<nbd@openwrt.org>:
>>  Fixes a division by zero when setting distance before activating the
>>  device for the first time.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>    drivers/net/wireless/ath/ath5k/base.c |    1 +
>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>>  index a6623dd..a413aa7 100644
>>  --- a/drivers/net/wireless/ath/ath5k/base.c
>>  +++ b/drivers/net/wireless/ath/ath5k/base.c
>>  @@ -2422,6 +2422,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
>>          common->ah = sc->ah;
>>          common->hw = hw;
>>          common->priv = sc;
>>  +       common->clockrate = 40;
>>
>>          /*
>>           * Cache line size is used to size and align various
>>  --
>>  1.7.3.2
>>
>
> We better set this to 44 for g (according to docs core frequency is 44MHz for g)
It shouldn't make a difference, since the first hardware reset will 
reload all the settings anyway.

- Felix
