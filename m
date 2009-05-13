Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:22585 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbZEMSHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 14:07:15 -0400
Received: by wa-out-1112.google.com with SMTP id j5so328419wah.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 11:07:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	 <1242208388.14227.46.camel@johannes.local>
	 <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
Date: Wed, 13 May 2009 14:00:45 -0400
Message-ID: <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
From: Bob Copeland <bcopeland@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 1:20 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, May 13, 2009 at 2:53 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
>>> We inform the drivers so they can take appropriate actions during
>>> suspend for WoW support.
>>
>>> -static void ar9170_op_stop(struct ieee80211_hw *hw)
>>> +static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspend)

Just curious, why can't the bus suspend method just turn the radio back on?
You have to set up the wow parameters later anyway.

I think it'd be cleaner if the stack knew about WoW somehow rather than
doing stuff behind its back in the driver.  Then suspend/resume could do
the right thing (e.g. ops->wow_enable() instead of stop) if the driver was
WoW-capable.

-- 
Bob Copeland %% www.bobcopeland.com
