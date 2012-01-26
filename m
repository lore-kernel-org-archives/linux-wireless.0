Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56552 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2AZOKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 09:10:32 -0500
Received: by bkas6 with SMTP id s6so460854bka.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 06:10:30 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Victor Goldenshtein <victorg@ti.com>
Subject: Re: [RFC 9/9] mac80211: add DFS support to monitor interface
Date: Thu, 26 Jan 2012 15:10:18 +0100
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-10-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-10-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201201261510.18387.chunkeey@googlemail.com> (sfid-20120126_151035_717559_CBC8173E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 26, 2012 01:38:04 PM Victor Goldenshtein wrote:
> Stop dropping packets if we are on 'radar channel'
> and the DFS is enabled/supported.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  net/mac80211/tx.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index edcd1c7..2c728a4 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1581,15 +1583,16 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  	 * flag.
>  	 *
>  	 * Since AP mode uses monitor interfaces to inject/TX management
> -	 * frames we can make AP mode the exception to this rule once it
> -	 * supports radar detection as its implementation can deal with
> -	 * radar detection by itself. We can do that later by adding a
> -	 * monitor flag interfaces used for AP support.
> +	 * frames we can make AP mode the exception to this rule, in the
> +	 * case the driver supports radar detection, allow usage of radar
> +	 * channels.
>  	 */

Hey, that's great!

I have one question: Wasn't the monitor interface [for AP mode] being
rendered obsolete by Johannes cfg80211-internal-ap-mlme work? If so,
then we could save us the work here, right?

BTW, what about cfg80211_can_beacon_sec_chan in net/wireless/chan.c?
I think it needs to be updated or else we can't have HT40 [secondary
channels] on frequencies which require DFS.

Regards,
	Chr
