Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35617 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdG3X6A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Jul 2017 19:58:00 -0400
Received: by mail-oi0-f68.google.com with SMTP id q70so18993427oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jul 2017 16:58:00 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Fix fallback firmware loading
To: Sven Joachim <svenjoac@gmx.de>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <87k22sq0de.fsf@turtle.gmx.de> <87a83noaxw.fsf@turtle.gmx.de>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d1c1790d-015d-4dae-8532-42701737eea3@lwfinger.net> (sfid-20170731_020108_388584_1DE8CB3D)
Date: Sun, 30 Jul 2017 18:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <87a83noaxw.fsf@turtle.gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2017 04:21 AM, Sven Joachim wrote:
> Commit f70e4df2 ("rtlwifi: Add code to read new versions of firmware")
> added code to load an old firmware file if the new one is not
> available.  Unfortunately that code is never reached because
> request_firmware_nowait() does not wait for the firmware to show up
> and returns 0 even if the file is not there.
> 
> Use the existing fallback mechanism introduced by commit
> 62009b7f ("rtlwifi: rtl8192cu: Add new firmware") instead.
> 
> Fixes: f70e4df2b384d21e36a7c30a591639592692e0ec
> Cc: stable@vger.kernel.org
> Signed-off-by: Sven Joachim <svenjoac@gmx.de>

Your solution seems to be correct; however, your patch fails to apply. Make 
certain that you have the latest pull on the wireless-drivers-next repo. In 
particular, it needs commit f2764f61fa105 by Souptik Jarder, which changed the 
error return.

NACK.

Larry
