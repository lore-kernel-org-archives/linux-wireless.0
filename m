Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36509 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcEFF1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 01:27:14 -0400
Received: by mail-wm0-f51.google.com with SMTP id n129so43959038wmn.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 22:27:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA93jw6+WvTttjgBsU08epcXwSCHxv3Eh=m32xi72AiKYnGOCQ@mail.gmail.com>
References: <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	<1462446039-1070-6-git-send-email-michal.kazior@tieto.com>
	<CAA93jw6+WvTttjgBsU08epcXwSCHxv3Eh=m32xi72AiKYnGOCQ@mail.gmail.com>
Date: Fri, 6 May 2016 07:27:12 +0200
Message-ID: <CA+BoTQnED8EiLFNWq=8CPVAtufi0R5WjzAf6Pkf6cxUON_xY4g@mail.gmail.com> (sfid-20160506_072719_052319_D0BB9080)
Subject: Re: [PATCHv4 5/5] mac80211: add debug knobs for codel
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 May 2016 at 17:21, Dave Taht <dave.taht@gmail.com> wrote:
> On Thu, May 5, 2016 at 4:00 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> This adds a few debugfs entries to make it easier
>> to test, debug and experiment.
>
> I might argue in favor of moving all these (inc the fq ones) into
> their own dir, maybe "aqm" or "sqm".
>
> The mixture of read only stats and configuration vars is a bit confusing.
>
> Also in my testing of the previous patch, actually seeing the stats
> get updated seemed to be highly async or inaccurate. For example, it
> was obvious from the captures themselves that codel_ce_mark-ing was
> happening, but the actual numbers out of wack with the mark seen or
> fq_backlog seen.  (I can go back to revisit this)

That's kind of expected since all of these bits are exposed as
separate debugfs entries/files. To avoid that it'd be necessary to
provide a single debugfs entry/file whose contents are generated on
open() while holding local->fq.lock. But then you could argue it
should contain all per-sta-tid info as well (backlog, flows, drops) as
well instead of having them in netdev*/stations/*/txqs.

Hmm..


Michał
