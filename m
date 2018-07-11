Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:35689 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732277AbeGKCXq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 22:23:46 -0400
Received: by mail-pl0-f68.google.com with SMTP id k1-v6so8447304plt.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 19:21:50 -0700 (PDT)
Date: Tue, 10 Jul 2018 19:24:25 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Govind Singh <govinds@codeaurora.org>, david.brown@linaro.org,
        andy.gross@linaro.org, niklas.cassel@linaro.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/6] *** Add support for wifi QMI client handshakes ***
Message-ID: <20180711022425.GI2050@tuxbook-pro> (sfid-20180711_042153_266893_A2F09C3A)
References: <20180706085622.27945-1-govinds@codeaurora.org>
 <20180711012638.GA100410@ban.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180711012638.GA100410@ban.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 10 Jul 18:26 PDT 2018, Brian Norris wrote:

> Hi,
> 

Hi Brian,

> On Fri, Jul 06, 2018 at 02:26:17PM +0530, Govind Singh wrote:
[..]
> > https://github.com/andersson/tqftpserv
> 
> FWIW, as of today, the tqftpserv implementation is missing a few headers
> (so it doesn't even build),

Sorry about that, had those lingering in my repository. I've pushed a
fix for this.

> and once I hack things such that it can
> build, it still doesn't work for me (whereas the closed source version
> does). I see some BYE and DEL_CLIENT messages, but no read requests.

I interpret this description as you're not seeing any prints at, beyond
the "[TQFTP] got bye" and "[TQFTP] got del_client"?

That would imply that the remote side doesn't even attempt to
communicate with tqftpserv.

Are you running pd-mapper (either proprietary or my version), is it
complaining about anything?

Can you run qrtr-lookup on the device after booting the modem? So that
we see that the tqftpserv is registered properly and that the modem is
in an appropriate state?

Regards,
Bjorn
