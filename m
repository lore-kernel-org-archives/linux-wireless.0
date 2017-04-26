Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:36500 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934607AbdDZJAk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:00:40 -0400
Received: by mail-qk0-f169.google.com with SMTP id u75so69138394qka.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 02:00:40 -0700 (PDT)
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: Kalle Valo <kvalo@codeaurora.org>,
        Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170426085337.293296148E@smtp.codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <634a239c-a7fe-05ad-7429-2ac4915c185d@broadcom.com> (sfid-20170426_110240_401096_9340CC5D)
Date: Wed, 26 Apr 2017 11:00:36 +0200
MIME-Version: 1.0
In-Reply-To: <20170426085337.293296148E@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/26/2017 10:53 AM, Kalle Valo wrote:
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

Just a hint. I tested the equivalent patch in brcmfmac by doing a 
skb_clone() just before the headroom if-statement (and a kfree_skb() 
afterwards obviously ;-) ).

Regards,
Arend
