Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57457 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbaAMROc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:14:32 -0500
Received: by mail-lb0-f179.google.com with SMTP id p9so125564lbv.10
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 09:14:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389620141.5008.8.camel@jlt4.sipsolutions.net>
References: <1389385273-1322-1-git-send-email-a.gal@motsai.com>
	<1389620141.5008.8.camel@jlt4.sipsolutions.net>
Date: Mon, 13 Jan 2014 12:14:30 -0500
Message-ID: <CAN44aq1hrya4B4X4xTi4Aphb9QDBiQ9813kT6vhxtDCzBRoNhQ@mail.gmail.com> (sfid-20140113_181439_380333_1179DD7D)
Subject: Re: [PATCH v5] wl12xx: fix tx power setting
From: Alex Gal <a.gal@motsai.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Mon, Jan 13, 2014 at 8:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2014-01-10 at 15:21 -0500, Alex Gal wrote:
>> The driver ignores BSS_CHANGED_TXPOWER changes.
>> Fix this by calling ACX_TX_POWER when appropriate.
>
> This doesn't really make sense since the driver handles
> IEEE80211_CONF_CHANGE_POWER. If there's something wrong with that, maybe
> that should be fixed?
>
> You should be able to see this with the debugging stuff.

I tried debugging a bit more.

The IEEE80211_CONF_CHANGE_POWER never reaches the driver since in
/net/mac80211/main.c:ieee80211_hw_config:

    if (!local->use_chanctx)
        changed |= ieee80211_hw_conf_chan(local);
    else
        changed &= ~(IEEE80211_CONF_CHANGE_CHANNEL |
                 IEEE80211_CONF_CHANGE_POWER);

only the else statement is executed.

However, the BSS_CHANGED_TXPOWER gets sent to the driver so I thought,
incorrectly,
that would be the the fix.

This behavior happens in kernel 3.10 but I suspect the same to happen
in mainline, unfortunately, I cannot test it.

Please let me know how I can debug this further since I am not
familiar with this code.

Cheers,

Alex
