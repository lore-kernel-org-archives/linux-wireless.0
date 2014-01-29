Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:59340 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaA2Jol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 04:44:41 -0500
Received: by mail-la0-f41.google.com with SMTP id mc6so1305969lab.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 01:44:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390983472.4143.0.camel@jlt4.sipsolutions.net>
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
 <20140125003418.GF28512@garbanzo.do-not-panic.com> <CALhHN=p11A-kA3S=ESz85OUSfHr5t+Qqka24wwbvfJuA-bksXQ@mail.gmail.com>
 <CAB=NE6VfmOMVT3zxE1iEOtT53SycgrrpiKuoi2NPuDXvccz96Q@mail.gmail.com> <1390983472.4143.0.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 29 Jan 2014 01:44:18 -0800
Message-ID: <CAB=NE6VDcP1Jq0rm+XVVS6PuGYD5Dmb-EXeY5hOJ9FCfZFvh8Q@mail.gmail.com> (sfid-20140129_104500_196058_63B5730E)
Subject: Re: [PATCH v2 1/3] cfg80211: add helper reg_get_regdomain() function
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 29, 2014 at 12:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-01-28 at 11:42 -0800, Luis R. Rodriguez wrote:
>
>> > You mean we should introduce:
>> > iw wlanX reg get?
>>
>> Sure, and iw dev reg get can also display what it does now but then
>> also iterate over all wiphys and also display all wiphy's own regd if
>> they have any.
>
> I'm not really sure I see much point in all this - what userspace
> eventually cares about isn't the reg data but the channel list that can
> be obtained with (the equivalent of) iw list.

That's true if you don't consider important the data that applied the
rules. This can be useful and if not exposed by userspace API I can at
least see this useful for debugfs. As for userspace API -- the data
reflects *calibrated* phy data, I see no reason why it shouldn't be
exposed just as other attributes of the phy, but I can see this
growing to other subjective areas, but I think we have things down
with a general usable generic regulatory domain data structure.

I can't say I care though :D just my $0.02 from a parking distance.

  Luis
