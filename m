Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38901 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AXVHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 16:07:17 -0500
Received: by mail-ea0-f175.google.com with SMTP id d1so4065910eab.20
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2013 13:07:16 -0800 (PST)
References: <20130124205931.GB16252@localhost.localdomain> <20130124210028.GA22800@localhost.localdomain> <20130124210110.GB22800@localhost.localdomain>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130124210110.GB22800@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5DAD0E2C-8F78-41C9-B6AB-8B75A4165A54@gmail.com> (sfid-20130124_220722_191721_CDF9208A)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/4] rt2800usb: move "TX status missed" messages to debug level
Date: Thu, 24 Jan 2013 22:07:06 +0100
To: Stanislaw Gruszka <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 24 jan. 2013, at 22:01, Stanislaw Gruszka <stf_xl@wp.pl> wrote:

> Those messages can flood in dmesg, so do not print them by default.
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>


> ---
> drivers/net/wireless/rt2x00/rt2800usb.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 011410f..047ead5 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -540,9 +540,9 @@ rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
>    tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> 
>    if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
> -        WARNING(entry->queue->rt2x00dev,
> -            "TX status report missed for queue %d entry %d\n",
> -            entry->queue->qid, entry->entry_idx);
> +        DEBUG(entry->queue->rt2x00dev,
> +              "TX status report missed for queue %d entry %d\n",
> +              entry->queue->qid, entry->entry_idx);
>        return TXDONE_UNKNOWN;
>    }
> 
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
