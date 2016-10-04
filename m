Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server1.vittgam.net ([213.239.197.142]:63561 "EHLO
        mail.vittgam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbcJDSOV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 14:14:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Date: Tue, 04 Oct 2016 20:14:10 +0200
From: "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
        <ath9k-devel@venema.h4ckr.net>, <stable@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Move generic entries below specific ones in
 =?UTF-8?Q?ath=5Fpci=5Fid=5Ftable=2E?=
In-Reply-To: <87k2dop15n.fsf@kamboji.qca.qualcomm.com>
References: <ath9k-patch-20161003@vittgam.net>
 <87k2dop15n.fsf@kamboji.qca.qualcomm.com>
Message-ID: <cd3ff141b0ba69399a377a96a9ae75fb@vittgam.net> (sfid-20161004_201425_837274_34F71E73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 04/10/2016 17:46:44 CEST, Kalle Valo wrote:
> "Vittorio Gambaletta (VittGam)" <linux-wireless@vittgam.net> writes:
>
>> If generic entries are positioned above specific ones, then the
>> former will be matched first and used instead of the latter.
>>
>> Cc: <linux-wireless@vger.kernel.org>
>> Cc: <ath9k-devel@qca.qualcomm.com>
>> Cc: <ath9k-devel@lists.ath9k.org>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Vittorio Gambaletta <linuxbugs@vittgam.net>
>
> Why? What kind of bug you are fixing? You are not really describing the
> problem you are trying fix.

The active_high LED of my Wistron DNMA-92 is still being recognized as
active_low on 4.7.6 mainline.

When I was preparing my former patch to fix that, I initially added the
PCI_DEVICE_SUB section for 0x0029/0x2096 above the PCI_VDEVICE section
for 0x0029; but then I moved the former below the latter after seeing
how 0x002A sections were sorted in the file.

I must have somehow messed up with testing, because I tested the final
version of that patch before sending it, and it was apparently working;
but now it is not working on 4.7.6 mainline.

With this patch, 0x0029/0x2096 has finally got active_high LED on 4.7.6.

So, after seeing that the rest of the file is sorted this way (generic
section after the specific ones), I concluded that the 0x002A sorting
was wrong in the first place, and so is 0x0029. Then I sent this patch
to fix this.

> And your email headers look weird:
>
> To:     <kvalo@codeaurora.org>
> Cc:     <linux-wireless@vger.kernel.org>
> Cc:     <ath9k-devel@qca.qualcomm.com>
> Cc:     <ath9k-devel@venema.h4ckr.net>
> Cc:     <stable@vger.kernel.org>
> Date:   Mon, 3 Oct 2016 12:00:56 +0200
>
> What software are you using to send this? Only one CC header is valid
> according to the spec (thanks to Luca for checking) even though mailers
> seem to handle multiple CC headers. But for example my patchwork script
> fails with this and uses only the first CC header.

Sorry about this, I used a custom mailer to send the patch since I was
having problems with git-send-email...
