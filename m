Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:43574 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753506Ab2E2O2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:28:49 -0400
Received: by yhjj56 with SMTP id j56so2405606yhj.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 07:28:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338275419.4342.19.camel@jlt3.sipsolutions.net>
References: <1337885569-32711-1-git-send-email-victorg@ti.com>
	<1337885569-32711-2-git-send-email-victorg@ti.com>
	<1338275419.4342.19.camel@jlt3.sipsolutions.net>
Date: Tue, 29 May 2012 17:28:48 +0300
Message-ID: <CAK80WHbtfhNdd5E7QNYno3L3gG00nTxWEPaQtGH7b5Ee2BhTFg@mail.gmail.com> (sfid-20120529_162853_815414_CA2D1929)
Subject: Re: [PATCH 2/2] mac80211: handle channel times in scan command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 29, 2012 at 10:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I'd prefer the default values to be defined in cfg80211, not mac80211,
> so that other drivers can also benefit once they add support for these
> settings.
>

you mean, to move (and rename) the:

#define IEEE80211_CHANNEL_TIME (HZ / 33)
#define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)

from scan.c to nl80211.h (or other?), and to set the default values in
nl80211_trigger_scan() ?

If so, then what about "IEEE80211_PROBE_DELAY", should we move it also ?

-- 
Thanks,
Victor.
