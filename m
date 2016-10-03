Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbcJCH3y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 03:29:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8xxxu: Fix rtl8723bu driver reload issue
References: <1475278518-18527-1-git-send-email-Jes.Sorensen@redhat.com>
        <1475278518-18527-2-git-send-email-Jes.Sorensen@redhat.com>
        <20161001115622.GB15156@kroah.com> <wrfjshsg5k21.fsf@redhat.com>
Date: Mon, 03 Oct 2016 10:29:49 +0300
In-Reply-To: <wrfjshsg5k21.fsf@redhat.com> (Jes Sorensen's message of "Sat, 01
        Oct 2016 08:29:42 -0400")
Message-ID: <87oa31sxea.fsf@kamboji.qca.qualcomm.com> (sfid-20161003_092958_330721_04C3EF46)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Greg KH <greg@kroah.com> writes:
>> On Fri, Sep 30, 2016 at 07:35:17PM -0400, Jes.Sorensen@redhat.com wrote:
>>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>> 
>>> The generic disable_rf() function clears bits 22 and 23 in
>>> REG_RX_WAIT_CCA, however we did not re-enable them again in
>>> rtl8723b_enable_rf()
>>> 
>>> This resolves the problem for me with 8723bu devices not working again
>>> after reloading the driver.
>>> 
>>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>>> ---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
>> for how to do this properly.
>>
>> </formletter>
>
> DOH Kalle told me to CC stable I took it for granted that you meant CC
> in the email sense. Guess I get to blame my self for looking like a
> fool in public.

Yes, I meant adding it to the commit log. This part of the stable
process is a bit confusing, I should have been more clear how this
works.

> I'll send you an email directly with the SHA once it hits Linus' tree
> instead.

No need, I'll add this to the commit log and the stable team will get
the commit automatically once the commit is in Linus' tree:

Cc: stable@vger.kernel.org # 4.7+

-- 
Kalle Valo
