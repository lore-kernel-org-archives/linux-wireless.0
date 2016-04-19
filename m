Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34875 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcDSBaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 21:30:03 -0400
Received: by mail-ob0-f182.google.com with SMTP id n10so827792obb.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 18:30:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAArymCnGTj4qv8KWwDfwSN0DQvTTpTwC+-sHSkMfjNVs2Rr_sg@mail.gmail.com>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
 <1455658091-28262-1-git-send-email-apenwarr@gmail.com> <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
 <1456222441.2041.10.camel@sipsolutions.net> <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
 <1456257946.9910.23.camel@sipsolutions.net> <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com>
 <1459928436.17504.11.camel@sipsolutions.net> <CAHqTa-3VtwYWLUHQuFyqtmMwPE2XQYJD4-U+-1PqXKtmTFrEgA@mail.gmail.com>
 <1460098614.30678.1.camel@sipsolutions.net> <1460098909.30678.2.camel@sipsolutions.net>
 <1460099746.30678.3.camel@sipsolutions.net> <CAHqTa-1SO+asqf7Fn2d+J_w8vvJ1CnnMG8AGB2O1CBjeaaL8hA@mail.gmail.com>
 <CAHqTa-0oji0=-CMYbQ6PQw-R5_jsuUjAAtERwDvLieBD=ObCKw@mail.gmail.com>
 <1460177816.7409.4.camel@sipsolutions.net> <CAJ-Vmon7Qyms95U4AuidkqMcGFPqXi3pWuEQastUdHe7B6hfFA@mail.gmail.com>
 <CAArymCnGTj4qv8KWwDfwSN0DQvTTpTwC+-sHSkMfjNVs2Rr_sg@mail.gmail.com>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Mon, 18 Apr 2016 21:29:42 -0400
Message-ID: <CAHqTa-1k+QVj2dC3F44fMYMfvh5PpW4QXyVn0NkCcPFrkd5OVg@mail.gmail.com> (sfid-20160419_033016_861398_F8990481)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
To: bruce m beach <brucembeach@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 9, 2016 at 9:59 PM, bruce m beach <brucembeach@gmail.com> wrote:
>> If any people more familiar with ARM are reading this - does the value
>> 0x5b35da40 ring a bell?
>
> It could be anything. It depends on the chip implementation. For instance on an
> exynos that is an undefined region. What device are we talking about?

This is a mindspeed c2k CPU, in case that helps at all.  But I'm
guessing it really is just some pointer garbage.  The only way to
trigger the crash is to do (something) with an attached station at the
same moment as reading the agg_status file.  Some station types
trigger it more than others, but I'm not sure which.
