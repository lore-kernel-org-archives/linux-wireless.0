Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:38715 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbdH2RcM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 13:32:12 -0400
Received: by mail-yw0-f196.google.com with SMTP id e9so2484428ywh.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Aug 2017 10:32:12 -0700 (PDT)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: rtlwifi handling of sequence numbers with aggregation
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
References: <17ea196f-2f77-5110-8f33-4a25765ad34e@gmail.com>
 <a258b2fa-c960-88db-5934-af4c0f4b6435@lwfinger.net>
 <a1d2f17d-dca5-d6c1-f489-74f69e0f146b@lwfinger.net>
Message-ID: <57ffe7af-6ed0-01f3-1722-c722e4a099bd@gmail.com> (sfid-20170829_193215_507753_EEDF76A7)
Date: Tue, 29 Aug 2017 13:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <a1d2f17d-dca5-d6c1-f489-74f69e0f146b@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2017 10:18 AM, Larry Finger wrote:
> On 08/25/2017 09:15 PM, Larry Finger wrote:
>> Based on my prejudices, I would suspect the USB driver before that of 
>> the PCI version. I have BCc'd my contact at Realtek to see what he has 
>> to say on the issue.
> 
> My contact at Realtek replies that the PCI code is correct. He further 
> states that "Since mac80211 uses ieee80211_tx_next_seq() to store next 
> sequence number in sta->tid_seq[tid] and fill the sequence number in 
> AMPDU parameters, I think driver doesn't need to maintain the seq_number 
> anymore. So, let's remove 'u16 seq_number' from 'struct rtl_tid_data', 
> please refer to attachment." I have not had a chance to test his patch, 
> but I trust his analysis.

I don't see any attachment, but I'm happy with a correct solution if 
you'll work with them on getting that pushed in.

Cheers,
Jes
