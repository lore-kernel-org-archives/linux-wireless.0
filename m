Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34676 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1JHTTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 15:19:30 -0400
Received: by eye27 with SMTP id 27so462110eye.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2011 12:19:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318022253.3549.108.camel@cumari>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
 <1318004434.3988.16.camel@jlt3.sipsolutions.net> <CANCvt+6JkxnE6Z7soUuhQSbzpxuxYUNC7z0vv+jn-sH+jpY4Qg@mail.gmail.com>
 <1318022253.3549.108.camel@cumari>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Sat, 8 Oct 2011 21:19:14 +0200
Message-ID: <CA+XVXfd+vN7b=oYrysPCuynAgy5=4SgRHuznJRW0h+6ez7YqsQ@mail.gmail.com> (sfid-20111008_211940_443905_6D39D807)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
To: Luciano Coelho <coelho@ti.com>
Cc: Shahar Lev <shahar@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2011 at 23:17, Luciano Coelho <coelho@ti.com> wrote:
> On Fri, 2011-10-07 at 23:03 +0200, Shahar Lev wrote:
>> On Fri, Oct 7, 2011 at 6:20 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > Maybe you should also change that? :-)
>>
>> Consider it added to our collective TODO.
>
> Well, the fix is probably supposed to be done in mac80211, instead of
> hiding the bug by removing the warning, isn't it?

Sometimes data is sent when the IBSS interface is not connected.
wl12xx handles this correctly by throwing the packets. In this sense
there's no "bug".
All this patch does is remove warning messages that confuse the users
(and developers).

I agree fixing mac80211 is the better thing to do, and we'll get to it
when time permits.

Arik
