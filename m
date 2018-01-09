Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbeAIHjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 02:39:45 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Xinming Hu <huxm@marvell.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: Re: [PATCH] mwifiex: cancel pcie/sdio work in remove/shutdown handler
References: <1513164473-13827-1-git-send-email-huxm@marvell.com>
        <20180108181117.GA129772@google.com>
Date: Tue, 09 Jan 2018 09:39:39 +0200
In-Reply-To: <20180108181117.GA129772@google.com> (Brian Norris's message of
        "Mon, 8 Jan 2018 10:11:18 -0800")
Message-ID: <87373f32h0.fsf@kamboji.qca.qualcomm.com> (sfid-20180109_083950_037615_40C9C89B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> @@ -310,6 +310,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>>  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
>>  	}
>>  
>> +	cancel_work_sync(&card->work);
>> +
>
> Just FYI, this "fix" is not a real fix. It will likely paper over some
> of your bugs (where, e.g., the FW shutdown command times out in the
> previous couple of lines), but this highlights the fact that there are
> other races that could trigger the same behavior. You're not fixing
> those.
>
> For example, what if somebody initiates a scan or other nl80211 command
> between the above line and mwifiex_remove_card()? That command could
> potentially time out too.
>
> The proper fix would be to institute some kind of mutual exclusion
> (locking) between mwifiex_shutdown_sw() and mwifiex_remove_card(), so
> that they can't occur at the same time.
>
> Unfortunately, I only paid attention to this after Kalle already applied
> this patch. Personally, I'd prefer this patch not get applied, since
> it's a bad solution to an obvious problem, which instead leaves a subtle
> problem that perhaps no one will bother fixing.

I can revert it, that's not a problem. Can I use the text below as
explanation for the revert?

----------------------------------------------------------------------
Brian Norris <briannorris@chromium.org> says:

Just FYI, this "fix" is not a real fix. It will likely paper over some
of your bugs (where, e.g., the FW shutdown command times out in the
previous couple of lines), but this highlights the fact that there are
other races that could trigger the same behavior. You're not fixing
those.

For example, what if somebody initiates a scan or other nl80211 command
between the above line and mwifiex_remove_card()? That command could
potentially time out too.

The proper fix would be to institute some kind of mutual exclusion
(locking) between mwifiex_shutdown_sw() and mwifiex_remove_card(), so
that they can't occur at the same time.

----------------------------------------------------------------------

-- 
Kalle Valo
