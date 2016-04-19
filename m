Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41965 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbcDSQN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 12:13:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2] ath9k: interpret requested txpower in EIRP domain
References: <201604011711.RmqSBtrr%fengguang.wu@intel.com>
	<1459503428-12492-1-git-send-email-zefir.kurtisi@neratec.com>
Date: Tue, 19 Apr 2016 19:13:52 +0300
In-Reply-To: <1459503428-12492-1-git-send-email-zefir.kurtisi@neratec.com>
	(Zefir Kurtisi's message of "Fri, 1 Apr 2016 11:37:08 +0200")
Message-ID: <87inzdinjz.fsf@kamboji.qca.qualcomm.com> (sfid-20160419_181400_549442_944AFA6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

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

Applied, thanks.

-- 
Kalle Valo
