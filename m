Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbeCMNKq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 09:10:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [2/3] mwifiex: support sysfs initiated device coredump
References: <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
        <20180312094115.2E1C1606DB@smtp.codeaurora.org>
        <5AA67616.2000602@broadcom.com>
Date: Tue, 13 Mar 2018 15:10:39 +0200
In-Reply-To: <5AA67616.2000602@broadcom.com> (Arend van Spriel's message of
        "Mon, 12 Mar 2018 13:44:06 +0100")
Message-ID: <87efkoazow.fsf@kamboji.qca.qualcomm.com> (sfid-20180313_141104_919418_7112A961)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/12/2018 10:41 AM, Kalle Valo wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>
>>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>>> it is possible to initiate a device coredump from user-space. This
>>> patch adds support for it adding the .coredump() driver callback.
>>> As there is no longer a need to initiate it through debugfs remove
>>> that code.
>>>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Based on the discussion I assume this is ok to take to w-d-next. If that's not
>> the case, please let me know ASAP.
>
> It is up to the mwifiex maintainers to decide, I guess. The ABI
> documentation need to be revised and change the callback to void
> return type. I am not sure what the best approach is. 1) apply this
> and fix return type later, or 2) fix return type and resubmit this.
> What is your opinion?

I guess the callback change will go through Greg's tree? Then I suspect
it's easier that you submit the callback change to Greg first and wait
for it to trickle down to wireless-drivers-next (after the next merge
window) and then I can apply the driver patches. Otherwise there might
be a conflict between my and Greg's tree.

-- 
Kalle Valo
