Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35764 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbeHXTuc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 15:50:32 -0400
Received: by mail-oi0-f68.google.com with SMTP id m11-v6so16256448oic.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2018 09:15:14 -0700 (PDT)
Subject: Re: [Regression]BCM4312 is broken in kernel 4.18[Root cause found]
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>
Cc: prabhu <d.praabhu@gmail.com>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org
References: <CAHnrWRruLuuPN+bYc4NqO515W8+wHoCPH16ULsnJV_JrD+9oEw@mail.gmail.com>
 <20180823201147.393b1d53@wiggum> <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f9553dfe-d89b-0760-29c6-cdad29b54f6f@lwfinger.net> (sfid-20180824_181517_282819_54145254)
Date: Fri, 24 Aug 2018 11:15:12 -0500
MIME-Version: 1.0
In-Reply-To: <87lg8wjhqe.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2018 03:23 AM, Kalle Valo wrote:
> Michael Büsch <m@bues.ch> writes:
> 
>> On Thu, 23 Aug 2018 23:00:53 +0530
>> prabhu <d.praabhu@gmail.com> wrote:
>>
>>> The following commits introduce this regression in 4.18
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=66cffd6daab76caebab26eb803b92182414fc182
>>
>> Ok. Kalle, can you please revert the commit
>> 66cffd6daab76caebab26eb803b92182414fc182
>> ?
> 
> Please submit a proper patch with an explanation why it needs to be
> reverted.

Before doing a revert, let's see if we can keep the fix for open firmware, the 
situation for which commit 66cffd6daab7 was "needed". I think the following 
should do:

diff --git a/drivers/net/wireless/broadcom/b43/dma.c 
b/drivers/net/wireless/broadcom/b43/dma.c
index 6b0e1ec346cb..2c37366b3592 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -1519,12 +1519,14 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
                 } else {
                         /* More than a single header/data pair were missed.
                          * Report this error, and reset the controller to
-                        * revive operation.
+                        * revive operation. If running the open-source
+                        * firmware, then do a restart.
                          */
                         b43dbg(dev->wl,
                                "Out of order TX status report on DMA ring %d. 
Expected %d, but got %d\n",
                                ring->index, firstused, slot);
-                       b43_controller_restart(dev, "Out of order TX");
+                       if (dev->fw.opensource)
+                               b43_controller_restart(dev, "Out of order TX");
                         return;
                 }
         }

At the moment, I am working with prabhu to see if upgrading his firmware will 
help his problem with no change in the driver. If not, then I will have him test 
this patch.

Larry
