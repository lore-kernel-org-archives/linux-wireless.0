Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13311 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaIWNYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 09:24:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: save firmware stacks upon firmware crash
References: <1409934849-23078-1-git-send-email-greearb@candelatech.com>
Date: Tue, 23 Sep 2014 16:23:57 +0300
In-Reply-To: <1409934849-23078-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Fri, 5 Sep 2014 09:34:08
	-0700")
Message-ID: <87vboecvwy.fsf@kamboji.qca.qualcomm.com> (sfid-20140923_152418_194150_FCAEAFEA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Should help debug firmware crashes, and give users a way
> to provide some useful debug reports to firmware developers.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Like we talked on IRC, I think it's better to take a dump of the whole
DRAM and find all the info during postprocessing in user space. I just
consider it too much work to investigate firmware internals from ath10k
as the internals can change between firmware versions. In user space
that's a lot easier to manage.

Of course downside is the increased memory usage, but if that becomes a
problem there are ways to solve that. For example, adding a module
parameter with bitmask for individually enabling enum
ath10k_fw_crash_dump_type is first which comes to my mind.

I have patches ready for the DRAM thing, but I have some issues which I
found during testing. I'll post the patches soon as I have solved the
issues, but don't know how long that will take.

-- 
Kalle Valo
