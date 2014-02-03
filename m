Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53291 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaBCMIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 07:08:13 -0500
Message-ID: <52EF8699.2000305@openwrt.org> (sfid-20140203_130954_263961_5D43C101)
Date: Mon, 03 Feb 2014 13:07:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	Sujith Manoharan <sujith@msujith.org>
CC: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/13] ath9k_htc: add rx header converter to make it usable
 by ath9k
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>	<1391022424-21087-1-git-send-email-linux@rempel-privat.de>	<1391022424-21087-4-git-send-email-linux@rempel-privat.de> <21230.64089.741.909535@gargle.gargle.HOWL> <52EF7BEB.5080605@rempel-privat.de>
In-Reply-To: <52EF7BEB.5080605@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-03 12:22, Oleksij Rempel wrote:
> Am 03.02.2014 03:09, schrieb Sujith Manoharan:
>> Oleksij Rempel wrote:
>>> +	rx_stats = kzalloc(sizeof(struct ath_rx_status), GFP_KERNEL);
>>> +	if (unlikely(rx_stats == NULL)) {
>>> +		ath_err(common, "rx_stats allocation filed!\n");
>>> +		goto err_nofree;
>>> +	}
>>> +	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
>>> +
> 
>> This seems a little expensive, since this would happen for every packet,
>> and a memcpy is already done earlier, for storing the RX status in
>> rxbuf->rxstatus. Instead of using 'struct ath_htc_rx_status' in
>> 'struct ath9k_htc_rxbuf', why can't 'struct ath_rx_status' be used ?
>> The values can be converted and stored directly, avoiding this alloc.
> 
> Do you mean kzalloc or converter?
> then memcpy is removed by patch 12/13. Converter is not effective but it
> should prevent from confusions. At least until FW use same flags and
> struct ath_rx_status do.
> But i'm open for other ideas too.
You should at least keep rx_stats on stack instead of using kzalloc,
that would make it much faster.

- Felix
