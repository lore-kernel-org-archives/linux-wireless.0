Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3466 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2F1LIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:08:15 -0400
Message-ID: <4FEC3B0E.3040001@broadcom.com> (sfid-20120628_130817_932480_C3340B96)
Date: Thu, 28 Jun 2012 13:07:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luciano Coelho" <coelho@ti.com>
cc: linux-wireless@vger.kernel.org, arik@wizery.com,
	"Eliad Peller" <eliad@wizery.com>
Subject: Re: [PATCH] wlcore: implement .flush callback
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
In-Reply-To: <1340813387-18407-1-git-send-email-coelho@ti.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2012 06:09 PM, Luciano Coelho wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> implement the .flush() callback by simply calling wl1271_tx_flush().
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> +static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
> +{
> +	struct wl1271 *wl = hw->priv;
> +
> +	wl1271_tx_flush(wl);
> +}
> +

So not taking the drop flag into account? Any plan to change that?

Gr. AvS

