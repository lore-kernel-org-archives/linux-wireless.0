Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbeGaJAs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:00:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] hostap: hide unused procfs helpers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180713070317.6724-1-yuehaibing@huawei.com>
References: <20180713070317.6724-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: <j@w1.fi>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
Message-Id: <20180731072152.D79D860376@smtp.codeaurora.org> (sfid-20180731_092320_232117_3D98A400)
Date: Tue, 31 Jul 2018 07:21:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

YueHaibing <yuehaibing@huawei.com> wrote:

> When CONFIG_PROC_FS isn't set, gcc warning this:
> 
> drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: ‘prism2_registers_proc_show’ defined but not used [-Wunused-function]
>  static int prism2_registers_proc_show(struct seq_file *m, void *v)
> 
> drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: ‘prism2_debug_proc_show’ defined but not used [-Wunused-function]
>  static int prism2_debug_proc_show(struct seq_file *m, void *v)
>             ^
> drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: ‘prism2_stats_proc_show’ defined but not used [-Wunused-function]
>  static int prism2_stats_proc_show(struct seq_file *m, void *v)
>             ^
> drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: ‘prism2_crypt_proc_show’ defined but not used [-Wunused-function]
>  static int prism2_crypt_proc_show(struct seq_file *m, void *v)
>             ^
> 
> fix this by adding #ifdef around them.
> hfa384x_read_reg is only used by prism2_registers_proc_show,so move it
> into #ifdef.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

6ade689711ee hostap: hide unused procfs helpers

-- 
https://patchwork.kernel.org/patch/10522651/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
