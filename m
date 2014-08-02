Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48098 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaHBGjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 02:39:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 2 Aug 2014 09:39:33 +0300
In-Reply-To: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 29 Jul 2014 12:03:59 +0200")
Message-ID: <87k36r5ra2.fsf@kamboji.qca.qualcomm.com> (sfid-20140802_083947_837841_ED02EF98)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The 10.x and main firmware branches have
> conflicting WMI service bitmap definitions.
>
> This also fixes WMI services parsing on big-endian
> hosts and changes debugfs output to be more human
> friendly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +	SVCSTR(WMI_SERVICE_TX_ENCAP)
> +	SVCSTR(WMI_SERVICE_BURST)
> +	SVCSTR(WMI_SERVICE_SMART_ANTENNA_SW_SUPPORT)
> +	SVCSTR(WMI_SERVICE_SMART_ANTENNA_HW_SUPPORT)
>  	default:
> -		return "UNKNOWN SERVICE\n";
> +		return NULL;

This introduces a new checkpatch warning:

drivers/net/wireless/ath/ath10k/wmi.h:214: ERROR: spaces required around that ':' (ctx:VxE)

But I think that's just a false warning and I should ignore it. Any
other ideas?

-- 
Kalle Valo
