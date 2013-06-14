Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:33906 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab3FNMvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 08:51:19 -0400
Received: by mail-qe0-f54.google.com with SMTP id ne12so275146qeb.41
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 05:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130611161924.GB1696@redhat.com>
References: <20120418203543.GA16000@x61.home> <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home> <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com> <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com> <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com> <20130611161924.GB1696@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Fri, 14 Jun 2013 13:50:58 +0100
Message-ID: <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com> (sfid-20130614_145122_889096_DFA5D240)
Subject: Re: Power saving features for iwl4965
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 11, 2013 at 5:19 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jun 10, 2013 at 08:31:33PM +0100, Pedro Francisco wrote:
>> On Sun, Jun 9, 2013 at 1:28 AM, Pedro Francisco
>> <pedrogfrancisco@gmail.com> wrote:
>> > On Mon, Jun 3, 2013 at 3:18 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> >> On Mon, Jun 03, 2013 at 10:52:39AM +0200, Tino Keitel wrote:
>> >>> (...)
>> >>> It would be really nice to have proper power management in a current
>> >>> kernel, as the laptop gets noticeably hotter with the current iwlegacy
>> >>> driver.  That's why I still use a 3.1.10 kernel with an old
>> >>> forward-ported iwlagn driver.
>> >>
>> >> Could you try this experimental patch? (...)
>> >
>> > I am trying the iwlegacy powersave patch along with CPU scheduler BFS
>> > and IO scheduler BFQ.
>> >
>> > I've got this today: (...)
>> >
>> > (...)
>> I also got a SYSASSERT:
>> (...)
>>
>> I disabled powersave (but kept running the same kernel) and none of
>> the errors appeared again.
>
> Yes, this seems to be iwlegacy PS issue and has to be fixed before
> this patch could be applied.

But is it a driver-only issue? I had assumed it was some sort of
fireware+driver issue...

Will running with debug on help? Or is it easily reproducible on any
iwl3945 / iwl4465 ?

Because in my case (iwl3945) it happens after boot, no prior suspend
to RAM is required to trigger the issues.

P.S.: the demise of bugzilla.intellinuxwireless.org it's very
difficult to find useful info about this. It would appear 4465 is just
affected after suspend, believing the patch which disabled PS in 2009.
