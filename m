Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52654 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932411AbeFTItM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:49:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id p126-v6so4653237wmb.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 01:49:12 -0700 (PDT)
Subject: Re: [PATCH] mac80211: Fix oops in ieee80211_tx_control_port
To: Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>,
        linux-wireless@vger.kernel.org
References: <20180619153950.28903-1-denkenz@gmail.com>
 <5B2A0772.4060200@broadcom.com> <1529481182.3130.2.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B2A0843.9080902@broadcom.com> (sfid-20180620_104921_106738_BC9C7676)
Date: Wed, 20 Jun 2018 09:54:43 +0200
MIME-Version: 1.0
In-Reply-To: <1529481182.3130.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/20/2018 9:53 AM, Johannes Berg wrote:
> On Wed, 2018-06-20 at 09:51 +0200, Arend van Spriel wrote:
>> On 6/19/2018 5:39 PM, Denis Kenzior wrote:
>>> On pre-emption enabled kernels the following oops was being seen due
>>> to missing local_bh_disable/local_bh_enable calls.  mac80211 assumes
>>> that pre-emption is disabled in the data path.
>>
>> No sure if "assumes" is the right term here. It seems like it is
>> required and there is probably a good reason for that. Would be nice to
>> know what that reason is.
>
> It's using per-CPU data.

Hence the smp_processor_id() call which Denis mentioned in the bug report?

Regards,
Arend
