Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:37499 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdG0Kjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:39:41 -0400
Received: by mail-wr0-f170.google.com with SMTP id 33so85378808wrz.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jul 2017 03:39:41 -0700 (PDT)
Message-ID: <5979C2EA.4080101@broadcom.com> (sfid-20170727_123956_200882_BCB516EC)
Date: Thu, 27 Jul 2017 12:39:38 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 09/10] rtlwifi: use debugfs to debug.
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>        <20170702181239.17911-10-Larry.Finger@lwfinger.net> <87vamew5d9.fsf@purkki.adurom.net>
In-Reply-To: <87vamew5d9.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/27/2017 12:17 PM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> Use debugfs to dump register and btcoex status.
>
> The title is useless and the commit log does not mention anything about
> what files are added and to which location.
>
>> The kbuild test robot <lkp@intel.com> suggested a change to use
>> simple_open() instead of a local routine.
>
> This comment doesn't belong to commit log, it should be in the changelog.
>
>> +void rtl_debugfs_add_topdir(void)
>> +{
>> +	debugfs_topdir = debugfs_create_dir("rtlwifi", NULL);
>> +}
>> +
>> +void rtl_debugfs_remove_topdir(void)
>> +{
>> +	debugfs_remove_recursive(debugfs_topdir);
>> +}
>
> I'm surprised to see that rtlwifi creates it's own top level debugfs
> directory and does not use wiphy->debugfsdir. So how is this supposed to
> work when we have multiple rtlwifi devices on the same system?

In brcmfmac we also have our own top level debugfs dir because we do 
wiphy_new()/wiphy_register() kinda late. To cover the multiple devices 
issue we create a subdir per device, ie. 
/sys/kernel/debug/brcmfmac/mmc0:0001:1/.

Regards,
Arend
