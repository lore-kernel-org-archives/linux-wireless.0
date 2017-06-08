Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36303 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFHRKL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 13:10:11 -0400
Received: by mail-lf0-f65.google.com with SMTP id x81so3535375lfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jun 2017 10:10:10 -0700 (PDT)
Subject: Re: [PATCH 1/1] mac80211: ieee80211_rx_napi: remove warning
To: Johannes Berg <johannes@sipsolutions.net>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <1496581915-4412-1-git-send-email-erik.stromdahl@gmail.com>
 <1496581915-4412-2-git-send-email-erik.stromdahl@gmail.com>
 <1496872642.3291.4.camel@sipsolutions.net>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <9a570231-00c2-e234-8ac8-fbee66bd07af@gmail.com> (sfid-20170608_191015_136468_7878B94E)
Date: Thu, 8 Jun 2017 19:10:08 +0200
MIME-Version: 1.0
In-Reply-To: <1496872642.3291.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017-06-07 23:57, Johannes Berg wrote:
> On Sun, 2017-06-04 at 15:11 +0200, Erik Stromdahl wrote:
>> The softirq count is not always incremented during driver
>> operation. This is the case for usb and sdio network
>> drivers.
> 
> I'm pretty sure the warning is correct, and we do rely on having
> local_bh_disable(), otherwise we may end up taking a soft-IRQ and I
> believe there are some things that could get messed up in that case.
> 
Ok, I will make sure to increment the softirq counter before calling
ieee80211_rx then.

> So - I think the warning is there for a reason, and drivers should just
> local_bh_disable() before calling into that. What's wrong with that?
I guess there is nothing wrong with that, it's just that ath10k does not
call local_bh_disable anywhere in the code.
I guess it is relying on lower layers (pcie?) to do that.
When introducing sdio and usb support these calls will have to be added
explicitly in ath10k.

> 
> johannes
> 
