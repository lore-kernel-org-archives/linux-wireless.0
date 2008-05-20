Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:35293 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbYETNeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:34:00 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1043632wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 06:33:59 -0700 (PDT)
Message-ID: <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com> (sfid-20080520_153413_214747_3158B189)
Date: Tue, 20 May 2008 16:33:58 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1211289769.6252.90.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1211288251.6252.86.camel@johannes.berg>
	 <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com>
	 <1211289769.6252.90.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 4:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> >> I suggest to insert at least some WARN_ON(1) for the else case.
>> >
>> > Disagree, not until somebody audits the code. We already know it can
>> > happen and a WARN() won't help us track it down because it provides no
>> > additional information (stack trace is useless)
>>
>> What about printk(KERN_WARN ), The else statement actually means that
>> something wrong happened.
>
> Thing is, I'm not totally convinced it is wrong to the code while it may
> or may not be wrong...

Doesn't should be bss pinned int he bss list if you are associating to
it. If it's not there you don't have access to it's info It looks very
wrong to me.

I think this patch should go in first as it
> actually fixes the oops, and then we can discuss the merits of adding a
> warning there separately. Maybe after we look a bit at the code and try
> to figure out whether it can still happen after that patch from
> Abhijeet.

I'm not sure if this patch is complete without this warning. What is
in the else statement is a hack and it should be obvious.

Tomas
