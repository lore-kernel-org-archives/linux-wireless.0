Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34826 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab0I0Sto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 14:49:44 -0400
Received: by iwn5 with SMTP id 5so4943219iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:49:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285611630.4043.26.camel@jlt3.sipsolutions.net>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com> <1285611630.4043.26.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 27 Sep 2010 11:49:22 -0700
Message-ID: <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 11:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-09-27 at 11:14 -0700, Luis R. Rodriguez wrote:
>> On Thu, Sep 23, 2010 at 11:27 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > Even if the reorder timeout timer fires while
>> > scanning, the frames weren't received during
>> > scanning and therefore shouldn't be dropped.
>>
>> I don't get what we are doing with these frames today, are you saying
>> we pegged some of these frames into the reorder buffer when starting a
>> sw scan, or that we were dropping them?
>
> You keep confusing TX and RX ... ;)
>
> This is all about RX only.

yeah, I was thinking about the release reorder buffer and its
respective timeout, I thought that's what the subject of this patch
was about.

  Luis
