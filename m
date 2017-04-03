Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48802 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdDCJzr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 05:55:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
        <20170331075851.GB1435@katana> <20170331102113.GA2930@eros>
        <87fuhq6par.fsf@purkki.adurom.net> <20170403090359.GK3755@eros>
Date: Mon, 03 Apr 2017 12:55:41 +0300
In-Reply-To: <20170403090359.GK3755@eros> (Tobin C. Harding's message of "Mon,
        3 Apr 2017 19:03:59 +1000")
Message-ID: <87o9wdolwi.fsf@kamboji.qca.qualcomm.com> (sfid-20170403_115619_364412_CE427CC2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Tobin C. Harding" <me@tobin.cc> writes:

>> >> But if you want a clean WEXT driver first, this is a step in the right
>> >> direction.
>> >
>> > Let's go for a CFG80211 driver and get out of staging :) So next step
>> > is I guess study the ath6kl driver, learn how CFG80211 is done and
>> > implement that interface in ks7010? Oh, and test that it works.
>> 
>> Please keep linux-wireless list in loop so that people on that list can
>> help.
>
> How newbie friendly is the linux-wireless list please?

I would claim quite friendly, but I'm finnish and our definition of
"friendly" seems to be very different from rest of the world ;)

> I am having trouble separating the data path code from the control
> path. I think I will spend a few more days on it though before asking
> any questions.

People do send questions to the list and most of the time they get
answered. So go for it.

There's also an irc channel which usually is helpful:

https://wireless.wiki.kernel.org/en/users/support#linux_wireless_user_irc_channel

> Except one: do you know off the top of your head of a canonical
> implementation of a softmac wi-fi driver.

You mean a mac80211 driver? mac80211_hwsim is the simplest one, but
that's not a real driver as it's a simulator. Just grep
ieee80211_register() to find all the drivers. Smaller drivers like
rtl8xxxu or wl1251 might be good starting points to get familiar with
the stack.

And I guess you already saw the documentation:

https://wireless.wiki.kernel.org/en/developers/documentation/mac80211

-- 
Kalle Valo
