Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39503 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbcCNGPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 02:15:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	joe@perches.com
Subject: Re: [v2, resend] b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init
References: <1452949690-16387-1-git-send-email-baijiaju1990@163.com>
	<20160311162230.GA5436@sudip-laptop> <20160311173047.785c2b24@wiggum>
Date: Mon, 14 Mar 2016 08:15:33 +0200
In-Reply-To: <20160311173047.785c2b24@wiggum> ("Michael =?utf-8?Q?B=C3=BCs?=
 =?utf-8?Q?ch=22's?= message of
	"Fri, 11 Mar 2016 17:30:47 +0100")
Message-ID: <87egbdmvp6.fsf@kamboji.qca.qualcomm.com> (sfid-20160314_071543_142585_427EE68D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Büsch <m@bues.ch> writes:

> On Fri, 11 Mar 2016 21:52:30 +0530
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
>> On Sat, Jan 16, 2016 at 09:08:10PM +0800, Jia-Ju Bai wrote:
>> > The memory allocated by kzalloc in b43_bus_dev_ssb_init and
>> > b43_bus_dev_bcma_init is not freed.
>> > This patch fixes the bug by adding kfree in b43_ssb_remove,
>> > b43_bcma_remove and error handling code of b43_bcma_probe.
>> > 
>> > Thanks Michael for his suggestion.
>> > 
>> > Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>  
>> 
>> The patch did not apply cleanly. I had to edit the patch to point to
>> drivers/net/wireless/broadcom/b43/main.c
>> 
>> For CONFIG_B43_SSB part-
>> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>
>
> Ok thanks a lot.
> We possibly don't get an bcma tester anytime soon. As this is quite an
> important fix, we should probably apply it.
>
> Sudip, can you please update the patch so it applies cleanly on the
> current tree? You can add my acked-by if you want.
>
> Kalle, can you please apply it afterwards?

Will do.

-- 
Kalle Valo
