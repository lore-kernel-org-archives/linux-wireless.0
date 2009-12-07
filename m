Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46281 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933871AbZLGLvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 06:51:10 -0500
Received: by bwz27 with SMTP id 27so3396985bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 03:51:15 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jason Young <a.young.jason@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mac80211: add U-APSD client support
References: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
	<1260096442.3461.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 07 Dec 2009 13:51:13 +0200
In-Reply-To: <1260096442.3461.3.camel@johannes.local> (Johannes Berg's message of "Sun\, 06 Dec 2009 11\:47\:22 +0100")
Message-ID: <87my1v3sum.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-12-03 at 12:25 -0800, Jason Young wrote:
>
>> The bit values for IEEE80211_WMM_IE_STA_SP_XXX are not correct.  The Max SP
>> Length subfield settings table in 7.3.1.17 has the least significant bit listed
>> first.
>> 
>> #define IEEE80211_WMM_IE_STA_SP_ALL  (0<<5)
>> #define IEEE80211_WMM_IE_STA_SP_2     (1<<5)  /* or (BIT(5)) */
>> #define IEEE80211_WMM_IE_STA_SP_4     (2<<5)  /* or (BIT(6)) */
>> #define IEEE80211_WMM_IE_STA_SP_6     (3<<5)  /* or (BIT(5) | BIT(6)) */
>
> Can somebody clarify for me which part of this stuff is WMM, and which
> is "real" 802.11 QoS?

I took a quick peek of the 802.11-2007 QoS part. My observation was
that the terms are the same, but that's about it. For example QoS Info
field is reversed, APSD capability is advertised through beacon
capability bits and naturally there are proper ids for IEs.

So they are very similar but the frame handling has to be more or less
rewritten for 802.11 QoS.

BTW, are there clients which support 802.11 QoS? Should we consider
adding it to mac80211, for example? Thoughts?

-- 
Kalle Valo
