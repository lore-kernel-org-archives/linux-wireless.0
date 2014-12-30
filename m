Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:65122 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaL3RS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 12:18:56 -0500
Received: by mail-la0-f41.google.com with SMTP id hv19so12840754lab.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2014 09:18:55 -0800 (PST)
Message-ID: <54A2DE7C.1050602@cogentembedded.com> (sfid-20141230_181922_603172_DE47A975)
Date: Tue, 30 Dec 2014 20:18:52 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	Ben Greear <greearb@candelatech.com>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Yanbo Li <yanbol@qti.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ath10k: a few incorrect return handling fix-up
References: <1419942046-17985-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1419942046-17985-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 12/30/2014 03:20 PM, Nicholas Mc Guire wrote:

> wait_for_completion_timeout does not return negative values so the tests
> for <= 0 are not needed and the case differentiation in the error handling
> path unnecessary.

    I decided to verify your statement and I saw that it seems wrong. 
do_wait_for_common() can return -ERESTARTSYS and the return value gets 
returned by its callers unchanged.

> patch was only compile tested x86_64_defconfig + CONFIG_ATH_CARDS=m
> CONFIG_ATH10K=m

> patch is against linux-next 3.19.0-rc1 -next-20141226

    Rather patches. It would have been better to send one patch instead of 4 
patches with the same name.

WBR, Sergei

