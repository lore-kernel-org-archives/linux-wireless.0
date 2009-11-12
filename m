Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:22008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZKLQ1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 11:27:43 -0500
Received: by fg-out-1718.google.com with SMTP id d23so2127282fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 08:27:48 -0800 (PST)
Message-ID: <4AFC377F.6050507@lwfinger.net>
Date: Thu, 12 Nov 2009 10:27:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] p54usb: Remove DMA buffer from stack
References: <4afb5095.fKs+0FCQC9sTYyFW%Larry.Finger@lwfinger.net> <200911121051.11982.chunkeey@googlemail.com>
In-Reply-To: <200911121051.11982.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2009 03:51 AM, Christian Lamparter wrote:
> On Thursday 12 November 2009 01:02:29 Larry Finger wrote:
>> On 2.6.32-rc6 from wireless-testing, the following warning is emitted:
>>
>> ------------[ cut here ]------------ 
>> WARNING: at lib/dma-debug.c:860 check_for_stack+0xaa/0xe0() 
>> Hardware name: HP Pavilion dv2700 Notebook PC 
>> ehci_hcd 0000:00:02.1: DMA-API: device driver maps memory fromstack
>> 	 [addr=ffff8800b6e2bca8] 
-- snip --

> 
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> 
> FYI, p54u_upload_firmware_net2280 will likely produce the same
> same WARN, since "__le32 reg;" is held on the stack as well.

I was pretty certain that the WARN is only for DMA buffers on the stack. After
reviewing the code lib/dma-debug.c, nothing changed my mind. In
p54u_upload_firmware_net2280, the buffer is kmalloc'ed already. It should be OK.

Larry
