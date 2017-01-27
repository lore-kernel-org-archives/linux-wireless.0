Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43266 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754837AbdA0NLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 08:11:05 -0500
Subject: Re: [PATCH 4/4] ath9k: fix race condition in enabling/disabling IRQs
To: linux-wireless@vger.kernel.org
References: <20170125163654.66431-1-nbd@nbd.name>
 <20170125163654.66431-4-nbd@nbd.name>
Cc: kvalo@codeaurora.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <ca32601f-81f1-aec0-9ab4-02631b226900@nbd.name> (sfid-20170127_141147_018290_2F6BB7EE)
Date: Fri, 27 Jan 2017 13:47:06 +0100
MIME-Version: 1.0
In-Reply-To: <20170125163654.66431-4-nbd@nbd.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-25 17:36, Felix Fietkau wrote:
> The code currently relies on refcounting to disable IRQs from within the
> IRQ handler and re-enabling them again after the tasklet has run.
> 
> However, due to race conditions sometimes the IRQ handler might be
> called twice, or the tasklet may not run at all (if interrupted in the
> middle of a reset).
> 
> This can cause nasty imbalances in the irq-disable refcount which will
> get the driver permanently stuck until the entire radio has been stopped
> and started again (ath_reset will not recover from this).
> 
> Instead of using this fragile logic, change the code to ensure that
> running the irq handler during tasklet processing is safe, and leave the
> refcount untouched.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
Please don't apply this yet, it looks like it might cause some
regressions on other devices. I will investigate.

- Felix
