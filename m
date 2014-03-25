Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:51317 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaCYIde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:33:34 -0400
Received: by mail-ve0-f178.google.com with SMTP id jw12so146346veb.9
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 01:33:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
Date: Tue, 25 Mar 2014 16:33:34 +0800
Message-ID: <CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com> (sfid-20140325_093348_015992_5A3B6CC7)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Michal

> I suppose there's a limit how much peer entries firmware is able to
> pack up into a single event. The second event you handle here is still
> going to have some sort of a limit and you'll end up dropping results
> again. The same probably goes with vdev stats (which aren't handled
> yet, but hey).

vdev stats is not supported by firmware 999.999.0.636, am I right?
BTW, I also saw that the same happen to latest AP firmware whenever
the peer stats is more than 1. But since the first peer stats is self
stats, so it is ok to overwrite it.

> I think a better approach would be to make read_target_stats *append*
> data to the stats structure and make ath10k wait for more possible
> events instead of being satisfied with just one.
>
> The way you do it now seems like you end up with the extra results
> being shown upon *next* stat request-response.. i.e. you see old
> results.

Will take a look on this.

----
Chun-Yeow
