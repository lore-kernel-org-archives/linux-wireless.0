Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36056 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbcHZLuc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 07:50:32 -0400
Received: by mail-it0-f42.google.com with SMTP id e63so326694754ith.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2016 04:49:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472209920.390.34.camel@sipsolutions.net>
References: <20160826102250.24174-1-rmanohar@qti.qualcomm.com>
 <CAA93jw7vHWROH9Ymq1UoOKA5kw+fDbCM=vJehs8J=QP2PVs_RA@mail.gmail.com> <1472209920.390.34.camel@sipsolutions.net>
From: Dave Taht <dave.taht@gmail.com>
Date: Fri, 26 Aug 2016 04:49:56 -0700
Message-ID: <CAA93jw5mEMbUVs-i-Bpjkv6tX-umsO=9ZKPEnFcEj=22yjWX1g@mail.gmail.com> (sfid-20160826_135037_416780_7509C339)
Subject: Re: [PATCH v3] ath10k: implement NAPI support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 26, 2016 at 4:12 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2016-08-26 at 03:48 -0700, Dave Taht wrote:
>> I'm always rather big on people testing latency under load, and napi
>> tends to add some.
>
> That's a completely useless comment.
>
> Obviously, everybody uses NAPI; it's necessary for system load and thus
> performance, and lets drivers take advantage of TCP merging to reduce
> ACKs, which is tremendously helpful (over wifi in particular.)
>
> Please stop making such drive-by comments that focus only on the single
> thing you find important above all; not all people can care only about
> that single thing, and unconstructively reiterating it over and over
> doesn't help.

Well, I apologize for being testy. It is  I spent a lot of time
testing michal's patchset for the ath10k back in may, and I *will* go
and retest ath10k, when these patches land. My principal concern with
using napi is at lower rates than the maxes typically reported in a
patchset.

 But it would be nice if people always did test for latency under load
when making improvements, before getting to me, and despite having
helped make a very comprehensive test suite available (flent) that
tests all sorts of things for wifi, getting people to actually use it
to see real problems, (in addition to latency under load!) while their
fingers are still hot in the codebase, and track/plot their results,
remains an ongoing issue across the entire industry.

http://blog.cerowrt.org/post/fq_codel_on_ath10k/

There are many other problems in wifi, of course, that could use
engineering mental internalization, like airtime fairness, and the
mis-behavior of the hardware queues,

http://blog.cerowrt.org/post/cs5_lockout/

wifi channel scans

http://blog.cerowrt.org/post/disabling_channel_scans/

and so on.

I have a ton more datasets and blog entries left to write up from the
ath9k work thus far which point to some other issues (minstrel,
aggregation, retries)

> Thanks,
> johannes



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
