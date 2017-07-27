Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdG0K4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:56:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 09/10] rtlwifi: use debugfs to debug.
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-10-Larry.Finger@lwfinger.net>
        <87vamew5d9.fsf@purkki.adurom.net> <5979C2EA.4080101@broadcom.com>
Date: Thu, 27 Jul 2017 13:56:49 +0300
In-Reply-To: <5979C2EA.4080101@broadcom.com> (Arend van Spriel's message of
        "Thu, 27 Jul 2017 12:39:38 +0200")
Message-ID: <871sp2ywpa.fsf@kamboji.qca.qualcomm.com> (sfid-20170727_125658_251182_BF8687BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 7/27/2017 12:17 PM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> From: Ping-Ke Shih <pkshih@realtek.com>
>>>
>>> Use debugfs to dump register and btcoex status.
>>
>> The title is useless and the commit log does not mention anything about
>> what files are added and to which location.
>>
>>> The kbuild test robot <lkp@intel.com> suggested a change to use
>>> simple_open() instead of a local routine.
>>
>> This comment doesn't belong to commit log, it should be in the changelog.
>>
>>> +void rtl_debugfs_add_topdir(void)
>>> +{
>>> +	debugfs_topdir = debugfs_create_dir("rtlwifi", NULL);
>>> +}
>>> +
>>> +void rtl_debugfs_remove_topdir(void)
>>> +{
>>> +	debugfs_remove_recursive(debugfs_topdir);
>>> +}
>>
>> I'm surprised to see that rtlwifi creates it's own top level debugfs
>> directory and does not use wiphy->debugfsdir. So how is this supposed to
>> work when we have multiple rtlwifi devices on the same system?
>
> In brcmfmac we also have our own top level debugfs dir because we do
> wiphy_new()/wiphy_register() kinda late. To cover the multiple devices
> issue we create a subdir per device, ie.
> /sys/kernel/debug/brcmfmac/mmc0:0001:1/.

Yeah, that's fine. If rtlwifi does the same that's good but document
that in the commit log.

-- 
Kalle Valo
