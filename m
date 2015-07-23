Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44196 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbGWRPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 13:15:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jonas Gorski <jogo@openwrt.org>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcma: fix linking problem with of_default_bus_match_table
References: <1437633104-23373-1-git-send-email-kvalo@codeaurora.org>
	<CAOiHx=k=p=0HJewHcVoKaypyrpbpyswes20jX6t3tha+OMf9aQ@mail.gmail.com>
	<87k2tqhnyc.fsf@kamboji.qca.qualcomm.com>
	<55B11085.5040909@openwrt.org>
Date: Thu, 23 Jul 2015 20:15:29 +0300
In-Reply-To: <55B11085.5040909@openwrt.org> (Jonas Gorski's message of "Thu,
	23 Jul 2015 18:04:21 +0200")
Message-ID: <877fpqhk26.fsf@kamboji.qca.qualcomm.com> (sfid-20150723_191540_054997_459ED078)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jonas Gorski <jogo@openwrt.org> writes:

>>> I think this isn't enough, AFAICT this needs IS_BUILTIN(CONFIG_BCMA)
>>> && IS_ENABLED(CONFIG_OF), else it will break with OF=n and BCMA=y, as
>>> of_default_bus_match_table is only defined/built-in when OF=y.
>> 
>> I just tested and OF=n and BCMA=y case built succesfully for me. I think
>> it's because of_default_bus_match_table is created even when CONFIG_OF
>> is n. Can you double check, please?
>> 
>
> Thinking more about it, I know/remember why it complies even if it
> shouldn't: the inline prototype for !OF of of_platform_populate does not
> use any of the arguments so the compiler optimises the reference out.
> So unless you compile with -O0, you are fine.

Thanks for checking. I think this is good enough for now and I'll apply
this once I get the report from kbuild.

-- 
Kalle Valo
