Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56629 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1DLVzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 17:55:52 -0400
Message-ID: <4DA4CA66.501@openwrt.org>
Date: Tue, 12 Apr 2011 23:55:50 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/7] ath5k: optimize tx descriptor setup
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org> <87fwppmhbr.fsf@purkki.adurom.net>
In-Reply-To: <87fwppmhbr.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-11 8:29 AM, Kalle Valo wrote:
> Felix Fietkau<nbd@openwrt.org>  writes:
>
>>  Use local variables to reduce the number of load/store operations on uncached
>>  memory.
>
> A comment in the code would be nice as well. Otherwise later on
> someone decides to "optimise" and remove the local variables :)
Makes sense.

>>   	/* Clear descriptor */
>>  -	memset(&desc->ud.ds_tx5212, 0, sizeof(struct ath5k_hw_5212_tx_desc));
>>  +	memset(&desc->ud.ds_tx5212.tx_stat, 0,
>>  +	       sizeof(desc->ud.ds_tx5212.tx_stat));
>
> Is this an unrelated change? Or maybe I just missed something.
This is related. After my change, all the control fields of the 
descriptor are properly written to, so the memset only needs to cover 
the status area.

- Felix
