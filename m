Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34776 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759359AbdEVMKF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 08:10:05 -0400
Received: by mail-wr0-f169.google.com with SMTP id l9so37255520wre.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 May 2017 05:09:55 -0700 (PDT)
Subject: Re: 4.12-RC2 BUG: scheduling while atomic: irq/47-iwlwifi
To: Johannes Berg <johannes@sipsolutions.net>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: netdev@vger.kernel.org
References: <a54f3f4f-2365-2154-ad18-82e4cd572aac@eikelenboom.it>
 <1495450628.2653.14.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <764a929c-ce8a-c859-a49e-2f20cb05ae44@broadcom.com> (sfid-20170522_141055_986416_026E3208)
Date: Mon, 22 May 2017 14:09:53 +0200
MIME-Version: 1.0
In-Reply-To: <1495450628.2653.14.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/22/2017 12:57 PM, Johannes Berg wrote:
> On Mon, 2017-05-22 at 12:36 +0200, Sander Eikelenboom wrote:
>> Hi,
>>
>> I encountered this splat with 4.12-RC2.
> 
> Ugh, yeah, I should've seen that in the review.
> 
> Arend, please take a look at this. cfg80211_sched_scan_results() cannot
> sleep, so you can't rtnl_lock() in there. Looks like you can just rely
> on RCU though?

I see. I think you are right on RCU. Don't have the code in front of me 
now, but I think the lookup has an ASSERT_RTNL. Will look into it after 
my monday meeting :-p

Regards,
Arend
