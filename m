Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcICK2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:28:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: fix:rtl8xxxu_core: mark symbols static where possible
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1472314476-23351-1-git-send-email-baoyou.xie@linaro.org>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
Message-Id: <20160903102821.BFC0F62017@smtp.codeaurora.org> (sfid-20160903_122847_702389_E6B730B1)
Date: Sat,  3 Sep 2016 10:28:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Baoyou Xie <baoyou.xie@linaro.org> wrote:
> We get 1 warning about global functions without a declaration
> in the rtl8xxxu rtl8xxxu_core.c when building with W=1:
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:898:1: warning: no previous prototype for 'rtl8xxxu_gen1_h2c_cmd' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is declared
> and don't need a declaration, but can be made static.
> so this patch marks it 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

The title should be "rtl8xxxu: ". See:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject_name

Also I assume Jes will take this.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9302457/
