Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50498 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934227AbeAXQXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 11:23:35 -0500
Subject: Re: [PATCH 8/8] mt76: validate rx CCMP PN
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
References: <20180124151917.70962-1-nbd@nbd.name>
 <20180124151917.70962-8-nbd@nbd.name>
 <1516809416.2508.44.camel@sipsolutions.net>
 <7a022b57-af4a-78ee-aa8f-d0cd9eb17685@nbd.name>
 <1516810820.2508.45.camel@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <766bee62-693b-4964-b259-62546e57ac2a@nbd.name> (sfid-20180124_172340_334273_2936D9BB)
Date: Wed, 24 Jan 2018 17:23:34 +0100
MIME-Version: 1.0
In-Reply-To: <1516810820.2508.45.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-24 17:20, Johannes Berg wrote:
> On Wed, 2018-01-24 at 17:11 +0100, Felix Fietkau wrote:
>> 
>> I guess I will have to look into fragmentation. I have a second driver
>> pending that only reports the CCMP PN outside of the packet, and for
>> performance reasons I really don't want to translate it and move it to a
>> place where mac80211 can parse it.
>> I'm also looking into doing parallel rx in software to see if I can get
>> more performance that way. I think for that I would also need CCMP PN
>> validation in the driver.
> 
> Fair enough. We also do it, except we just decide that fragmented
> packets we don't care and can use mac80211 - but we get the PN in-
> frame, just can't always use mac80211 due to parallel RX.
I guess I could make the driver translate the header for fragmented
packets only.

- Felix
