Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55338 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaAQWLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 17:11:08 -0500
Received: by mail-wg0-f45.google.com with SMTP id n12so5148154wgh.24
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 14:11:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJU+Ws4di0jLBM4pBc-mcQfjKgnZ28nsx-Bky5mB9QvcA@mail.gmail.com>
References: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com>
 <1389984919.10404.7.camel@jlt4.sipsolutions.net> <CABPxzYJU+Ws4di0jLBM4pBc-mcQfjKgnZ28nsx-Bky5mB9QvcA@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 18 Jan 2014 03:40:46 +0530
Message-ID: <CABPxzYK8fjDfE88mPt=H1c0mYOkS96+zHXueNSnxR2WvamJYbg@mail.gmail.com> (sfid-20140117_231111_837109_D2E1E0EA)
Subject: Re: [PATCH] cfg80211: Do not call CRDA when using internal regulatory database
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 18, 2014 at 12:33 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Sat, Jan 18, 2014 at 12:25 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Fri, 2014-01-17 at 03:32 +0530, Chaitanya T K wrote:
>>> When using internal regulatory data base kconfig option
>>> do not try to call crda, this complely defeats the
>>> purposes of enabling internal regulatory db.
>>
>> In general I don't think you can just break user visible behaviour this
>> way.
> Well, users are habituated the wrong way :-). Any new user seeing the
> internal_regdb might just forget about CRDA and face problems, in case
> the DB is different in both.
>
> How should we go about it, then?
When user enabled internal_regdb target, if he forgets to copy the db.txt
we throw a warn_on and continue with WORLD regdom. So user has to copy
the db.txt and we will read rules from there.This all happens independent of
CRDA running/not in userspace. So i dont see any visible user impact
if at all someone decides to enabled internal_regdb even after seeing
all the warnings in place (kconfig, doc ..) :-).

One more bug in the below check:

if (call_crda(lr->alpha2))
        return REG_REQ_IGNORE;

If call_crda fails (kobject_event return negative no) then also
we return REG_REQ_OK. It should be

if (call_crda(lr->alpha2) < 0)
        return REG_REQ_IGNORE;
