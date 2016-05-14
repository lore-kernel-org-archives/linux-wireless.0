Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34673 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbcENNCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2016 09:02:49 -0400
Subject: Re: [PATCH v2] ath9k: interpret requested txpower in EIRP domain
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org
References: <201604011711.RmqSBtrr%fengguang.wu@intel.com>
 <1459503428-12492-1-git-send-email-zefir.kurtisi@neratec.com>
Cc: kvalo@qca.qualcomm.com, ath9k-devel@lists.ath9k.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <c884e319-e777-607e-492c-268b3f801d27@nbd.name> (sfid-20160514_150326_908502_BC523FB3)
Date: Sat, 14 May 2016 14:50:49 +0200
MIME-Version: 1.0
In-Reply-To: <1459503428-12492-1-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-01 11:37, Zefir Kurtisi wrote:
> Tx power limitations at upper layers are interpreted in
> the EIRP domain. When the user requests a given maximum
> txpower, e.g. with: 'iw phy0 set txpower fixed 1500',
> he expects the EIRP to be at or below 15dBm.
> 
> In ath9k_hw_apply_txpower(), the interpretation is
> different: the antenna-gain is capped against the
> current txpower limit in the regulatory, but not
> against the user set value. It ensures that the
> resulting EIRP is below the limit defined by the
> active countrycode, but not below the value the
> user requested.
> 
> In a scenario like e.g.
>  a) antenna_gain=6
>  b) countrycode limits to eirp=18
>  c) user set txpower=15
> this will cause a setting for AR_PHY_POWER_TX_RATE
> regs resulting in an EIRP > 15.
> 
> This patch ensures that antenna-gain is considered
> whenever the txpower limit is adjusted and with that
> the user set limits are kept.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
I just noticed this change and I believe it should be reverted. In many
cases the EEPROM antenna gain value does not accurately reflect the real
antenna gain and is used more as a worst case value to prevent exceeding
regulatory limits.

I believe using this to limit the user specified tx power values will
not only make this inconsistent with other drivers, but it will also
confuse users by using significantly lower tx power than they wanted.

The EEPROM antenna gain value is already causing more tx power reduction
than necessary, because AFAIK at least the FCC regulatory rules allow an
antenna gain of 3 dB while at the power limit, yet this is not
subtracted from the EEPROM antenna gain value when considering the limit.

- Felix
