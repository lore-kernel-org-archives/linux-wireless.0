Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33775 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbbFOMio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 08:38:44 -0400
MIME-Version: 1.0
In-Reply-To: <20150612165829.GA22474@opentech.at>
References: <20150612165829.GA22474@opentech.at>
Date: Mon, 15 Jun 2015 16:38:43 +0400
Message-ID: <CA++WF2NoEAhRKnOXtC_C=JfmvZU=WuPEKZ3Zs2KxdHwBtHhHFg@mail.gmail.com> (sfid-20150615_143855_894296_89A371C7)
Subject: Re: [BUG ?] delay always evaluates to 0
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicholas,

On 12 June 2015 at 20:58, Nicholas Mc Guire <der.herr@hofr.at> wrote:
> Hi !
>
> commit 2c86c275015c ("Add ipw2100 wireless driver.") introduced
>
> drivers/net/wireless/ipw2100.c - line-numbers are from next-20150511
> 1410 static int ipw2100_hw_phy_off(struct ipw2100_priv *priv)
> 1411 {
> 1412
> 1413 #define HW_PHY_OFF_LOOP_DELAY (HZ / 5000)
> 1414
> ...
> 1437
> 1438                 schedule_timeout_uninterruptible(HW_PHY_OFF_LOOP_DELAY);
> 1439         }
>
> but (HZ / 5000) will evaluate to 0 for all configurable HZ values - typo ?
> and this schedule_timeout_uninterruptible() is probably not doing what
> is intended.

Yes, you are right. This is a bug. I think it should be:

-#define HW_PHY_OFF_LOOP_DELAY (HZ / 5000)
+#define HW_PHY_OFF_LOOP_DELAY (msecs_to_jiffies(50))

Will you send us a patch?

Stanislav.


>
> thx!
> hofrat
