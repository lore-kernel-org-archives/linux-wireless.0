Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28218 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1JMG0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 02:26:02 -0400
Message-ID: <4E96846A.3020205@qca.qualcomm.com> (sfid-20111013_082607_421259_817E17D2)
Date: Thu, 13 Oct 2011 09:25:46 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix firmware start address for ar6003 hw2.0
References: <1317906725-31130-1-git-send-email-sangwook.lee@linaro.org>	<4E953FDB.9090709@qca.qualcomm.com> <CADPsn1bWC6=dgoUn7_1--a=jcNHq0Hw6Drmg+8HcY5xPLVrSBA@mail.gmail.com>
In-Reply-To: <CADPsn1bWC6=dgoUn7_1--a=jcNHq0Hw6Drmg+8HcY5xPLVrSBA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sangwook,

On 10/12/2011 01:45 PM, Sangwook Lee wrote:
>>>> Before I'm able to find a hw 2.0 device, can you try to debug this more?
>>>> When scanning fails can check if ath6kldev_intr_bh_handler() is called
>>>> or not? When scanning fails it usually happens because irqs are failing.
> 
> Yes, it seems true. when scanning fails. it failed to receive no more sdio irqs.

Do you get any interrupts at all from ar6003?

> For the temporary testing, I made sdio polling kernel thread and then let it
> call ath6kldev_intr_bh_handler(). With hw2.0, it works fine with
> scanning issue.
> Do you know any ideas to solve this problem clearly ?

Sorry, I don't have any ideas right now. I have seen interrupt problems
before but they have always been due to a problem in the SDIO
controller. I don't know if your problem is an SDIO controller problem
or just related to hw2.0.

Kalle
