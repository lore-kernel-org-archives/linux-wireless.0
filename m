Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbcLHLnt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 06:43:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 10/14] rtlwifi: Add BTC_TRACE_STRING to new btcoex
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
        <20161202014833.6856-11-Larry.Finger@lwfinger.net>
        <20161205213447.GJ8176@mwanda>
        <6442d5c7-f083-0e98-490b-dd18a5a4d316@lwfinger.net>
        <20161206071340.GB10292@kroah.com>
        <871sxkdjeh.fsf@kamboji.qca.qualcomm.com>
        <20161207133219.GM8176@mwanda>
Date: Thu, 08 Dec 2016 13:43:42 +0200
In-Reply-To: <20161207133219.GM8176@mwanda> (Dan Carpenter's message of "Wed,
        7 Dec 2016 16:32:19 +0300")
Message-ID: <87y3zqbq8h.fsf@kamboji.qca.qualcomm.com> (sfid-20161208_124352_742570_9CB9559A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Wed, Dec 07, 2016 at 02:16:06PM +0200, Kalle Valo wrote:
>> We have disccused this before, but for wireless it's not really that
>> simple. AFAIK with dyndbg you can only control the messages per line
>> (painful to enable group of messages) or per file (enables too many
>> messages). In wireless we have cases when we need to enable group of
>> messages, but not all.
>
> You can turn them on by the function or a range of lines, then disable
> the spammy lines.  With these new debug macros you can't do that so this
> is a step backwards.

>From my point of view dyndbg is step backwards. Line numbers change all
the time and you can't have simple instructions like this for users and
developers working with the driver:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/debug#debug_log_messages

I don't want waste time with this anymore as we seem to just disagree.
My point here was that in wireless we have used log wrappers before and
will continue to use them in certain drivers as dyndbg is not enough.
But it would make me very happy if someone would add a similar grouping
functionality to dyndbg to make it easy to enable a set of debug
messages in a driver.

-- 
Kalle Valo
