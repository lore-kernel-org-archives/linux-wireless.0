Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64656 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2EUQsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 12:48:41 -0400
Received: by yenm10 with SMTP id m10so4503431yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 09:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBA6CD3.8020201@candelatech.com>
References: <4FB6D114.4050802@candelatech.com>
	<CAB3XZEem=2P36WgWXynoscemAhMrcgh0mKFocBbGhy8C-cJigQ@mail.gmail.com>
	<4FBA6CD3.8020201@candelatech.com>
Date: Mon, 21 May 2012 19:48:40 +0300
Message-ID: <CAB3XZEeFOQmZAbM-Er6u3Y7-ZbENdPUg-LiY_5RfyFN30vJFwA@mail.gmail.com> (sfid-20120521_184847_807230_EF9924B7)
Subject: Re: lockdep splat related to wifi regulatory in 3.3.6+
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 21, 2012 at 7:26 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 05/19/2012 03:42 PM, Eliad Peller wrote:
>
> Thanks, I will try your patch.
>
> But, it has a fairly scary comment about race conditions.
> Any idea why sort of symptoms I might see from this potential
> race?
>
i think that in the worst case it will cause a wrong regulatory domain
to be used (i.e. the global regulatory settings will be restored
although a new regdomain was set). however, it's pretty unlinely, and
probably still better than deadlocking...

Eliad.
