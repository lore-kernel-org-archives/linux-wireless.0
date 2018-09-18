Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbeIRRzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 13:55:00 -0400
Date: Tue, 18 Sep 2018 14:22:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] rt2x00: rework channel config function
Message-ID: <20180918122237.GC15481@redhat.com> (sfid-20180918_142242_708974_E148BF9C)
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
 <1537201975-3032-2-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1537201975-3032-2-git-send-email-pozega.tomislav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2018 at 06:32:52PM +0200, Tomislav Požega wrote:
> -	switch (rt2x00dev->default_ant.tx_chain_num) {
> -	case 3:
> -		/* Turn on tertiary PAs */
> -		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN,
> -				   rf->channel > 14);
> -		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
> -				   rf->channel <= 14);
> -		/* fall-through */
> -	case 2:
> -		/* Turn on secondary PAs */
> -		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
> -				   rf->channel > 14);
> -		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
> -				   rf->channel <= 14);
> -		/* fall-through */
> -	case 1:
> -		/* Turn on primary PAs */
> -		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN,
> -				   rf->channel > 14);
> -		if (rt2x00_has_cap_bt_coexist(rt2x00dev))
> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
> +		switch (rt2x00dev->default_ant.tx_chain_num) {
> +		case 3:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
> +		case 2:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
> +		case 1:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
> +		break;

Please keep /* fall-through */ comments, this is needed 
for some automatic code checkers tools.
