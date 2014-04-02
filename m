Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12565 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbaDBHbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 03:31:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: remove not needed warning when peer unmap
References: <1396340628-4570-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 2 Apr 2014 10:31:31 +0300
In-Reply-To: <1396340628-4570-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 1 Apr 2014 10:23:48 +0200")
Message-ID: <877g78rxv0.fsf@kamboji.qca.qualcomm.com> (sfid-20140402_093140_892208_E63988C8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Remove not needed warning when get peer unmap
> event from the firmware. This is not critical
> message. Instead print this as a debug message.

I don't agree with that statement. If that would be true, we could
remove a lot of warnings from ath10k. We have these warnings to catch
problems early, which again improves the quality of the driver.

Your commit log was again missing the "why?" part. I assume the reason
for this patch is the problem of seeing the warning "unknown peer id 2"
when putting the interface is down, which again is a spurious event from
the firmware? You should document that in the commit log as well as add
a short comment to the code explaining why we only print a debug message
when that happens.

Other idea I had would be to keep the warning message but add a new test
to detect this problematic case, but I guess for that we would need to
add a new state "stopping" to catch that? For example, something like
this:

if state == stopping and event->id == 2
        dbg("foo")
else
        warn("bar")

-- 
Kalle Valo
