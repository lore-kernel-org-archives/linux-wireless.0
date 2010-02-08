Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42281 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0BHNNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 08:13:47 -0500
Received: by mail-vw0-f46.google.com with SMTP id 20so2117477vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 05:13:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002081342.20062.chunkeey@googlemail.com>
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
	 <201002081342.20062.chunkeey@googlemail.com>
Date: Mon, 8 Feb 2010 18:43:38 +0530
Message-ID: <8e92b4101002080513n788ef64erb33baef2393b0d54@mail.gmail.com>
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2010 at 6:12 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday 08 February 2010 13:17:00 Vivek Natarajan wrote:
>> Even if the null data frame is not acked by the AP, mac80211
>> goes into power save. This might lead to loss of frames
>> from the AP.
>> Prevent this by restarting dynamic_ps_timer when ack is not
>> received for null data frames.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> ---
>>  include/net/mac80211.h     |    1 +
>>  net/mac80211/ieee80211_i.h |    1 +
>>  net/mac80211/mlme.c        |   20 +++++++++++++++-----
>>  net/mac80211/status.c      |   16 ++++++++++++++--
>>  4 files changed, 31 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 74ccf30..92a3caf 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -978,6 +978,7 @@ enum ieee80211_hw_flags {
>>       IEEE80211_HW_SUPPORTS_STATIC_SMPS               = 1<<15,
>>       IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS              = 1<<16,
>>       IEEE80211_HW_SUPPORTS_UAPSD                     = 1<<17,
>> +     IEEE80211_HW_TX_STATUS                          = 1<<18,
>>  };
>
> It might be a good idea to add some documentation for new flags.
>
> Otherwise this can easily lead to confusing (e.g.: Does
> HW_TX_STATUS mean that the HW reports not just ACKs, but also
> when if the frame was filtered by the HW, or if the HW reports
> the rate control information (retries & retry index) as well?)
>
> On a related issue: What about _inverting_ the flag, so it will
> be set for devices which can't give any accurate tx_status
> information. This has the advantage that we don't have to touch
> other drivers?

Shall I rename it as HW_NO_TX_ACK_REPORT?
Looking at the other flags, they show some positively present
feature in the hw. In those lines, HW_REPORTS_TX_ACK_STATUS
might be better.

Thanks
Vivek.
