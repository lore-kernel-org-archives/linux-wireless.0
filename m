Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:33079 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbbESFQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 01:16:54 -0400
Received: by lagr1 with SMTP id r1so6041224lag.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 22:16:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <555AC172.4040507@lwfinger.net>
References: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com>
	<55575AC8.2060301@lwfinger.net>
	<CAJ=9CzasMnjhMSWT0P=eenvaeDA04Q2aGhY0z1npD-NDuh7YeQ@mail.gmail.com>
	<5557844B.4040108@lwfinger.net>
	<CAJ=9CzamCxkwVtTtUzU9zatocUPz0W+3f0Kgm6N0tDMWbcP_LA@mail.gmail.com>
	<55586D8D.7040407@gmail.com>
	<CAJ=9CzbxScr7SJjhxnxAWt+xS-A8VR-_PQs0BbbdUp7xCaG2aw@mail.gmail.com>
	<CAJ=9CzaDK+oKJ8JJtb_OE6wrh85f8ffPf_oa9c0GRQFStUULjg@mail.gmail.com>
	<555A05DC.8080704@lwfinger.net>
	<CAJ=9CzY3E0Y3++g6sWEmgBQ70YmJEJaUdunN9AS4obLT4-WaBQ@mail.gmail.com>
	<555AC172.4040507@lwfinger.net>
Date: Tue, 19 May 2015 08:16:52 +0300
Message-ID: <CAJ=9CzZBp0FpZurhJouPU_u-oHQPUu08Fqa59iFdAwrdxbdiNA@mail.gmail.com> (sfid-20150519_071824_447031_D33EC00B)
Subject: Re: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 May 2015 at 07:52, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> I checked the driver with Smatch and found a couple of array problems. These
> likely won't be the problem, but try the attached patches anyway.

I tried the patches. The first one prevents the driver from working. I
think the smatch warning may be a false positive, because HWXMIT_ENTRY
is checked specifically for values 4 and 5 in an if statement.

The second patch doesn't hurt, but it didn't solve the issue.
