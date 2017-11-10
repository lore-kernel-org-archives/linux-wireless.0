Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41402 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755575AbdKJCcm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:32:42 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00usb: mark device removed when get ENOENT usb error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171109105917.GA3206@redhat.com>
References: <20171109105917.GA3206@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Message-Id: <20171110023242.0DBF0601D1@smtp.codeaurora.org> (sfid-20171110_033245_243108_9F7B9941)
Date: Fri, 10 Nov 2017 02:32:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> ENOENT usb error mean "specified interface or endpoint does not exist or
> is not enabled". Mark device not present when we encounter this error
> similar like we do with ENODEV error.
> 
> Otherwise we can have infinite loop in rt2x00usb_work_rxdone(), because
> we remove and put again RX entries to the queue infinitely.
> 
> We can have similar situation when submit urb will fail all the time
> with other error, so we need consider to limit number of entries
> processed by rxdone work. But for now, since the patch fixes
> reproducible soft lockup issue on single processor systems
> and taken ENOENT error meaning, let apply this fix.
> 
> Patch adds additional ENOENT check not only in rx kick routine, but
> also on other places where we check for ENODEV error.
> 
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
> Debugged-by: Richard Genoud <richard.genoud@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Tested-by: Richard Genoud <richard.genoud@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

bfa62a52cad9 rt2x00usb: mark device removed when get ENOENT usb error

-- 
https://patchwork.kernel.org/patch/10050781/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
