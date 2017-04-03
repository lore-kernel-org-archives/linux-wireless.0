Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44912 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbdDCFTq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 01:19:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@linuxdriverproject.org, Tycho Andersen <tycho@tycho.ws>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
        <20170331075851.GB1435@katana> <20170331102113.GA2930@eros>
Date: Mon, 03 Apr 2017 08:19:40 +0300
In-Reply-To: <20170331102113.GA2930@eros> (Tobin C. Harding's message of "Fri,
        31 Mar 2017 21:21:13 +1100")
Message-ID: <87fuhq6par.fsf@purkki.adurom.net> (sfid-20170403_072010_428171_4AAEED91)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

"Tobin C. Harding" <me@tobin.cc> writes:

> On Fri, Mar 31, 2017 at 09:58:51AM +0200, Wolfram Sang wrote:
>> 
>> > The code is untested, I have hardware in the mail.
>> 
>> Cool!
>
> The card I have is a Spectec FCC ID: S2Y-WLAN-11B-G which I believe is
> a SDW-823 and should use the ks7010 driver. I am going to attempt to
> get it running on a Raspberry Pi B+. I ordered the wrong size break
> out board originally so waiting on the new one now.
>
>> 
>> > If any one is interested and has any comments I would really like to
>> > hear them. I am open to all suggestions (even down to trivial coding
>> > style issues).
>> 
>> I'll just repeat that the key move to get this driver out of staging is
>> to get away from the WEXT interface to CFG80211. Otherwise no chance
>> that wireless maintainers will even look at it. This is a huge change
>> but once it is done, features like Michael MIC come with it for free
>> (from what I recall, I am not a wireless expert myself).
>
> That would explain why I could not find more than the Orinoco driver
> using the Michael MIC module directly.

I think cfg80211 and mac80211 got mixed up. mac80211 (the full IEEE
802.11 stack for "softmac" devices) provides Michael MIC implementation,
but cfg80211 (for "hardmac" devices) does not.

>> Without the CFG80211 conversion, replacing the Michael custom
>> implementation with the in-kernel one makes the driver a tad better and
>> is good exercise. However, it will sadly not help to get the driver out
>> of staging.
>
> I'll drop it then. Could you please tell me, is there any thing else
> more I need to do to let LKML know that this RFC is dropped? Or is
> this reply enough. I don't want to use any ones time unnecessarily.
>
>> 
>> But if you want a clean WEXT driver first, this is a step in the right
>> direction.
>
> Let's go for a CFG80211 driver and get out of staging :) So next step
> is I guess study the ath6kl driver, learn how CFG80211 is done and
> implement that interface in ks7010? Oh, and test that it works.

Please keep linux-wireless list in loop so that people on that list can
help.

-- 
Kalle Valo
