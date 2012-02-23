Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3794 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab2BWH2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 02:28:39 -0500
Message-ID: <4F45EA9E.4020404@gmail.com> (sfid-20120223_082843_058235_8EF579C9)
Date: Thu, 23 Feb 2012 08:28:30 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v3 2/2] rt2800pci: Fix 'Error - MCU request failed' during
 initialization
References: <1329944338-4696-1-git-send-email-kubakici@wp.pl> <1329944338-4696-2-git-send-email-kubakici@wp.pl>
In-Reply-To: <1329944338-4696-2-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/12 21:58, Jakub Kicinski wrote:
> Bring MCU operations during device initialization to sync
> with legacy driver.
> 
> This should fix following error:
> phy0 -> rt2800pci_mcu_status: Error - MCU request failed,
> no response from hardware
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> v3: move code from switch statement to appropriate function.
> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 891547c..ac874db 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -501,11 +501,27 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
>  
>  static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
>  {
> +	int retval;
> +
>  	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
>  		     rt2800pci_init_queues(rt2x00dev)))
>  		return -EIO;
>  
> -	return rt2800_enable_radio(rt2x00dev);
> +	retval = rt2800_enable_radio(rt2x00dev);
> +	if (retval)
> +		return retval;
> +
> +	/* After resume MCU_BOOT_SIGNAL will trash these. */
> +	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
> +	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
> +
> +	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF, 0xff, 0x02);
> +	rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
> +
> +	rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKEUP, 0, 0);
> +	rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
> +
> +	return retval;
>  }
>  
>  static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
> @@ -543,13 +559,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
>  
>  	switch (state) {
>  	case STATE_RADIO_ON:
> -		/*
> -		 * Before the radio can be enabled, the device first has
> -		 * to be woken up. After that it needs a bit of time
> -		 * to be fully awake and then the radio can be enabled.
> -		 */
> -		rt2800pci_set_state(rt2x00dev, STATE_AWAKE);
> -		msleep(1);
>  		retval = rt2800pci_enable_radio(rt2x00dev);
>  		break;
>  	case STATE_RADIO_OFF:


-- 
---
Gertjan
