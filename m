Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37911 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZLUOFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 09:05:10 -0500
Received: by bwz27 with SMTP id 27so3461706bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 06:05:09 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] wl1271: add testmode support
References: <20091221120745.18850.67739.stgit@tikku>
	<20091221123632.18850.74951.stgit@tikku>
	<1261400310.3733.13.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 21 Dec 2009 16:05:06 +0200
In-Reply-To: <1261400310.3733.13.camel@johannes.local> (Johannes Berg's message of "Mon\, 21 Dec 2009 13\:58\:30 +0100")
Message-ID: <874onkzalp.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2009-12-21 at 14:36 +0200, Kalle Valo wrote:
>
>> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>> +	if (!cmd)
>> +		return -ENOMEM;
>> +
>> +	/* copy the buffer to make it work with dma */
>> +	memcpy(cmd, buf, buf_len);
>
> kmemdup() (more than once in the patch)

Oh, of course I should have used that :) I'll change this.

>> +#ifndef __WL1271_TESTMODE_H__
>> +#define __WL1271_TESTMODE_H__
>> +
>> +#include <net/mac80211.h>
>> +
>> +int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len);
>> +
>> +#endif /* __WL1271_TESTMODE_H__ */
>
> probably wouldn't bother with a file for one line ;)

Yeah, you have a point. I added just for consistency.

Thanks for the review.

-- 
Kalle Valo
