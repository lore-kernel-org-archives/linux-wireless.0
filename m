Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35975 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbdEIMZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:25:25 -0400
Message-ID: <1494332723.7796.74.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170509_142636_037602_BDA958D2)
Subject: Re: [PATCH] wil6210: Replace five seq_puts() calls by seq_putc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: wil6210@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Tue, 09 May 2017 05:25:23 -0700
In-Reply-To: <64747f85-e373-a0ff-b6dc-70cdfe35f71a@users.sourceforge.net>
References: <64747f85-e373-a0ff-b6dc-70cdfe35f71a@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-09 at 09:50 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 8 May 2017 22:22:04 +0200
> 
> Five single characters (line breaks) should be put into a sequence.
> Thus use the corresponding function "seq_putc".
> 
> This issue was detected by using the Coccinelle software.

There is no _issue_ at all here, only a matter of taste.

printf("\n")  or putchar('\n')  in some slow path is really not that
interesting.
