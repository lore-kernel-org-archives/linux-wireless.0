Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:32936 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936730AbdDZPoE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 11:44:04 -0400
Received: by mail-wr0-f176.google.com with SMTP id w50so2524366wrc.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 08:44:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426085337.181AA61493@smtp.codeaurora.org>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com> <20170426085337.181AA61493@smtp.codeaurora.org>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 26 Apr 2017 08:44:01 -0700
Message-ID: <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com> (sfid-20170426_174520_975772_982121CD)
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 26, 2017 at 1:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
>> callback was actually cloned. So instead of checking for sufficient
>> headroom it should also be writable. Hence use skb_cow_head() to
>> check and expand the headroom appropriately.
>>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Steve, would you have time to run a quick test with this?
>
> Patch set to Deferred.
>

Happy to give it a quick spin on both of my platforms.

@Arend: is there some demonstrable before/after that shows a problem I
can detect at runtime?  I understand your thought about putting a
skb_clone() in there, but what are the expectations?  And is any
problem evident without explicitly modding the code with the clone?

- Steve
