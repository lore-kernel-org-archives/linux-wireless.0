Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0HYPBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 11:01:10 -0400
Received: by wwb34 with SMTP id 34so1079152wwb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Aug 2010 08:01:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282746155.3667.6.camel@jlt3.sipsolutions.net>
References: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
	<1282746155.3667.6.camel@jlt3.sipsolutions.net>
Date: Wed, 25 Aug 2010 20:31:08 +0530
Message-ID: <AANLkTimmfc2=T01OSE1Th4KTvoLJJs7NyaW1WTAmY0ga@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath9k: Fix for throughput issue in Intel Pinetrail platform.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Aeolus.Yang@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 25, 2010 at 7:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-08-25 at 19:34 +0530, Vivek Natarajan wrote:
>> Trigger the generic timer interrupt frequently as a workaround
>> to improve the throughput in C3 state with the Intel Pinetrail
>> platform.
>
> This seems an awfully lot like a DMA problem with C3 states or something
> like that? It seems like you should do something like this:
>
>        pm_qos_add_request(&ipw2100_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
>                           PM_QOS_DEFAULT_VALUE);

Thanks a lot for your insights. We will try it out.

Vivek.
