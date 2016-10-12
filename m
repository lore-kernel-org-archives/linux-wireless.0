Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43645 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755878AbcJLQy3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 12:54:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        "Stable \[ 4 . 8+ \]" <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH] rtlwifi: Fix regression caused by commit d86e64768859
References: <20161010233211.13519-1-Larry.Finger@lwfinger.net>
Date: Wed, 12 Oct 2016 19:54:22 +0300
In-Reply-To: <20161010233211.13519-1-Larry.Finger@lwfinger.net> (Larry
        Finger's message of "Mon, 10 Oct 2016 18:32:11 -0500")
Message-ID: <87zim9cxtt.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_185454_319057_4E91EBF9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> In commit d86e64768859 ("rtlwifi: rtl818x: constify local structures"),
> the configuration struct for most of the drivers was changed to be
> constant. The problem is that five of the modified drivers need to be
> able to update the firmware name based on the exact model of the card.
> As the file names were stored in one of the members of that struct,
> these drivers would fail with a kernel BUG splat when they tried to
> update the firmware name.
>
> Rather than reverting the previous commit, I used a suggestion by
> Johannes Berg and made the firmware file name pointers be local to
> the routines that update the software variables.
>
> The configuration struct of rtl8192cu, which was not touched in the
> previous patch, is now constantfied.
>
> Fixes: d86e64768859 ("rtlwifi: rtl818x: constify local structures")
> Suggested-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable [4.8+] <stable@vger.kernel.org>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>

I got warnings and after a quick look they look valid but not sure:

drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c: In function 'rtl92c_init_sw_vars':
drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c:179:6: warning: 'fw_name' may be used uninitialized in this function [-Wuninitialized]
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c: In function 'rtl8723e_init_sw_vars':
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c:187:6: warning: 'fw_name' may be used uninitialized in this function [-Wuninitialized]

(Sending manually for the second time as I don't see my first mail
anywhere.)

-- 
Kalle Valo
