Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42657 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab0AEK1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 05:27:41 -0500
Received: by bwz27 with SMTP id 27so9802186bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 02:27:40 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, a.young.jason@gmail.com
Subject: Re: [RFC PATCH v5 2/7] mac80211: add debugfs interface for U-APSD queue configuration
References: <20091231133626.29899.95683.stgit@tikku>
	<20091231133720.29899.75214.stgit@tikku>
	<1262684902.21956.1.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 05 Jan 2010 12:27:37 +0200
In-Reply-To: <1262684902.21956.1.camel@johannes.local> (Johannes Berg's message of "Tue\, 05 Jan 2010 10\:48\:22 +0100")
Message-ID: <87vdfgvobq.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> +	ret = strict_strtoul(buf, 0, &val);
>> +
>> +	if (ret)
>> +		return -EINVAL;
>> +
>> +	if (val != 0 && (val & IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK) == 0)
>> +		return -ERANGE;
>> +
>> +	local->uapsd_max_sp_len = val;
>
> This seems a bit weird, that means you need to use 0x20, ..., 0x60,
> right?

Yes.

> I think you should shift it up/down when reading/writing, or
> probably even store it shifted in local->uapsd_max_sp_len and then
> shift it up by 5 when using that value -- the value itself is only
> 0..3 after all, and only stored in a bitmasked field.

I was actually thinking this option but ended up requiring the user to
do the shift. But thinking is again it doesn't make any sense, I'll do
it as you recommend.

I'll store the values shifted in local->uapsd_max_sp_len and do the
conversion in debugfs.c.

-- 
Kalle Valo
