Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36425 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556AbcDGVM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 17:12:58 -0400
Received: by mail-wm0-f51.google.com with SMTP id v188so69422682wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 14:12:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160407130251.GA19696@c50.bag.software>
References: <20160407130251.GA19696@c50.bag.software>
Date: Thu, 7 Apr 2016 23:12:57 +0200
Message-ID: <CALtMJEDOLgVCvjORGbBN3iQ5Wi-17X16YRMaMKxXGEK9uLPG3A@mail.gmail.com> (sfid-20160407_231315_205662_7994FFBB)
Subject: Re: mwifiex: kernel WARN_ON during system suspend
From: Andreas Fenkart <afenkart@gmail.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vishal,

2016-04-07 15:02 GMT+02:00 Vishal Thanki <vishalthanki@gmail.com>:
> Hi All,
>
> I noticed that sometime I see the kernel trace while system enters into
> suspend. The trace log is attached with this email.
>
> From the kernel trace it appears that mwifiex_cancel_all_pending_cmd()
> function tries to cancel the current command by invoking
> mwifiex_complete_cmd(). Just before calling this routine, the
> adapter->curr_cmd->wait_q_enabled is set to false. And there is a
> WARN_ON() in the mwifiex_complete_cmd() routine on this variable being
> false, because this condition will always evaluate to true.

thanks for the analysis.
tested-by: afenkart@gmail.com

>
> I think by setting the wait_q_enabled flag to false after calling the
> mwifiex_complete_cmd() should fix this problem. I have attached the
> patch for the same, however I am not sure if that is the right way to
> fix this issue. If there is any better way to fix it, please suggest.
>
> Thanks,
> Vishal
