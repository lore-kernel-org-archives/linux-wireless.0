Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59874 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143Ab0JHVXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 17:23:22 -0400
Received: by iwn6 with SMTP id 6so809144iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 14:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010082249.20545.chunkeey@googlemail.com>
References: <201010082235.09355.chunkeey@googlemail.com> <AANLkTi=LxUqST506VGiM8RpEZXrJ6_EWVRiJHboGVv5i@mail.gmail.com>
 <201010082249.20545.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 8 Oct 2010 14:22:57 -0700
Message-ID: <AANLkTi=Pe7tt+As0_Kzjt0PB=cHO_eSO+Qs8dy2o+Mbd@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: temporarily disable reorder release timer
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 8, 2010 at 1:49 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Friday 08 October 2010 22:40:39 Luis R. Rodriguez wrote:
>> On Fri, Oct 8, 2010 at 1:35 PM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > Several serve threading problems in the current
>> > release reorder timer implementation have been
>> > discovered.
>> >
>> > A lengthy discussion - which lists some of the
>> > pitfalls and possible solutions - can be found at:
>> >  http://marc.info/?t=128635927000001
>> >
>> > But due to the complicated nature of the subject and
>> > the imminent advent of a new -rc cycle, it was
>> > decided to disable the feature for the time being.
>> >
>> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
>>
>> This patch lacks documentation of the impact of this patch, while it
>> may fix a lock issue, the does not address what happens when the patch
>> is actually applied.
> ? It just disables the timer. The actual reorder code
> is left untouched, everything is the same as in Linus'
> 2.6.36-rcX tree.
>
> Or what impact are you talking about?

The timer is what I'm talking about, we don't run then
ieee80211_release_reorder_timeout() right so we don't clear stale
frames on aggregates. What impact does this have?

  Luis
