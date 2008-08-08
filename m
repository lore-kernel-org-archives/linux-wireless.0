Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:37929 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYHHSSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 14:18:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so441220nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2008 11:18:00 -0700 (PDT)
To: Jochen Friedrich <jochen@scram.de>
Subject: Re: [PATCH] rt2x00: Fix txdone_entry_desc_flags
Date: Fri, 8 Aug 2008 20:44:30 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <489C65B7.9020305@scram.de>
In-Reply-To: <489C65B7.9020305@scram.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808082044.31123.IvDoorn@gmail.com> (sfid-20080808_201807_093271_43D9FFD8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 August 2008, Jochen Friedrich wrote:
> txdone_entry_desc_flags is used with __set_bit and test_bit which
> bit-shift the values, so don't bit-shift the flags in the enum.
> Also make sure flags are initialized before being used.

Good catch,

Applied to rt2x00.git

Thanks,

Ivo

> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  drivers/net/wireless/rt2x00/rt2x00queue.h |    8 ++++----
>  drivers/net/wireless/rt2x00/rt2x00usb.c   |    1 +
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index 01a6567..37f3f98 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -191,10 +191,10 @@ struct rxdone_entry_desc {
>   *	frame transmission failed due to excessive retries.
>   */
>  enum txdone_entry_desc_flags {
> -	TXDONE_UNKNOWN = 1 << 0,
> -	TXDONE_SUCCESS = 1 << 1,
> -	TXDONE_FAILURE = 1 << 2,
> -	TXDONE_EXCESSIVE_RETRY = 1 << 3,
> +	TXDONE_UNKNOWN,
> +	TXDONE_SUCCESS,
> +	TXDONE_FAILURE,
> +	TXDONE_EXCESSIVE_RETRY,
>  };
> 
>  /**
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 8d76bb2..2050227 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -181,6 +181,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
>  	 * (Only indirectly by looking at the failed TX counters
>  	 * in the register).
>  	 */
> +	txdesc.flags = 0;
>  	if (!urb->status)
>  		__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
>  	else


