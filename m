Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:50974 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3KJTPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Nov 2013 14:15:30 -0500
Received: by mail-la0-f43.google.com with SMTP id n7so2261326lam.2
        for <linux-wireless@vger.kernel.org>; Sun, 10 Nov 2013 11:15:29 -0800 (PST)
Message-ID: <527FDB50.1050902@cogentembedded.com> (sfid-20131110_201555_743836_F77D1B06)
Date: Sun, 10 Nov 2013 23:15:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Michal Nazarewicz <mpn@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] net: wireless: iwlwifi: remove minor dead code
References: <1384110397-24386-1-git-send-email-mpn@google.com>
In-Reply-To: <1384110397-24386-1-git-send-email-mpn@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 10-11-2013 23:06, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>

> inta is checked to be zero in a IRQ_NONE branch so afterwards it
> cannot be zero as it is never modified.

> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>   drivers/net/wireless/iwlwifi/pcie/rx.c | 23 ++++++++---------------
>   1 file changed, 8 insertions(+), 15 deletions(-)

> diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
> index 3f237b4..c32122a 100644
> --- a/drivers/net/wireless/iwlwifi/pcie/rx.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
[...]
> @@ -1150,7 +1149,13 @@ static irqreturn_t iwl_pcie_isr(int irq, void *data)
>   	 * or due to sporadic interrupts thrown from our NIC. */
>   	if (!inta) {
>   		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
> -		goto none;
> +		/* re-enable interrupts here since we don't have anything to
> +		 * service.  only Re-enable if disabled by irq and no
> +		 * schedules tasklet. */

    The preferred way of formatting the multi-line comments in the networking 
code is this:

/* bla
  * bla
  */

WBR, Sergei

