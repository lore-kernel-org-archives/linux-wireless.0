Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37417 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3HONKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 09:10:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: clean up HTT tx tid handling
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-2-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 Aug 2013 16:07:28 +0300
In-Reply-To: <1376036014-29707-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 Aug 2013 10:13:32 +0200")
Message-ID: <87haer14rz.fsf@kamboji.qca.qualcomm.com> (sfid-20130815_151026_059267_D8D70959)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The tids weren't mapped really properly. This
> doesn't fix any known bug but seems the right
> thing to do.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>  enum htt_data_tx_ext_tid {
> -	HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST = 16,
> -	HTT_DATA_TX_EXT_TID_MGMT                = 17,
> +	HTT_DATA_TX_EXT_TID_NON_QOS_UNICAST     = 16,
> +	HTT_DATA_TX_EXT_TID_UNUSED              = 17,
> +	HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST = 18,
> +	HTT_DATA_TX_EXT_TID_MGMT                = 19,
>  	HTT_DATA_TX_EXT_TID_INVALID             = 31
>  };

This doesn't seem to match what firmware uses. We need to investigate
more about this so I drop the patch for now.

-- 
Kalle Valo
