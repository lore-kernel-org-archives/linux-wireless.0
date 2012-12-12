Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:41209 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2LLBeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 20:34:18 -0500
Received: by mail-la0-f45.google.com with SMTP id p9so90312laa.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 17:34:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355176525.8083.19.camel@jlt4.sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
 <1354812468-15709-2-git-send-email-johannes@sipsolutions.net> <1355176525.8083.19.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 11 Dec 2012 17:08:54 -0800
Message-ID: <CAB=NE6XhW9rbeH8VwqSZYQmmRw7EYxq4rYV0Ch4gTTN54rq3sA@mail.gmail.com> (sfid-20121212_023421_850049_33235C25)
Subject: Re: [PATCH 01/24] regulatory: don't write past array when
 intersecting rules
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 1:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-12-06 at 17:47 +0100, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> When intersecting rules, we count first to know how many
>> rules need to be allocated, and then do the intersection
>> into the allocated array. However, the code doing this
>> writes past the end of the array because it attempts to
>> do all intersections. Make it stop when the right number
>> of rules has been reached.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> FWIW, since we currently allocate enough memory here to actually write
> past the end of the intended array, I've decided to remove the stable
> tag. It doesn't really fix anything -- with the next patch it fixes the
> allocation to not be too large, but that doesn't really need to go to
> stable.

That was likely the issue I ran into that caused things to burp
without the +1 ;)

  Luis
