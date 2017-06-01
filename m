Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdFAJmA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 05:42:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/7] rtlwifi: btcoex: update new btcoex version
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170526184147.31239-2-Larry.Finger@lwfinger.net>
References: <20170526184147.31239-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>, lkp@intel.com
Message-Id: <20170601094159.E09236074A@smtp.codeaurora.org> (sfid-20170601_114213_930266_0BE3E404)
Date: Thu,  1 Jun 2017 09:41:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This patch updates the btcoexist to a newer version with some callbacks.
> 
> Specific issues fixed are
> pre_load_firmware()
> 	fix the unstable issues before FW is ready
> power_on_seting()
> 	fix the unstable issues before HW is ready
> Some notify finctions, check hardware type and call corresponding
> functions to specific chip
> 
> As noted by the kbuild test robot <lkp@intel.com>, there was a missing
> global. This problem has been fixed.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>
> Cc: lkp@intel.com

There are two red flags which immediately caught my attention: "update to a
newer version" and listing multiple changes in the commit log. A patch should
have one logical change but this one seems to have a lot of changes which makes
it difficult to track what has changed. This definitely should split into
smaller patches.

I'll still try to commit patches 2-7, hopefully they don't depend on anything
in this patch.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9750977/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
