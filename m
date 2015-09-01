Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52600 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbbIAPrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 11:47:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH] fixup! wil6210: system power management
References: <1441121050-8796-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Tue, 01 Sep 2015 18:47:47 +0300
In-Reply-To: <1441121050-8796-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Tue, 1 Sep 2015 18:24:10 +0300")
Message-ID: <87a8t6nnto.fsf@kamboji.qca.qualcomm.com> (sfid-20150901_174804_977601_BC1CD48A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Fix compilation warning where CONFIG_PM defined while
> CONFIG_PM_SLEEP is not defined
>
> Report follows:
>
> tree:   git://github.com/kvalo/ath pending
> head:   941145fc5e5afbb120271e5dfaf37213ddb55807
> commit: df596be39294d9712e5d568063a48448031e0a9f [37/39] wil6210: system power management
> config: xtensa-allyesconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout df596be39294d9712e5d568063a48448031e0a9f
>   # save the attached .config to linux build tree
>   make.cross ARCH=xtensa
>
> All warnings (new ones prefixed by >>):
>
>>> drivers/net/wireless/ath/wil6210/pcie_bus.c:264:12: warning: 'wil6210_suspend' defined but not used [-Wunused-function]
>     static int wil6210_suspend(struct device *dev, bool is_runtime)
>                ^
>>> drivers/net/wireless/ath/wil6210/pcie_bus.c:291:12: warning: 'wil6210_resume' defined but not used [-Wunused-function]
>     static int wil6210_resume(struct device *dev, bool is_runtime)
>                ^
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

BTW, that "fixup!" line won't work with public trees as I cannot rebase
them. Actually I didn't know about this git feature before. I'll fix the
title this time, but in the future don't use it.

-- 
Kalle Valo
