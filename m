Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:42494 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYHBFsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 01:48:52 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1474692ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 22:48:50 -0700 (PDT)
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] rt2x00: Fix compile warning
Date: Sat, 2 Aug 2008 08:11:35 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <200808020749.08431.IvDoorn@gmail.com> <20080801.223048.129067423.davem@davemloft.net>
In-Reply-To: <20080801.223048.129067423.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808020811.35701.IvDoorn@gmail.com> (sfid-20080802_074855_451699_5C5AE9CB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 August 2008, David Miller wrote:
> From: Ivo van Doorn <ivdoorn@gmail.com>
> Date: Sat, 2 Aug 2008 07:49:08 +0200
> 
> > rt2x00usb_vendor_request_large_buff is write-only, so it is
> > safe to make the argument a const.
> > 
> > Fixes compile warning:
> > drivers/net/wireless/rt2x00/rt73usb.c: In function 'rt73usb_load_firmware':
> > drivers/net/wireless/rt2x00/rt73usb.c:916: warning: passing argument 5 of 'rt2x00usb_vendor_request_large_buff' discards qualifiers from pointer target typ
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Are you sure?
> 
> This buffer pointer, via 'tb', eventually gets passed down
> to rt2x00usb_vendor_req_buff_lock which conditionally copies
> into the buffer.

Yes but rt2x00usb_vendor_req_buff_lock() can't use the const buffer since
it calls:
	memcpy(buffer, rt2x00dev->csr.cache, buffer_length);
and rt2x00usb_vendor_req_buff_lock() is valid for read commands.

Only rt2x00usb_vendor_request_large_buff() is write only, so that sounds like
the most sane place to convert the const pointer to the normal pointer.

Ivo
