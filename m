Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39669 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaCYIpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:45:22 -0400
Received: by mail-ob0-f175.google.com with SMTP id uy5so159162obc.20
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 01:45:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com>
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
	<CAEFj9867Z+x3orcwUpwjwQB-9c5r4FfAuZBHYDGZ1hNe=6Z1pA@mail.gmail.com>
Date: Tue, 25 Mar 2014 09:45:22 +0100
Message-ID: <CA+BoTQn4ji2boTV8x-owO8PbaPm510wYEKmbKqf+VS+MS+DXnQ@mail.gmail.com> (sfid-20140325_094542_766085_75CF9A68)
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2014 09:33, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Michal
>
>> I suppose there's a limit how much peer entries firmware is able to
>> pack up into a single event. The second event you handle here is still
>> going to have some sort of a limit and you'll end up dropping results
>> again. The same probably goes with vdev stats (which aren't handled
>> yet, but hey).
>
> vdev stats is not supported by firmware 999.999.0.636, am I right?

True, but once it is supported then it will most likely need the same
treatment as peer stats.


> BTW, I also saw that the same happen to latest AP firmware whenever
> the peer stats is more than 1. But since the first peer stats is self
> stats, so it is ok to overwrite it.

I disagree. Why do you think it is okay to overwrite self peer stats?

Btw. 10.1 firmware has more pdev stats which breaks parsing of peer entries...


Michał
