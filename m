Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:45864 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbaJNSJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 14:09:06 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] zd1201: replace kmalloc/memset by kzalloc
References: <1413304831-7203-1-git-send-email-fabf@skynet.be>
	<1413306955.3269.30.camel@joe-AO725>
Date: Tue, 14 Oct 2014 20:08:34 +0200
In-Reply-To: <1413306955.3269.30.camel@joe-AO725> (Joe Perches's message of
	"Tue, 14 Oct 2014 10:15:55 -0700")
Message-ID: <87iojm8qxp.fsf@nemi.mork.no> (sfid-20141014_200929_975232_5C21C266)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> And does this really need to be alloc'd?

Yes, it does. It is used as a transfer_buffer in usb_fill_bulk_urb() and
must be "suitable for DMA".  From include/linux/usb.h:

/**
 * struct urb - USB Request Block
..
 * @transfer_buffer:  This identifies the buffer to (or from) which the I/O
 *      request will be performed unless URB_NO_TRANSFER_DMA_MAP is set
 *      (however, do not leave garbage in transfer_buffer even then).
 *      This buffer must be suitable for DMA; allocate it with
 *      kmalloc() or equivalent.  For transfers to "in" endpoints, contents
 *      of this buffer will be modified.  This buffer is used for the data
 *      stage of control transfers.



Bjørn
