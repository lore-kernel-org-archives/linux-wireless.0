Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:49706 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYJHTiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 15:38:50 -0400
Received: by qw-out-2122.google.com with SMTP id 3so985864qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 12:38:49 -0700 (PDT)
Message-ID: <69e28c910810081238m612ece22l2c26b38a88aba608@mail.gmail.com> (sfid-20081008_213854_558900_CBA3F0BC)
Date: Wed, 8 Oct 2008 21:38:49 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC PATCH] rtl8187: do not report ACKs if USB Tx status is non-zero
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081008184205.GB32472@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223407098-23060-1-git-send-email-linville@tuxdriver.com>
	 <20081008184205.GB32472@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 8, 2008 at 8:42 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Oct 07, 2008 at 03:18:18PM -0400, John W. Linville wrote:
>> The vendor-supplied driver treats a USB Tx failure as an un-ACKed frame.
>> I don't see why we shouldn't do the same thing -- hopefully this makes
>> rate-scaling algorithms behave sanely with the rtl8187 driver.
>>
>> Thanks to Felix Fietkau <nbd@openwrt.org> for suggesting this as an
>> option.
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>> This is currently untested -- anyone with rtl8187 bored enough to try
>> it? :-)
>
> AFAICT, this doesn't actually trigger -- at least, the device can
> go into its typical failure mode (no frames ACKed until you force a
> lower rate) without ever hitting the "assume ACK not received" clause.
>
> I'll keep looking at it -- there are a couple of 'secrets' still
> buried in the vendor driver (if I can stomach to keep looking at it)...
>
> John
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Another weird thing: the code above essentially attempts to do this:
Wait for an ACK
If not TX_CTL_NO_ACK:
   If acked:
      Report the packet as acked.
   Endif
   If no ACK until timeout:
      Report packet as unacked
   Endif
Endif

This would be better, as it doesn't waste time waiting for an ACK for
unacked frames:

If not TX_CTL_NO_ACK:
Wait for an ACK
   If acked:
      Report the packet as acked.
   Endif
   If no ACK until timeout:
      Report packet as unacked
   Endif
Endif

Of course, this only works if "Wait for an ACK" actually works.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
