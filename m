Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36725 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1A3G6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 01:58:10 -0500
Received: by yxt3 with SMTP id 3so1588998yxt.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Jan 2011 22:58:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296124403.3622.2.camel@jlt3.sipsolutions.net>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-6-git-send-email-arik@wizery.com> <1296121901.5263.116.camel@pimenta>
 <1296124403.3622.2.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 30 Jan 2011 08:57:54 +0200
Message-ID: <AANLkTik1r-6k3NhNnAOgX7WuvfhREgbYHUvnL_sR7nvy@mail.gmail.com>
Subject: Re: [PATCH 05/10] wl12xx: report invalid TX rate when returning
 non-TX-ed skbs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 12:33, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-01-27 at 11:51 +0200, Luciano Coelho wrote:
>> On Sun, 2011-01-16 at 06:42 +0100, Arik Nemtsov wrote:
>> > Report a TX rate idx of -1 when returning untransmitted skbs to mac80211
>> > using ieee80211_tx_status(). Otherwise mac80211 tries to use the
>> > returned (essentially garbage) status.
>> >
>> > Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> > ---
>>
>> Is this a documented way of doing it or it just happens to work?
>
> I think the more expected way would be to set the TX counts to 0?

Good catch. I'll set the rates[0].count = 0.

The original patch was to avoid this problematic line in ieee80211_tx_status:

		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
		    (rates_idx != -1))
			sta->last_tx_rate = info->status.rates[rates_idx];

If rates[0].idx is invalid this will be a bad deref.

Arik
