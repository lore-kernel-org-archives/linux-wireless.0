Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58731 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaB1Rq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 12:46:58 -0500
Message-ID: <5310CB75.9030706@candelatech.com> (sfid-20140228_184712_133198_B5A8D55C)
Date: Fri, 28 Feb 2014 09:46:29 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: bartosz.markowski@tieto.com
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: Re: [PATCH] ath10k: add recalc RTS/CTS protection method
References: <1393571908-23734-1-git-send-email-marek.kwaczynski@tieto.com>
In-Reply-To: <1393571908-23734-1-git-send-email-marek.kwaczynski@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2014 11:18 PM, bartosz.markowski@tieto.com wrote:
> From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
> 
> Add recalculation of RTS/CTS protection when one or more legacy
> stations are connected to ath10k. In this case enable RTS/CTS
> protection and set sw retry profile are needed in the FW.
> Without this change legacy station is starved and has very low
> throughput.

> -			ath10k_warn("Failed to set CTS prot for VDEV: %d\n",
> -				    arvif->vdev_id);
> +			ath10k_warn("failed to recalc RTS/CTS prot %d\n",
> +				    ret);

Did you remove the vdev ID from the logging message on purpose?

I find having vdev ID in logging messages helps, especially when
trying to compare firmware logs with the driver logs...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

