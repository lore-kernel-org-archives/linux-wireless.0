Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:53075 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S945128AbdDTM03 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 08:26:29 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3KC8c8d002142
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 13:09:21 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx07-00252a01.pphosted.com with ESMTP id 29wqp2rt9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 13:09:21 +0100
Received: by mail-wr0-f200.google.com with SMTP id n5so5404858wrb.7
        for <linux-wireless@vger.kernel.org>; Thu, 20 Apr 2017 05:09:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y3uv48nv.fsf@kamboji.qca.qualcomm.com>
References: <20170420111651.10213-1-james.hughes@raspberrypi.org> <87y3uv48nv.fsf@kamboji.qca.qualcomm.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Thu, 20 Apr 2017 13:09:20 +0100
Message-ID: <CAE_XsMJGpKKdZ4E90tkzYwe+7KJ8JB5Rwrzga6aUi1LZG+wH4w@mail.gmail.com> (sfid-20170420_142633_189741_789495B9)
Subject: Re: [PATCH] brcm80211: brcmfmac: Ensure that incoming skb's are writable
To: Kalle Valo <kvalo@codeaurora.org>
Cc: netdev@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 April 2017 at 12:31, Kalle Valo <kvalo@codeaurora.org> wrote:
> + linux-wireless
>
> James Hughes <james.hughes@raspberrypi.org> writes:
>
>> The driver was adding header information to incoming skb
>> without ensuring the head was uncloned and hence writable.
>>
>> skb_cow_head has been used to ensure they are writable, however,
>> this required some changes to error handling to ensure that
>> if skb_cow_head failed it was not ignored.
>>
>> This really needs to be reviewed by someone who is more familiar
>> with this code base to ensure any deallocation of skb's is
>> still correct.
>>
>> Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
>
> You should also CC linux-wireless, otherwise patchwork won't see it.
>
> --
> Kalle Valo

Thanks Kalle, I wasn't subscribed to wireless, but have now done so. I
also failed to read the MAINTAINERS list correctly..

With regard to this particular patch, this is related to the recent
patches to use skb_cow_head in a number of USB net drivers to ensure
they can write headers correctly, and I suspect the same fault is
possible/likely in other drivers outside the USB net realm, as this
patch shows.

I'm not overly happy with the error handling in this patch, but that
said, the error handling over this entire driver does strike me as
suspect. Quite a few places where return codes are ignored, just in my
quick examination. So not really sure how to proceed past this patch,
if at all.
