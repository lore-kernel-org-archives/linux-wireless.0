Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:26050 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbZGZKKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 06:10:38 -0400
Message-ID: <4A6C2834.2010906@gentoo.org>
Date: Sun, 26 Jul 2009 15:41:04 +0545
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless drivers sparse warnings 07-24
References: <43e72e890907240922q3d7c9f0agfc8479008f9ba959@mail.gmail.com>
In-Reply-To: <43e72e890907240922q3d7c9f0agfc8479008f9ba959@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
>   CHECK   drivers/net/wireless/zd1211rw/zd_usb.c
> drivers/net/wireless/zd1211rw/zd_usb.c:367:24: warning: implicit cast
> from nocast type
> 
> I last tried to address this last one with Dan but I forget where we ended up.

I suggested that you avoid using a constant designed for register usage 
here because you are not dealing with register addresses (it is just a 
coincidence, perhaps intentional, that it is the same value as a related 
register address). i.e. change CR_INTERRUPT to 0x9510 or a new constant.

Daniel
