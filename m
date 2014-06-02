Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:51722 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751951AbaFBQ2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 12:28:37 -0400
Message-ID: <1401726505.5770.2.camel@joe-AO725> (sfid-20140602_182840_474961_B93B661A)
Subject: Re: [PATCH 1/1] rsi: Adding support for bgscan, 5GHz support and
 clean up of code
From: Joe Perches <joe@perches.com>
To: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Jun 2014 09:28:25 -0700
In-Reply-To: <538C910E.6090703@redpinesignals.com>
References: <538C910E.6090703@redpinesignals.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-02 at 20:28 +0530, Jahnavi Meher wrote:
> This patch adds code for support of bgscan and 5GHz.
[]
> There are also a number of small clean ups.

[]

> diff -uprN b/drivers/net/wireless/rsi/rsi_91x_mac80211.c a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
[]
> @@ -243,8 +243,8 @@ static void rsi_mac80211_tx(struct ieee8
>  {
>  	struct rsi_hw *adapter = hw->priv;
>  	struct rsi_common *common = adapter->priv;
> -
>  	rsi_core_xmit(common, skb);
> +	return;
>  }

Adding unnecessary returns at the end of a void function
is not an improvement.


