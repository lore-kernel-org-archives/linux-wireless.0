Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2748 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab3GKRIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 13:08:46 -0400
Message-ID: <51DEE68F.4060705@broadcom.com> (sfid-20130711_190851_212968_2ED7B3F6)
Date: Thu, 11 Jul 2013 19:08:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
cc: "Xenia Ragiadakou" <burzalodowa@gmail.com>,
	"OPW Kernel Interns List" <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	"Kalle Valo" <kvalo@qca.qualcomm.com>
Subject: Re: Help adding trace events to xHCI
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
In-Reply-To: <20130711162002.GA5240@xanatos>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2013 06:20 PM, Sarah Sharp wrote:
> On Mon, Jul 08, 2013 at 09:17:59PM +0300, Xenia Ragiadakou wrote:

>> But when there are other function calls before the callback call, I don't
>> no why but i cannot track anymore the position of the args following the
>> fmt argumenent in the stack with the pointer to fmt.
>
> I'm actually wondering if the call to ath6kl_printk is somehow necessary
> in order to be able to pass arguments on the stack.  Perhaps you should
> try defining a similar function for xHCI and see if that helps?

The ath6klk_printk() is not related to the trace function. It is a 
separate code path to get the message in the kernel log. I have seen 
these constructs before (and implemented it in brcmfmac) but it seems 
not very efficient when tracing as the printk can affect run-time behaviour.

> int ath6kl_printk(const char *level, const char *fmt, ...)
> {
> 	struct va_format vaf;
> 	va_list args;
> 	int rtn;
>
> 	va_start(args, fmt);
>
> 	vaf.fmt = fmt;
> 	vaf.va = &args;
>
> 	rtn = printk("%sath6kl: %pV", level, &vaf);
>
> 	va_end(args);
>
> 	return rtn;
> }
> EXPORT_SYMBOL(ath6kl_printk);
>
>> Anyway, something dirty like that will not enter the kernel but i will try
>> to do stack debugging on an example program to see why that happens.
>
> I would suggest just copy-pasting parts of the ath6kl trace code into
> the xHCI driver, and changing one of the xhci_dbg() calls to use that
> code, and see if it works.  If it doesn't work, send out an RFC patch
> (using the Cc list I've used), and we'll try to figure out what's going
> wrong.

The biggest challenge in adding tracepoints is identifying what you want 
to trace. While tracing debug messages can be convenient the real 
strength is in tracing code artifacts like for USB the thing that comes 
to my mind first is defining tracepoint for the urb and there are 
probably other internals that are informational.

Regards,
Arend

