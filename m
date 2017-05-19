Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33841 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdESPc4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 11:32:56 -0400
Received: by mail-wr0-f180.google.com with SMTP id l9so19346769wre.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 08:32:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wp9durwe.fsf@kamboji.qca.qualcomm.com>
References: <1493217698-22451-1-git-send-email-c_vnaral@qti.qualcomm.com>
 <40f2b7a2-7276-6de6-afc6-407348c92e70@nbd.name> <87wp9durwe.fsf@kamboji.qca.qualcomm.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Fri, 19 May 2017 08:32:54 -0700
Message-ID: <CAJ-Vmok6UXVpYfK5c_tDnFGN1uLfx+sGp0W2zFppB=TYtax72g@mail.gmail.com> (sfid-20170519_173300_356433_4FB5D671)
Subject: Re: [PATCH] ath10k : Fix channel survey dump
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "nbd@nbd.name" <nbd@nbd.name>,
        Venkateswara Naralasettty <vnaralas@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 May 2017 at 02:17, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Felix Fietkau <nbd@nbd.name> writes:
>
>> On 2017-04-26 16:41, Venkateswara Rao Naralasetty wrote:
>>> Channel active/busy time are showing incorrect
>>> (less than previous or sometimes zero) for
>>> successive survey dump command.

[snip]

>> Does the firmware read the registers directly, or does it accumulate
>> the results in a way that can't overflow? If you don't clear the
>> counters on reset, the overflow will be problematic for the
>> current-channel stats. I think a better approach would be to use
>> READ_CLEAR for in-use channels and store the sum inside the driver.
>
> Venkateswara, any comments?

I just bumped into this at work. I'm thinking of teaching mac80211
about optionally summing things so each driver doesn't need another
per-channel array.



-adrian
