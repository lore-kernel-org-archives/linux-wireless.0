Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37778 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbbI2IJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 04:09:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: fix mwifiex_rdeeprom_read()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150921161953.GQ5004@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20150929080908.CC1F813F7C4@smtp.codeaurora.org> (sfid-20150929_100917_467239_2C752D85)
Date: Tue, 29 Sep 2015 08:09:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> There were several bugs here.
> 
> 1)  The done label was in the wrong place so we didn't copy any
>     information out when there was no command given.
> 
> 2)  We were using PAGE_SIZE as the size of the buffer instead of
>     "PAGE_SIZE - pos".
> 
> 3)  snprintf() returns the number of characters that would have been
>     printed if there were enough space.  If there was not enough space
>     (and we had fixed the memory corruption bug #2) then it would result
>     in an information leak when we do simple_read_from_buffer().  I've
>     changed it to use scnprintf() instead.
> 
> I also removed the initialization at the start of the function, because
> I thought it made the code a little more clear.
> 
> Fixes: 5e6e3a92b9a4 ('wireless: mwifiex: initial commit for Marvell mwifiex driver')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
