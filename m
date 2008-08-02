Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53996
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYHBIbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 04:31:36 -0400
Date: Sat, 02 Aug 2008 01:31:36 -0700 (PDT)
Message-Id: <20080802.013136.211582180.davem@davemloft.net> (sfid-20080802_103138_706167_2307995B)
To: ivdoorn@gmail.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
Subject: Re: [PATCH] rt2x00: Fix compile warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808020811.35701.IvDoorn@gmail.com>
References: <200808020749.08431.IvDoorn@gmail.com>
	<20080801.223048.129067423.davem@davemloft.net>
	<200808020811.35701.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <ivdoorn@gmail.com>
Date: Sat, 2 Aug 2008 08:11:35 +0200

> Yes but rt2x00usb_vendor_req_buff_lock() can't use the const buffer since
> it calls:
> 	memcpy(buffer, rt2x00dev->csr.cache, buffer_length);
> and rt2x00usb_vendor_req_buff_lock() is valid for read commands.
> 
> Only rt2x00usb_vendor_request_large_buff() is write only, so that sounds like
> the most sane place to convert the const pointer to the normal pointer.

Ok, I see.  Patch applied, thanks!
