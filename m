Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:44927 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754076AbdDZTyT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 15:54:19 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3QJo8LA002883
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 20:54:17 +0100
Received: from mail-wr0-f199.google.com (mail-wr0-f199.google.com [209.85.128.199])
        by mx08-00252a01.pphosted.com with ESMTP id 2a2ebe0epd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 20:54:17 +0100
Received: by mail-wr0-f199.google.com with SMTP id j27so1132640wre.3
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 12:54:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4d7ced43-4a95-f626-b66e-285c133c48c1@broadcom.com>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170426085337.181AA61493@smtp.codeaurora.org> <CALLGbR+dhPUjUJACQohnHd2RbN8BxrDeSz1SsVo2WAKYo5Gsuw@mail.gmail.com>
 <4d7ced43-4a95-f626-b66e-285c133c48c1@broadcom.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Wed, 26 Apr 2017 20:54:15 +0100
Message-ID: <CAE_XsM+XRcnO+tQEPnntNYVObnpJwimXP1_41aqJPwnxHWxonQ@mail.gmail.com> (sfid-20170426_215424_720510_AB408AF1)
Subject: Re: ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 April 2017 at 19:03, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
>
> On 26-4-2017 17:44, Steve deRosier wrote:
>> On Wed, Apr 26, 2017 at 1:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
>>>> callback was actually cloned. So instead of checking for sufficient
>>>> headroom it should also be writable. Hence use skb_cow_head() to
>>>> check and expand the headroom appropriately.
>>>>
>>>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>
>>> Steve, would you have time to run a quick test with this?
>>>
>>> Patch set to Deferred.
>>>
>>
>> Happy to give it a quick spin on both of my platforms.
>>
>> @Arend: is there some demonstrable before/after that shows a problem I
>> can detect at runtime?  I understand your thought about putting a
>> skb_clone() in there, but what are the expectations?  And is any
>> problem evident without explicitly modding the code with the clone?
>
> Ok. So the root cause is explained in a email to netdev mailing list,
> but I can not find it. The sender was probably not a member. I will
> forward that email to you and cc: linux-wireless. Basically, you need to
> setup a bridge and run hostapd in bridged mode. Incoming multicast
> traffic will be cloned by bridge and sent all interfaces in the bridge.
> If more than one driver puts additional payload in the headroom they are
> basically mucking about in the same buffer space so packets probably
> never end up in the devices. In case of ath6kl the patch is in area
> where driver/device determines IP checksum if it is supported (if I am
> not mistaken). So not sure how easy it is to replicate without patching
> it for testing.
>
> Regards,
> Arend

That was me. The full mechanism can be seen on the Raspberry Pi github
issue tracker  here

https://github.com/raspberrypi/firmware/issues/673

In brief, when bridging between two devices, if both devices fail to
'unclone' then
header corruption could occur if both the devices made header changes
since they are
both looking at the same data.

The Pi has a smsc9x ethernet device and the Brcm Wireless chip - both
had the fault, so we
were getting corrupted headers, and eventual failure of ethernet.

The same fault appears in a large subset of drivers in my brief examinations.

James
