Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLHMWP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:22:15 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Subject: Re: [PATCH 6/6] iwlwifi: fix access to prph when transport is stopped
References: <20171125153510.25359-1-luca@coelho.fi>
        <20171125153510.25359-7-luca@coelho.fi>
        <87mv351iys.fsf@kamboji.qca.qualcomm.com>
        <1511951353.4827.27.camel@coelho.fi>
Date: Fri, 08 Dec 2017 14:22:02 +0200
In-Reply-To: <1511951353.4827.27.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 29 Nov 2017 12:29:13 +0200")
Message-ID: <87efo5s93p.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_132221_472808_0B2912F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Wed, 2017-11-29 at 12:23 +0200, Kalle Valo wrote:
>
>> But no wonder I called gnus-article-fill-cited-article, the commit
>> log is just weirdly wrapped. Are you using outlook or how do you get
>> it so ugly? :)
>
> Heh! I don't think it's wrapped weirdly, it's just that the paragraphs
> don't have spaces between them, right? ;)

Sorry, don't get what you mean with missing spaces. To me (and
patchwork[1] and git[2] seem to agree) the word wrapping is just broken
for this commit log, and I have seen it also with other iwlwifi commits.
For example, there are just two words in the second line "two paths."

The standard format for git commit logs is something like this:

----------------------------------------------------------------------
When getting HW rfkill we get stop_device being called from two paths.
One path is the IRQ calling stop device, and updating op mode and stack.
As a result, cfg80211 is running rfkill sync work that shuts down all
devices (second path). In the second path, we eventually get to
iwl_mvm_stop_device which calls iwl_fw_dump_conf_clear->iwl_fw_dbg_stop_recording,
that access periphery registers.

The device may be stopped at this point from the first path,
which will result with a failure to access those registers. Simply
checking for the trans status is insufficient, since the race will still
exist, only minimized. Instead, move the stop from
iwl_fw_dump_conf_clear (which is getting called only from stop path) to
the transport stop device function, where the access is always safe.
This has the added value, of actually stopping dbgc before stopping
device even when the stop is initiated from the transport.
----------------------------------------------------------------------

[1] https://patchwork.kernel.org/patch/10074849/

[2] https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=0232d2cd7aa8e1b810fe84fb4059a0bd1eabe2ba

-- 
Kalle Valo
