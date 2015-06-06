Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34455 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbFFNUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 09:20:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Severn <severn@xephris.net>, Larry.Finger@lwfinger.net,
	Taehee Yoo <ap420073@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtlwifi NULL pointer dereference
References: <5570FB00.3040108@xephris.net>
Date: Sat, 06 Jun 2015 16:20:08 +0300
In-Reply-To: <5570FB00.3040108@xephris.net> (severn@xephris.net's message of
	"Thu, 04 Jun 2015 21:27:28 -0400")
Message-ID: <87fv65nfcn.fsf@kamboji.qca.qualcomm.com> (sfid-20150606_152020_309362_A456A293)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Severn <severn@xephris.net> writes:

> I've been hitting this NULL pointer deref with an rtl8188ee PCIE card.
> It happens 100% of the time when I bring up a WPA2-PSK AP with hostapd
> 2.4.
>
> If I revert 33511b157bbcebaef853cc1811992b664a2e5862, everything seems
> to work properly.
>
> Below is my hostapd.conf and the crash log. This is mainline 4.0.4
> with no patches.

Below is the changelog for the commit. Larry & Taehee, what should we
do?

commit 33511b157bbcebaef853cc1811992b664a2e5862
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Wed Jan 21 16:58:19 2015 +0900

    rtlwifi: add support to send beacon frame.
    
    In AP mode, beacon frame is necessary to keep connection.
    this patch adds a sending beacon frame routine in initialization routine.
    
    Signed-off-by: Taehee Yoo <ap420073@gmail.com>
    Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>



-- 
Kalle Valo
