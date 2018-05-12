Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55456 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeELID7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:03:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Andres Rodriguez <andresx7@gmail.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, hdegoede@redhat.com,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] firmware: print firmware name on fallback path
References: <20180423201205.20533-1-andresx7@gmail.com>
        <20180423201205.20533-7-andresx7@gmail.com>
        <20180503234235.GX27853@wotan.suse.de>
Date: Sat, 12 May 2018 11:03:52 +0300
In-Reply-To: <20180503234235.GX27853@wotan.suse.de> (Luis R. Rodriguez's
        message of "Thu, 3 May 2018 23:42:35 +0000")
Message-ID: <8736yxb8rb.fsf@codeaurora.org> (sfid-20180512_100414_138120_8064780F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(sorry for the delay, this got buried in my inbox)

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> On Mon, Apr 23, 2018 at 04:12:02PM -0400, Andres Rodriguez wrote:
>> Previously, one could assume the firmware name from the preceding
>> message: "Direct firmware load for {name} failed with error %d".
>> 
>> However, with the new firmware_request_nowarn() entrypoint, the message
>> outlined above will not always be printed.
>
> I though the whole point was to not print an error message. What if
> we want later to disable this error message? This would prove a bit
> pointless.
>
> Let's discuss the exact semantics desired here. Why would only the
> fallback be desirable here?
>
> Andres, Kalle?

So from ath10k point of view we do not want to have any messages printed
when calling firmware_request_nowarn(). The warnings get users really
confused when ath10k is checking if an optional firmware file is
available or not.

-- 
Kalle Valo
