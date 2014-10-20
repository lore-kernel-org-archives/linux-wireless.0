Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57056 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbaJTIyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 04:54:24 -0400
Message-ID: <5444CDBC.8060005@openwrt.org> (sfid-20141020_105427_179695_174DECA1)
Date: Mon, 20 Oct 2014 10:54:20 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 02/10] ath9k_hw: remove support for UB124 tx gain table
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>	<1413651732-69783-2-git-send-email-nbd@openwrt.org> <21572.49314.54699.154333@gargle.gargle.HOWL>
In-Reply-To: <21572.49314.54699.154333@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-20 09:58, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> -	else if (AR_SREV_9340(ah))
>> -		INIT_INI_ARRAY(&ah->iniModesTxGain,
>> -			ar9340Modes_ub124_tx_gain_table_1p0);
> 
> Shouldn't the array in ar9340_initvals.h also be removed ?
We can do that later (when we change the qca-swiss-army-knife code).
As long as it isn't referenced, the compiler will not emit the data into
object files.

- Felix
