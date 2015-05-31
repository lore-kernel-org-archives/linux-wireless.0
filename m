Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:32931 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbbEaKBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 06:01:48 -0400
Received: by wicmx19 with SMTP id mx19so47407567wic.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 03:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433061092.2370.1.camel@sipsolutions.net>
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com> <1433061092.2370.1.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 31 May 2015 15:31:26 +0530
Message-ID: <CABPxzYK-8TtYdiFeFrX7AVcsXQFaa3oxHREq+jgohHh1tCg5GQ@mail.gmail.com> (sfid-20150531_121707_076104_04318233)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL messages.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 31, 2015 at 2:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-05-31 at 04:58 +0530, Chaitanya T K wrote:
>> cfg80211 reuses the skb before asking for a fresh on from genl framework,
>> this works efficiently for smaller messages but NLM_F_DUMP is normally
>> used to transport larger data normally > PAGE_SIZE, so if the message
>> occupies more than GOODSIZE its better to ask for a new, saves couple
>> of hanshakes with the driver.
>>
>> This improves the time to get the DUMP response across to user space.
>
> This doesn't make any sense. If the driver is slow to actually create
> the data, it should implement this logic, but realistically the driver
> should just check if there's enough space and only try to create data to
> put into the skb if it's sufficient?
>
> It sounds to me like you're actually interacting with the hardware at
> this point (otherwise it wouldn't be slow!) which pretty much seems
> wrong anyway.

In our case the data size is 411KB, and each message carries around 3072
bytes, so total messages would be 138. The first message we get, we
retrieve the data, and for subsequent messages we just fill the skb,
we are not interacting with the hardware.

Without this patch, heres the sequence:
genl->cfg80211->retrieve the dump from HW, skb_put: 3072
         cfg80211->skb_put, fail
genl->cfg80211->skb_put: 3072.

With this patch:

genl->cfg80211->retrive the dump from HW, skb_put: 3072
genl->cfg80211->skb_put: 3072.
