Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:21055 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbK2C5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2015 21:57:22 -0500
To: andy.shevchenko@gmail.com, motobud@gmail.com
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath6kl@lists.infradead.org
Subject: Re: [PATCH] ath6kl: Use vmalloc for loading firmware using api1 method
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1444972259-24260-1-git-send-email-motobud@gmail.com>
	<CAP+RiCA6wasaiMCYEJ-8gaiVMi5JP2JT6A1bGm9nHJ9CA+Ow5g@mail.gmail.com>
	<CAHp75VcVdMNrxvedCB_OmJw7upTPJq8T8tKxfBn_moYGj6S19g@mail.gmail.com>
In-Reply-To: <CAHp75VcVdMNrxvedCB_OmJw7upTPJq8T8tKxfBn_moYGj6S19g@mail.gmail.com>
Message-Id: <201511291156.IJG90618.VFOQSHFOMOFtJL@I-love.SAKURA.ne.jp> (sfid-20151129_035815_001913_6C8C2EB0)
Date: Sun, 29 Nov 2015 11:56:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko wrote:
> On Sat, Nov 28, 2015 at 8:58 PM, Brent Taylor <motobud@gmail.com> wrote:
> > Whats the status on this patch?  I don't see it on patchwork anymore
> > nor is it in any of the git trees I checked.
> >
> 
> You forget to use kvfree() instead of kfree() in core.c.
> 

In addition to that, I think you can do like below.

	if (&ar->fw == fw)
		*fw = vmalloc(fw_entry->size);
	else
		*fw = kmalloc(fw_entry->size, GFP_KERNEL);
	if (*fw == NULL)
		ret = -ENOMEM;
	else
		memcpy(*fw, fw_entry->data, fw_entry->size);
