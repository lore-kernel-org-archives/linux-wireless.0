Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:57857 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZBSGW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 01:22:56 -0500
Received: by bwz5 with SMTP id 5so628761bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 22:22:54 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76c50x-usb: clean up DMA on stack
References: <c4d76b3b0902151837o797d850ajb883ce98338aa8a1@mail.gmail.com>
	<87prhfzgx7.fsf@litku.valot.fi> <1235013141.6344.6.camel@rainbow>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 19 Feb 2009 08:22:51 +0200
In-Reply-To: <1235013141.6344.6.camel@rainbow> (Jason Andryuk's message of "Wed\, 18 Feb 2009 22\:12\:21 -0500")
Message-ID: <87ocwzhrno.fsf@litku.valot.fi> (sfid-20090219_072302_019788_221385E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Wed, 2009-02-18 at 21:25 +0200, Kalle Valo wrote:
>> Jason Andryuk <jandryuk@gmail.com> writes:
>> 
>> > cleanup dma on stack issues
>> >
>> > - no DMA on stack
>> > - cleanup unclear endianness issue
>> >
>> > Corrected version of Oliver Neukum's original patch for at76_usb
>> 
>> Thanks, but the patch seems to be corrupted:
>> 
>> patching file drivers/net/wireless/at76c50x-usb.c
>> Hunk #1 FAILED at 580.
>> patch: **** malformed patch at line 90: *udev, u16 mib, void *buf,
>> 
>> Can you resend, please?

Thanks, this patch applied without problems.

You forgot to cc linux-wireless, adding it back.

> cleanup dma on stack issues
>
> - no DMA on stack

This looks good.

> - cleanup unclear endianness issue

I didn't find any endianness fixes from the patch. Did I just miss
them?

> @@ -1765,7 +1776,8 @@ static void at76_mac80211_stop(struct ieee80211_hw *hw)
>  	if (!priv->device_unplugged) {
>  		/* We are called by "ifconfig ethX down", not because the
>  		 * device is not available anymore. */
> -		at76_set_radio(priv, 0);
> +		if (at76_set_radio(priv, 0) == 1)
> +			at76_wait_completion(priv, CMD_RADIO_ON);

I think this is a separate from the dma issue and needs to have a
patch of it's own. I'll drop this part now.

I'll take the DMA part and do like with the previous patch, test it
and send it to John if everything is ok.

-- 
Kalle Valo
