Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9340 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525Ab0BYVAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 16:00:13 -0500
Subject: Re: [PATCH] rt2x00 : hw support txdone implementation.
From: Pavel Roskin <proski@gnu.org>
To: prahal@yahoo.com
Cc: John Linville <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <4B86CCC3.80403@yahoo.com>
References: <4B86CCC3.80403@yahoo.com>
Content-Type: text/plain
Date: Thu, 25 Feb 2010 16:00:00 -0500
Message-Id: <1267131600.16176.47.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-25 at 20:17 +0100, Alban Browaeys wrote:
> This is an implementation that support WCID being the key_index coming
> from benoit without the change in the meaning of the tx fallback flag.

This text is hard to understand without context.  Please use a
description for the changes contained in the patch, not for the
circumstances around it.  The same applies to the subject.  A space
before ":" is unnecessary.

> It replaces the software only implementation by an implementation
> supporting HW encryption.

So, I guess rt2800pci_txdone() would not work correctly if hardware
encryption is used?  Perhaps that should be explained.

> It fixes the mixes of usage of WCID behing set to the key_idx and
> then getting used as the entry index in the queue.

Maybe WCID could be expanded at least once?  "behing" must be a typo.

>   	/*
> -	 * During each loop we will compare the freshly read
> -	 * TX_STA_FIFO register value with the value read from
> -	 * the previous loop. If the 2 values are equal then
> -	 * we should stop processing because the chance it
> -	 * quite big that the device has been unplugged and
> -	 * we risk going into an endless loop.
> +	 * To avoid an endlees loop, we only read the TX_STA_FIFO register up
> +	 * to 256 times (this is enought to get all values from the FIFO). In
> +	 * normal situation, the loop is terminated when we reach a value with
> +	 * TX_STA_FIFO_VALID bit is 0.

Please spell check your comments.

I think using a different way for terminating the loop is a completely
separate issue not related to the hardware crypto support.  It should be
explained why the old code needs to be changed.

>   		/*
>   		 * Skip this entry when it contains an invalid
>   		 * queue identication number.
>   		 */
> -		type = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE) - 1;
> -		if (type >= QID_RX)
> +		if (pid < 1)
>   			continue;

I'm concerned that you are killing a valid check here.  pid should be
between 1 and QID_RX (inclusively).

It looks like you are replacing the existing code with your code instead
of improving it with a new check.  That alone could be a reason to
reject your patch.

> -			/*
> -			 * Catch up.
> -			 * Just report any entries we missed as failed.
> -			 */
> -			WARNING(rt2x00dev,
> -				"TX status report missed for entry %d\n",
> -				entry_done->entry_idx);

I'm concerned that you are removing this check.  Is this condition
impossible now or we just cannot detect it anymore?

> -		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
> -		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
> +		mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
> +		rt2x00_desc_read(txwi, 0, &word);
> +		tx_mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
>   		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
> -		txdesc.retry = mcs - min(mcs, real_mcs);
> +		txdesc.retry = tx_mcs - min(tx_mcs, mcs);

Maybe you could avoid renaming and redefining variables to make your
patch more readable?  Alternatively, you could do the renaming first in
a separate patch.  You can use interdiff to create a difference between
patches i.e. subtract the cleanups from the main patch.

-- 
Regards,
Pavel Roskin
