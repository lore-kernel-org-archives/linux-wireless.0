Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47766 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbHYM3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2015 08:29:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] mwifiex: fix mwifiex_rdeeprom_read()
References: <20150820103037.GA5521@mwanda>
Date: Tue, 25 Aug 2015 15:29:07 +0300
In-Reply-To: <20150820103037.GA5521@mwanda> (Dan Carpenter's message of "Thu,
	20 Aug 2015 13:30:37 +0300")
Message-ID: <87lhcz5z70.fsf@kamboji.qca.qualcomm.com> (sfid-20150825_142919_050473_CBAFAC41)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

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

I see a new warning:

drivers/net/wireless/mwifiex/debugfs.c:760:31: warning: pos may be used uninitialized in this function [-Wuninitialized]

Is it a valid warning or should I apply the patch anyway?

-- 
Kalle Valo
