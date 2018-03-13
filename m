Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:59108 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbeCMUTU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 16:19:20 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [2/3] mwifiex: support sysfs initiated device coredump
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <5AA829A1.1090209@broadcom.com>
Date: Tue, 13 Mar 2018 21:19:18 +0100
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Bluetooth mailing list
        <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <24B25258-E680-490C-B7FF-D34CEBBA8566@holtmann.org> (sfid-20180313_211941_927592_7A96F1EB)
References: <1519210220-22437-3-git-send-email-arend.vanspriel@broadcom.com>
 <20180312094115.2E1C1606DB@smtp.codeaurora.org>
 <5AA67616.2000602@broadcom.com> <87efkoazow.fsf@kamboji.qca.qualcomm.com>
 <5AA829A1.1090209@broadcom.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>>>>> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
>>>>> it is possible to initiate a device coredump from user-space. This
>>>>> patch adds support for it adding the .coredump() driver callback.
>>>>> As there is no longer a need to initiate it through debugfs remove
>>>>> that code.
>>>>> 
>>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>> 
>>>> Based on the discussion I assume this is ok to take to w-d-next. If that's not
>>>> the case, please let me know ASAP.
>>> 
>>> It is up to the mwifiex maintainers to decide, I guess. The ABI
>>> documentation need to be revised and change the callback to void
>>> return type. I am not sure what the best approach is. 1) apply this
>>> and fix return type later, or 2) fix return type and resubmit this.
>>> What is your opinion?
>> 
>> I guess the callback change will go through Greg's tree? Then I suspect
>> it's easier that you submit the callback change to Greg first and wait
>> for it to trickle down to wireless-drivers-next (after the next merge
>> window) and then I can apply the driver patches. Otherwise there might
>> be a conflict between my and Greg's tree.
> 
> That was my assessment, but unfortunately Marcel already applied the btmrvl patch before I could reply. So how do I move from here? Option 1) revert brmrvl and fix callback return type, or 2) apply mwifiex patch and fix callback return type later for both drivers.

I can take the patch back out of bluetooth-next if needed. It is your call.

Regards

Marcel
