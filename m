Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38738 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932603AbdDZSDg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 14:03:36 -0400
Received: by mail-wm0-f42.google.com with SMTP id r190so12455775wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 11:03:35 -0700 (PDT)
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: Steve deRosier <derosier@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170426085337.181AA61493@smtp.codeaurora.org>
 <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4d7ced43-4a95-f626-b66e-285c133c48c1@broadcom.com> (sfid-20170426_200533_638614_A89EA983)
Date: Wed, 26 Apr 2017 20:03:31 +0200
MIME-Version: 1.0
In-Reply-To: <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26-4-2017 17:44, Steve deRosier wrote:
> On Wed, Apr 26, 2017 at 1:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
>>> callback was actually cloned. So instead of checking for sufficient
>>> headroom it should also be writable. Hence use skb_cow_head() to
>>> check and expand the headroom appropriately.
>>>
>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Steve, would you have time to run a quick test with this?
>>
>> Patch set to Deferred.
>>
> 
> Happy to give it a quick spin on both of my platforms.
> 
> @Arend: is there some demonstrable before/after that shows a problem I
> can detect at runtime?  I understand your thought about putting a
> skb_clone() in there, but what are the expectations?  And is any
> problem evident without explicitly modding the code with the clone?

Ok. So the root cause is explained in a email to netdev mailing list,
but I can not find it. The sender was probably not a member. I will
forward that email to you and cc: linux-wireless. Basically, you need to
setup a bridge and run hostapd in bridged mode. Incoming multicast
traffic will be cloned by bridge and sent all interfaces in the bridge.
If more than one driver puts additional payload in the headroom they are
basically mucking about in the same buffer space so packets probably
never end up in the devices. In case of ath6kl the patch is in area
where driver/device determines IP checksum if it is supported (if I am
not mistaken). So not sure how easy it is to replicate without patching
it for testing.

Regards,
Arend
