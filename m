Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38724 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756768AbcION47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 09:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <20160915134238.5167-1-colin.king@canonical.com>
References: <20160915134238.5167-1-colin.king@canonical.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 15 Sep 2016 23:56:38 +1000
Message-ID: <CAGRGNgVAWa8OK_qWkDapzy2L8oUhrXYCCfVYhrwWQc9F22vhVw@mail.gmail.com> (sfid-20160915_155719_805860_06424CAD)
Subject: Re: [PATCH] mwifiex: fix null pointer deference when adapter is null
To: Colin King <colin.king@canonical.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Thu, Sep 15, 2016 at 11:42 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> If adapter is null the error exit path in mwifiex_shutdown_sw is
> to down the semaphore sem and print some debug via mwifiex_dbg.
> However, passing a NULL adapter to mwifiex_dbg causes a null
> pointer deference when accessing adapter->dev.  This fix checks
> for a null adapter at the start of the function and to exit
> without the need to up the semaphore and we also skip the debug
> to avoid the null pointer dereference.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
