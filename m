Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:64493 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3AIRZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:25:19 -0500
Received: by mail-qc0-f178.google.com with SMTP id j34so1696617qco.23
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 09:25:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357749133.9757.16.camel@jlt4.sipsolutions.net>
References: <1357654597-8493-1-git-send-email-victorg@ti.com>
 <1357735100.9757.9.camel@jlt4.sipsolutions.net> <50ED94F7.9000709@ti.com> <1357749133.9757.16.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 9 Jan 2013 19:25:03 +0200
Message-ID: <CA+XVXfc+zyLybv9bush3B-Ax65HNTeKOt-FAzT281gQytr3ABA@mail.gmail.com> (sfid-20130109_182523_650455_53ABC04C)
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
To: Victor Goldenshtein <victorg@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 9, 2013 at 6:32 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2013-01-09 at 18:04 +0200, Victor Goldenshtein wrote:
>> On 09/01/13 14:38, Johannes Berg wrote:
>> > Do we really want to allow arbitrary changes to the interfaces while
>> > scanning? This could process a deauth frame for example, I'm worried
>> > that might break things.
>> >
>>
>> Can you please elaborate why we shouldn't process deauth frames during
>> HW scan ? This fix was tested with our 18xx, don't see how it can break
>> things, but it's up to you whether to take it..
>
> But did you test disassociating in the middle of the scan? I suspect
> that some devices at least might have trouble with reprogramming the
> device completely while it's scanning.
>
> Maybe you can make this behaviour opt-in with a hardware flag?
>

This is just a speed optimization for BA session management, so I'm
pretty sure the above was not tested.

Maybe we can make the "if" stricter and only allow it to pass if it's
hw_scanning and mgmt->u.action.category == WLAN_CATEGORY_BACK ? Would
that make sense?
