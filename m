Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:46039 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab3GKOiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 10:38:18 -0400
Received: by mail-qe0-f49.google.com with SMTP id cz11so4396438qeb.22
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 07:38:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951035636367@SC-VEXCH1.marvell.com>
References: <CAMLZHHR_8Zsp2xe=9x4oJ1Rj7XLGOEza3r0uPt_Ht8TDC781aQ@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951035636367@SC-VEXCH1.marvell.com>
Date: Thu, 11 Jul 2013 08:38:17 -0600
Message-ID: <CAMLZHHQUghAsT8AM2to2rNJ3nwCfYEvPaqTcEk_7GmPWTOpQyQ@mail.gmail.com> (sfid-20130711_163837_105674_9BB88083)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 11, 2013 at 8:17 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Daniel,
>
> Thanks for your elaborative comments. We can go with your patch which fixes the issue in a cleaner way. I ran some tests and verified remove path with it.

Hmm. Now that I heard back from you and Bing, that interrupts at this
point are totally unexpected, I would prefer to see the interrupt
handler being disabled at the appropriate time, I think we can do
better than my original patch. Let me see if I can find some time
today/tomorrow to explore a better approach.

Daniel
