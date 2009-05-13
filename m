Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51314 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZEMVJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:09:38 -0400
Received: by gxk10 with SMTP id 10so1692523gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 14:09:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090513181329.GA19693@tesla>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	 <1242208388.14227.46.camel@johannes.local>
	 <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	 <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
	 <20090513181329.GA19693@tesla>
Date: Wed, 13 May 2009 17:09:32 -0400
Message-ID: <b6c5339f0905131409y18ea0c6fp438db6fe34d3c0c4@mail.gmail.com>
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending on
	the stop callback
From: Bob Copeland <bcopeland@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 2:13 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Agreed, however ath9k is the only card I know how WoW works so far.

Understood.

> Thoughts?

None really, it just seemed adding flags to stop() is a less-than-ideal
interface.  Hmm, maybe there is inspiration to be had from plain old
ethernet drivers...

<looks quickly>

The one example I looked at, amd8111e, used set_wol/get_wol callbacks
from ethtool to set the option, then did something special in its bus
suspend method for the magic. *shrug*

-- 
Bob Copeland %% www.bobcopeland.com
