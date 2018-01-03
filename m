Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35626 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbeACVAd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 16:00:33 -0500
Received: by mail-pf0-f178.google.com with SMTP id j124so1233045pfc.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jan 2018 13:00:33 -0800 (PST)
Subject: Re: [RFC 4/4] nl80211: Implement TX of control port frames
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20171228175832.3253-1-denkenz@gmail.com>
 <20171228175832.3253-5-denkenz@gmail.com>
 <1514899804.2024.5.camel@sipsolutions.net>
 <c73dcadb-bd96-fa82-b857-b5e2432fbadb@gmail.com>
 <1514924529.10342.4.camel@sipsolutions.net>
 <00fc2806-3e2c-811e-0f00-6774dc37d843@gmail.com>
 <CAF7Mx6oKi3gAiyjTOCcZX3Y--=xFV9NuiCdSbVTL7R0A=NYKcQ@mail.gmail.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <0fab83c6-a16a-5c2e-51ea-3d6da2d381fd@gmail.com> (sfid-20180103_220040_402032_273CFA9B)
Date: Wed, 3 Jan 2018 15:00:30 -0600
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6oKi3gAiyjTOCcZX3Y--=xFV9NuiCdSbVTL7R0A=NYKcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>> So essentially we'd need a new operation in cfg80211_ops that would accept
>> the control port frame data and some control flags.  Do we want to pass in
>> an skb with all the 802.11 headers set or a 802.3 formatted skb (since that
>> is what other data frames look like initially on the netdev).
> 
> Our firmware expects EAPOL stuff to come in as 802.3 packet, which
> probably applies to the other full-mac devices as well. Is there any
> reason for passing 802.11 packets.
> 

I think it was suggested earlier somewhere in this thread to use 802.11 
header similar to how mgmt_tx does things.  To me it makes more sense to 
use 802.3 headers so I thought I would double check.

Regards,
-Denis
