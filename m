Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753130AbeDUHu4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Apr 2018 03:50:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: luciano.coelho@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: New sparse warning from min_t(): expression using sizeof(void)
Date: Sat, 21 Apr 2018 10:50:51 +0300
Message-ID: <87a7txf15w.fsf@kamboji.qca.qualcomm.com> (sfid-20180421_095134_836656_1D9E896B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kees&Linus,

after upgrading to v4.17-rc1 I started to see this sparse warning from
min_t():

drivers/net/wireless/ath/ath10k/wmi.c:4620:31: warning: expression using sizeof(void)

I counted 167 such warnings just from ath10k alone and Luca told me that
he sees similar sparse warnings with iwlwifi as well. My sparse is
pretty old (v0.5.0-44-g40791b94c56b) but Luca said updating sparse to
0.5.2 didn't help. I also see this with latest commit from Linus' tree
(83beed7b2b26).

After reverting these two commits the sparse warnings go away:

e9092d0d9796 Fix subtle macro variable shadowing in min_not_zero()
3c8ba0d61d04 kernel.h: Retain constant expression output for max()/min()

I had to revert e9092d0d9796 due to conflicts but it seems 3c8ba0d61d04
is the actual commit causing these warnings.

Is there any way to fix it? With ath10k I use sparse a lot and because
of these warnings sparse is now very annoying to use.

-- 
Kalle Valo
