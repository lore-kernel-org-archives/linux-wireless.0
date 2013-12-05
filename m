Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36002 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3LEPjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:39:17 -0500
Received: by mail-ie0-f179.google.com with SMTP id x13so30256608ief.10
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 07:39:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386254607.4182.5.camel@jlt4.sipsolutions.net>
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
	<1386235289-27278-4-git-send-email-eliad@wizery.com>
	<1386253879.4182.4.camel@jlt4.sipsolutions.net>
	<CAB3XZEcpM9PAQCGQ99X2A-bqYXoPEmE=Cg29CDKY7=s8QquwUA@mail.gmail.com>
	<1386254607.4182.5.camel@jlt4.sipsolutions.net>
Date: Thu, 5 Dec 2013 17:39:16 +0200
Message-ID: <CAB3XZEc4pikahyAmPCh_pCjFEiRvFgAyZgxGrbH9A6hLP2nhFw@mail.gmail.com> (sfid-20131205_163920_768871_C7A5FD80)
Subject: Re: [PATCH 4/4] cfg80211: prevent race condition on scan request cleanup
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 5, 2013 at 4:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-05 at 16:36 +0200, Eliad Peller wrote:
>> On Thu, Dec 5, 2013 at 4:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Thu, 2013-12-05 at 11:21 +0200, Eliad Peller wrote:
>> >
>> >> @@ -219,8 +221,13 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
>> >>        * the scan request or not ... if it accesses the dev
>> >>        * in there (it shouldn't anyway) then it may crash.
>> >>        */
>> >> -     if (!leak)
>> >> -             kfree(request);
>> >> +     if (leak) {
>> >> +             request->pending_cleanup = true;
>> >> +             return;
>> >
>> > This seems insufficient, if the driver never indicates completion, we'd
>> > never clear rdev->scan_req?
>> >
>> right, but i think it somehow makes sense (i.e. the driver must
>> indicate completion...)?
>
> But the whole thing was intended to catch buggy drivers :)
>
yeah, you have a point here :)
anyway, i guess it's either leaking scan_req and hoping the driver
really forgot about it, or keeping it and hoping the driver will
finally indicate completion.

since i don't think this is a real-world scenario, i'm ok with
dropping this patch.

> Btw, should any of this go to 3.13?
maybe the first one. it's the only "real" issue.

Eliad.
