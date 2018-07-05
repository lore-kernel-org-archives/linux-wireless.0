Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753216AbeGEIlp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 04:41:45 -0400
Date: Thu, 5 Jul 2018 11:41:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix static checker warning to unlock
 mutex in wilc_deinit()
Message-ID: <20180705084126.jbqiduxkq7257asu@mwanda> (sfid-20180705_104148_157158_446A746A)
References: <1530762533-30510-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530762533-30510-1-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2018 at 09:18:53AM +0530, Ajay Singh wrote:
> Fix for static checker warning inconsistent returns of
> 'hif_deinit_lock'(more details [1]).
> 
> "drivers/staging/wilc1000/host_interface.c:3390 wilc_deinit()
>               warn: inconsistent returns 'hif_deinit_lock'."
> 
> Introduced in "ff52a57a7a42: staging: wilc1000: move the allocation of
> cmd out of wilc_enqueue_cmd()".

Can you use the Fixes tag so it's machine parseable?

Fixes: ff52a57a7a42 ("staging: wilc1000: move the allocation of cmd out of wilc_enqueue_cmd()")

With the fixes tag, say someone pulls ff52a57a7a42 into their code, they
will know to pull this patch as well.  Also scientists will be able to
measure the time between bug and fix and write a scholarly paper about
it.

regards,
dan carpenter
