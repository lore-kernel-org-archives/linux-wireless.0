Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbeAQPNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 10:13:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,
 01/10] rtlwifi: Use mutex to replace spin_lock to protect IPS and LPS
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180117061530.30049-2-pkshih@realtek.com>
References: <20180117061530.30049-2-pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <yhchuang@realtek.com>,
        <linux-wireless@vger.kernel.org>
Message-Id: <20180117151309.3B34A6081E@smtp.codeaurora.org> (sfid-20180117_161313_459339_F7F6E403)
Date: Wed, 17 Jan 2018 15:13:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Enter/leavel IPS and LPS are large critical section, and they can't use
> sleep function because running in atomic-context, which own a spin_lock.
> In commit ba9f93f82aba ("rtlwifi: Fix enter/exit power_save"), it moves
> LPS functions to thread-context, so this commit can simply change LPS's
> spin lock to mutex.
> Considering IPS functions, rtl_ips_nic_on() may be called by TX tasklet
> (softirq-context) that check whether packet is auth frame. Fortunately,
> current mac80211 will ask driver to leave IPS using op_config with
> changed flag IEEE80211_CONF_CHANGE_IDLE, before issuing auth frame, so
> IPS functions can run in thread-context and use mutex to protect critical
> section, too.
> Also, this commit removes some useless spin locks.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

8 patches applied to wireless-drivers-next.git, thanks.

a3fa3669d18c rtlwifi: Use mutex to replace spin_lock to protect IPS and LPS
c8abbe79cce6 rtlwifi: fix scan channel 1 fail after IPS
37e89a0e5aa0 rtlwifi: unlink bss when un-association
a44709bba70f rtlwifi: btcoex: Add power_on_setting routine
40d9dd4f1c5d rtlwifi: btcoex: Remove global variables from btcoex
3afb7da4693c rtlwifi: btcoex: Remove typedef statements
b2283dad6bfd rtlwifi: btcoex: Add common function for qeurying BT information
188b6b092e3a rtlwifi: btcoex: add rfe_type parameter to btcoex

-- 
https://patchwork.kernel.org/patch/10168581/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
