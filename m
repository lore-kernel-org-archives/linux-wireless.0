Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34914 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcDHBdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 21:33:17 -0400
Received: by mail-oi0-f45.google.com with SMTP id p188so120398465oih.2
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 18:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459928436.17504.11.camel@sipsolutions.net>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
 <1456222441.2041.10.camel@sipsolutions.net> <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
 <1456257946.9910.23.camel@sipsolutions.net> <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com>
 <1459928436.17504.11.camel@sipsolutions.net>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Thu, 7 Apr 2016 21:32:57 -0400
Message-ID: <CAHqTa-3VtwYWLUHQuFyqtmMwPE2XQYJD4-U+-1PqXKtmTFrEgA@mail.gmail.com> (sfid-20160408_033326_282005_316BADD9)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 6, 2016 at 3:40 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-04-05 at 19:46 -0400, Avery Pennarun wrote:
>
>> This test was with backports-20150525 on ath9k.  (We have newer
>> versions in the queue, but they haven't rolled out to our customers
>> yet.  Anyway, earlier in this thread, I was able to trigger the race
>> condition on much newer backports.  Unfortunately the current fix
>> makes my reproducible test case go away, but I don't know any reason
>> to assume the race condition is fixed.)
>
> Well, we know that the timeout is likely unrelated to the issue (other
> than not triggering the broken code path that frequently), so you can
> revert the timeout change for the test case.

Yes.  And I can make it happen more often by making it timeout the
aggregation agreement much more frequently than usual.

>> While we're here, unfortunately it turns out that just observing the
>> agg_status file can cause crashes (though not very often... except
>> for a few unlucky customers), probably due to a different race
>> condition.
>> Any suggestions about this one?  Stack trace attached below.  (I
>> think the stack trace suggests a mac80211 problem?)
>
> That has to be a mac80211 problem, yeah.
> (Side note: I'm a bit surprised this is a 32-bit system?)

We're going for all of good, fast, and cheap here.  That should end well :)

> Looks like we use RCU protection to get the data. Can I get the
> mac80211.ko binary (with debug data) corresponding to the crash below?

Yes.  Here it is:
http://apenwarr.ca/tmp/mac80211-agg-status-crash.ko

Thanks for your help!
