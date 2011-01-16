Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46392 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1API4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 03:56:43 -0500
Received: by ywl5 with SMTP id 5so1359383ywl.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 00:56:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295166522.3574.1.camel@jlt3.sipsolutions.net>
References: <1295164184-25592-1-git-send-email-eliad@wizery.com>
	<1295166522.3574.1.camel@jlt3.sipsolutions.net>
Date: Sun, 16 Jan 2011 10:48:54 +0200
Message-ID: <AANLkTi=pizkixzqiiHwcN6KjcB-+oiKbsmo3TOw_bCB6@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: fix some sparse warnings
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 16, 2011 at 10:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-01-16 at 09:49 +0200, Eliad Peller wrote:
>
>> @@ -813,7 +813,7 @@ int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
>>       acx->rate_policy.long_retry_limit = c->long_retry_limit;
>>       acx->rate_policy.aflags = c->aflags;
>>
>> -     acx->rate_policy_idx = idx;
>> +     acx->rate_policy_idx = __cpu_to_le32(idx);
>
> The underscore version doesn't look appropriate at this point or in fact
> anywhere in this patch.
>
> Also, your patch subject and commit log is wrong -- this doesn't just
> fix sparse warnings, it fixes actual bugs pointed out by sparse, so
> commit log should reflect that.
>
thanks for your review!
i'll send a new version.

what is the difference between the normal and underscore version?
atomicity? (i didn't find a documentation about it)
