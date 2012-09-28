Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55689 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2I1UiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:10 -0400
Received: by ieak13 with SMTP id k13so8347182iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2012 13:38:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348830401.13298.27.camel@jlt4.sipsolutions.net>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	<1348772354-15936-5-git-send-email-bzhao@marvell.com>
	<1348830401.13298.27.camel@jlt4.sipsolutions.net>
Date: Fri, 28 Sep 2012 13:38:09 -0700
Message-ID: <CA+yqC4aGJ4wpBNvyZRuPvSMdmQf8o2CHW=S=Uxry3CCT_RxwFw@mail.gmail.com> (sfid-20120928_223819_162349_D32BE2BE)
Subject: Re: [PATCH v2 4/5] mac80211: add support for tx to abort low priority
 scan requests
From: Sam Leffler <sleffler@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 28, 2012 at 4:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:
>
>> +     if (associated && !tx_empty) {
>> +             if (unlikely(local->scan_req->flags &
>> +                          CFG80211_SCAN_FLAG_LOW_PRIORITY))
>
> I don't really see value in the "unlikely()" here, that just clutters
> the code and probably has very little effect on the runtime behaviour,
> this is very infrequently executed.
>
>
>> +             case SCAN_ABORT:
>> +                     aborted = true;
>> +                     goto out_complete;
>
> Maybe we should have different flags though ... I mean, this is the
> first implementation that I hear of that interprets a background scan as
> "ok to abort at any time"? It seems very unlikely that other
> implementations would do that. I *think* (like I said before, I don't
> really know) that ours (Intel's) will just shorten the dwell time, or
> similar instead.

Well previous implementations I've done have used this technique for
many years and you can find them in various products (assuming they
haven't been totally rewritten) :-)

-Sam
