Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38352 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758299Ab1DAQrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:47:37 -0400
Received: by ewy19 with SMTP id 19so1127173ewy.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 09:47:35 -0700 (PDT)
Subject: Re: [PATCH 2.6.40] wl12xx: fix potential buffer overflow in
 testmode nvs push
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1301676400-4912-1-git-send-email-coelho@ti.com>
References: <1301676400-4912-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 19:48:14 +0300
Message-ID: <1301676494.1988.492.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 19:46 +0300, Luciano Coelho wrote:
> We were allocating the size of the NVS file according to the chip ID
> and not checking whether the length of the buffer passed was correct
> before copying it into the allocated memory.  This is a security hole
> because buffer overflows can occur if the userspace passes a bigger
> file than what is expected.
> 
> With this patch, we check if the size of the data passed from
> userspace matches the size required by the chip.
> 
> Reported-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

I'll merge this change so that it fits with the one I sent for 2.6.39
and stable, when time comes.  For now, we don't want things overflowing
in the wl12xx.git tree either, so fix it there too. ;)

-- 
Cheers,
Luca.

