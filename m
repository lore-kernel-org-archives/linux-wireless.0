Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:57680 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3JZX43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Oct 2013 19:56:29 -0400
Received: by mail-qc0-f171.google.com with SMTP id i7so3106174qcq.30
        for <linux-wireless@vger.kernel.org>; Sat, 26 Oct 2013 16:56:29 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Oct 2013 16:56:28 -0700
Message-ID: <CAJ-Vmok4rDn1Q5qCU2Oz=CVsqkJvYC0D+CmQL+WpwU+9qKHzrw@mail.gmail.com> (sfid-20131027_015646_377052_C7E9EE0E)
Subject: iwlegacy (4965) - what would 0x8000 as the completed TX rate indicate?
From: Adrian Chadd <adrian@freebsd.org>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm debugging some issues that i see with the 4965 driver on FreeBSD. I
figure maybe someone here with experience with the iwlegacy driver may know.

I've set it up to do non-aggregate 11abg only traffic in my tests and I do
occasionally see the TX rate control completion status show the rate is
0x8000. I don't know to interpret it. It typically happens with the retry
count being non-zero, but there are also completed frames with non-zero
retry and normal rate results. The returned status is OK.

Here's an example:

Oct 26 16:06:11 lucy kernel: iwn4965_tx_done: qid 0 idx 210 retries 0 nkill
0 rate 4003 duration 294 status 201
Oct 26 16:06:11 lucy kernel: iwn4965_tx_done: qid 0 idx 211 retries 0 nkill
0 rate 4003 duration 182 status 201
Oct 26 16:06:11 lucy kernel: iwn4965_tx_done: qid 0 idx 212 retries 1 nkill
0 rate 8000 duration 616 status 201
Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 213 retries 0 nkill
0 rate 4003 duration 294 status 201
Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 214 retries 1 nkill
0 rate 8000 duration 292 status 201
Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 215 retries 0 nkill
0 rate 4003 duration 86 status 201
Oct 26 16:06:12 lucy kernel: iwn4965_tx_done: qid 0 idx 216 retries 0 nkill
0 rate 4003 duration 86 status 201

I definitely am programming the initial rate control fine and the flags
field doesn't have the linkq stuff set, so it should be transmitting only
at that rate.

The status indicates things are transmitting and completing fine.

So, any ideas what that 0x8000 rate in the rate completion means?

Thanks!


-adrian
