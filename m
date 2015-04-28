Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53873 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbbD1QE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 12:04:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: sdio: bug: dead-lock in card reset
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
	<1428916704-9635-2-git-send-email-afenkart@gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com>
Date: Tue, 28 Apr 2015 19:04:52 +0300
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com>
	(Amitkumar Karwar's message of "Mon, 13 Apr 2015 03:27:25 -0700")
Message-ID: <87iocg5jdn.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_180502_750511_39FD7444)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> Hi Andreas,
>
> Thanks for the patch series.
>
>> 
>> Card reset is implemented by removing/re-adding the adapter instance.
>> This is implemented by removing the mmc host, which will then trigger a
>> cascade of removal callbacks including mwifiex_sdio_remove.
>> The dead-lock results in the latter function, trying to cancel the work
>> item executing the mmc host removal. This patch adds a driver level, not
>> adapter level, work struct to break the dead-lock
>> 
>> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
>> ---
>>  drivers/net/wireless/mwifiex/main.h |  1 -
>> drivers/net/wireless/mwifiex/sdio.c | 63 +++++++++++++++++++++++++++++--
>> ------
>>  2 files changed, 50 insertions(+), 14 deletions(-)
>> 
>
> We had recently submitted a patch to address this issue. So these two
> patches won't be needed now.
> http://www.spinics.net/lists/linux-wireless/msg135146.html
>
> Could you please check and let us know if you have any suggestions for
> improvement?

Ok, so we are talking about this commit which apparently fell through
the cracks:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2f5872b60146

Like I said as a reply to patch 1, using static variables for this is
ugly. Isn't there really any better way to handle the problem?

-- 
Kalle Valo
