Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdG0KR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 06:17:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v4 09/10] rtlwifi: use debugfs to debug.
References: <20170702181239.17911-1-Larry.Finger@lwfinger.net>
        <20170702181239.17911-10-Larry.Finger@lwfinger.net>
Date: Thu, 27 Jul 2017 13:17:54 +0300
In-Reply-To: <20170702181239.17911-10-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Sun, 2 Jul 2017 13:12:38 -0500")
Message-ID: <87vamew5d9.fsf@purkki.adurom.net> (sfid-20170727_121803_199938_182F3775)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> Use debugfs to dump register and btcoex status.

The title is useless and the commit log does not mention anything about
what files are added and to which location.

> The kbuild test robot <lkp@intel.com> suggested a change to use
> simple_open() instead of a local routine.

This comment doesn't belong to commit log, it should be in the changelog.

> +void rtl_debugfs_add_topdir(void)
> +{
> +	debugfs_topdir = debugfs_create_dir("rtlwifi", NULL);
> +}
> +
> +void rtl_debugfs_remove_topdir(void)
> +{
> +	debugfs_remove_recursive(debugfs_topdir);
> +}

I'm surprised to see that rtlwifi creates it's own top level debugfs
directory and does not use wiphy->debugfsdir. So how is this supposed to
work when we have multiple rtlwifi devices on the same system?

-- 
Kalle Valo
