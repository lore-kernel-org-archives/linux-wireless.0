Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:41603 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbeBHJVH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 04:21:07 -0500
Received: by mail-qk0-f180.google.com with SMTP id p23so4761352qke.8
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 01:21:07 -0800 (PST)
Subject: Re: [PATCH 4/6] qtnfmac: fix rmmod for missing firmware
To: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
 <20180205150516.16030-5-sergey.matyukevich.os@quantenna.com>
 <5A798F15.4050703@broadcom.com> <20180208090601.ornrxzwqy3rtt2ge@bars>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A7C1680.8030000@broadcom.com> (sfid-20180208_102113_432037_7C562835)
Date: Thu, 8 Feb 2018 10:21:04 +0100
MIME-Version: 1.0
In-Reply-To: <20180208090601.ornrxzwqy3rtt2ge@bars>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/8/2018 10:06 AM, Sergey Matyukevich wrote:
> Hello Arend,
>
> Thanks for review.
>
>>> Check that firmware exists prior to starting firmware download.
>>
>> Why would you do that? It seems expensive given that you obtain the
>> firmware and discard it immediately just to check it exists. Especially,
>> given that such a call can take 60 seconds to complete depending on
>> kernel config.
>>
>> Apart from that see minor comment below although I would seriously
>> reconsider this patch altogether.
>
> The idea behind this approach is simple: to quit early and to avoid starting
> asynchronous card boot if no firmware file exists. However I didn't realize that
> such a long delay may occur. What makes me worried is that the worst case
> scenario may happen if firmware actually exists: we make two calls of
> request_firmware, each of them taking long time.

The delay I mentioned here is when using FW_LOADER_USER_HELPER_FALLBACK 
option is selected and user-space is not handling the firmware request. 
This may happen when the driver is built-in and the user-space 
application is not yet started.

> I agree that it makes a lot of sense to reimplement this approach requesting
> firmware only once. Will do for v2.

Regards,
Arend
