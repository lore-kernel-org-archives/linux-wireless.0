Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753962AbcIQU75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 16:59:57 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
References: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Sat, 17 Sep 2016 16:59:55 -0400
In-Reply-To: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
        (Larry Finger's message of "Sat, 17 Sep 2016 12:09:15 -0500")
Message-ID: <wrfjbmzmmed0.fsf@redhat.com> (sfid-20160917_230001_007850_63597C38)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> As soon as debugging is turned on, the logs are filled with messages
> reporting the interrupt status. As this quantity is usually zero, this
> output is not needed. In fact, there will be a report if the status is
> not zero, thus the debug line in question could probably be deleted.
> Rather than taking that action, I have changed it to only be printed
> when the RTL8XXXU_DEBUG_USB bit is set in the debug mask.

Wrong flag, please add a RTL8XXXU_DEBUG_INTERRUPT flag instead and use
that.

Which device do you see this with?

Thanks,
Jes
