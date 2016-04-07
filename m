Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36214 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcDGVR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 17:17:26 -0400
Received: by mail-lb0-f180.google.com with SMTP id bk9so30677315lbc.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 14:17:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALtMJEDOLgVCvjORGbBN3iQ5Wi-17X16YRMaMKxXGEK9uLPG3A@mail.gmail.com>
References: <20160407130251.GA19696@c50.bag.software> <CALtMJEDOLgVCvjORGbBN3iQ5Wi-17X16YRMaMKxXGEK9uLPG3A@mail.gmail.com>
From: Vishal Thanki <vishalthanki@gmail.com>
Date: Thu, 7 Apr 2016 23:17:05 +0200
Message-ID: <CAC3a_SDD=2cToDcVPAQpWZoy+HPTukdrHbHwQZPRQR+ts=Wskw@mail.gmail.com> (sfid-20160407_231729_484598_AABC1365)
Subject: Re: mwifiex: kernel WARN_ON during system suspend
To: Andreas Fenkart <afenkart@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 7, 2016 at 11:12 PM, Andreas Fenkart <afenkart@gmail.com> wrote:
> Hi Vishal,
>
> 2016-04-07 15:02 GMT+02:00 Vishal Thanki <vishalthanki@gmail.com>:
>> Hi All,
>>
>> I noticed that sometime I see the kernel trace while system enters into
>> suspend. The trace log is attached with this email.
>>
>> From the kernel trace it appears that mwifiex_cancel_all_pending_cmd()
>> function tries to cancel the current command by invoking
>> mwifiex_complete_cmd(). Just before calling this routine, the
>> adapter->curr_cmd->wait_q_enabled is set to false. And there is a
>> WARN_ON() in the mwifiex_complete_cmd() routine on this variable being
>> false, because this condition will always evaluate to true.
>
> thanks for the analysis.
> tested-by: afenkart@gmail.com
>

Thanks for the feedback. Should I submit the patch as a separate email?

Vishal
