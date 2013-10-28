Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1OCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:02:49 -0400
Message-ID: <1382968966.17956.15.camel@jlt4.sipsolutions.net> (sfid-20131028_150252_393961_A747AB0E)
Subject: Re: iwlegacy (4965) - what would 0x8000 as the completed TX rate
 indicate?
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 28 Oct 2013 15:02:46 +0100
In-Reply-To: <CAJ-Vmok4rDn1Q5qCU2Oz=CVsqkJvYC0D+CmQL+WpwU+9qKHzrw@mail.gmail.com> (sfid-20131027_015646_377052_C7E9EE0E)
References: <CAJ-Vmok4rDn1Q5qCU2Oz=CVsqkJvYC0D+CmQL+WpwU+9qKHzrw@mail.gmail.com>
	 (sfid-20131027_015646_377052_C7E9EE0E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-10-26 at 16:56 -0700, Adrian Chadd wrote:
> Hi all,
> 
> I'm debugging some issues that i see with the 4965 driver on FreeBSD. I
> figure maybe someone here with experience with the iwlegacy driver may know.

My 4965 knowledge is rusty ...

> I've set it up to do non-aggregate 11abg only traffic in my tests and I do
> occasionally see the TX rate control completion status show the rate is
> 0x8000. I don't know to interpret it. It typically happens with the retry
> count being non-zero, but there are also completed frames with non-zero
> retry and normal rate results. The returned status is OK.

> Oct 26 16:06:11 lucy kernel: iwn4965_tx_done: qid 0 idx 210 retries 0 nkill 0 rate 4003 duration 294 status 201
> Oct 26 16:06:11 lucy kernel: iwn4965_tx_done: qid 0 idx 211 retries 0 nkill 0 rate 4003 duration 182 status 201
> Oct 26 16:06:11 lucy kernel: iwn4965_tx_done: qid 0 idx 212 retries 1 nkill 0 rate 8000 duration 616 status 201
> Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 213 retries 0 nkill 0 rate 4003 duration 294 status 201
> Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 214 retries 1 nkill 0 rate 8000 duration 292 status 201
> Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 215 retries 0 nkill 0 rate 4003 duration 86 status 201
> Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 216 retries 0 nkill 0 rate 4003 duration 86 status 201
> 
> I definitely am programming the initial rate control fine and the flags
> field doesn't have the linkq stuff set, so it should be transmitting only
> at that rate.
> 
> The status indicates things are transmitting and completing fine.
> 
> So, any ideas what that 0x8000 rate in the rate completion means?

I think that just means it used the other antenna and rate 0, since the
bits 0x1c000 contain the antenna bitmap that was used (up to three can
be used for each transmission)

johannes

