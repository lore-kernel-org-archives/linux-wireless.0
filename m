Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsec115.isp.belgacom.be ([195.238.20.111]:36893 "EHLO
	mailsec115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbaJPIIw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 04:08:52 -0400
Date: Thu, 16 Oct 2014 10:08:50 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>,
	=?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Message-ID: <346236957.6316.1413446930736.open-xchange@webmail.nmp.skynet.be> (sfid-20141016_100925_073049_E056D38E)
In-Reply-To: <87iojm8qxp.fsf@nemi.mork.no>
References: <1413304831-7203-1-git-send-email-fabf@skynet.be> <1413306955.3269.30.camel@joe-AO725> <87iojm8qxp.fsf@nemi.mork.no>
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by
 kzalloc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On 14 October 2014 at 20:08 Bjørn Mork <bjorn@mork.no> wrote:
>
>
> Joe Perches <joe@perches.com> writes:
>
> > And does this really need to be alloc'd?
>
> Yes, it does. It is used as a transfer_buffer in usb_fill_bulk_urb() and
> must be "suitable for DMA".  From include/linux/usb.h:
>
> /**
>  * struct urb - USB Request Block
> ..
>  * @transfer_buffer:  This identifies the buffer to (or from) which the I/O
>  *      request will be performed unless URB_NO_TRANSFER_DMA_MAP is set
>  *      (however, do not leave garbage in transfer_buffer even then).
>  *      This buffer must be suitable for DMA; allocate it with
>  *      kmalloc() or equivalent.  For transfers to "in" endpoints, contents
>  *      of this buffer will be modified.  This buffer is used for the data
>  *      stage of control transfers.
>
>

Adding a structure would be a nice design update indeed but this would require
some testing...Separate patch maybe ?
 
Fabian

>
> Bjørn
