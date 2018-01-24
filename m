Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933172AbeAXL1q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 06:27:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 24 Jan 2018 16:57:45 +0530
From: vnaralas@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: Add tx ack signal attribute in sta info
In-Reply-To: <1516623728.2508.4.camel@sipsolutions.net>
References: <1516279208-16485-1-git-send-email-vnaralas@codeaurora.org>
 <1516623728.2508.4.camel@sipsolutions.net>
Message-ID: <65e392b36ecf5b3161be954e974c4c0a@codeaurora.org> (sfid-20180124_122751_143883_59CA43A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-01-22 17:52, Johannes Berg wrote:
> On Thu, 2018-01-18 at 18:10 +0530, Venkateswara Naralasetty wrote:
>> From: Bhagavathi Perumal S <bperumal@codeaurora.org>
>> 
>> This patch provides support for users to get ack signal
>> strength of last transmitted by introducing new attribute
>> 'NL80211_STA_INFO_ACK_SIGNAL'.
> 
> No real objection to the patch itself, but you should say *why* you
> need this, and I'm not really sure I see much point in having the
> signal strength of the very last ACK frame?
If user wants to get instant RSSI for the station which is ideal for 
long time, user can sent null frame and get RSSI form the ack of that 
null frame.

> 
> At least provide reasoning so other drivers can decide whether to
> implement it or not.
> 
>> + * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK 
>> frame(u8, dBm)
> 
> more like s8, really.

I have taken reference from 'NL80211_STA_INFO_SIGNAL_AVG'.
