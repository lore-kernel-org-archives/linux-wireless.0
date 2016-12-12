Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58679 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbcLLONK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 09:13:10 -0500
Date: Mon, 12 Dec 2016 15:13:02 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: Could we have request_firmware_nowait with FW_OPT_NO_WARN?
Message-ID: <20161212141302.GC1402@wotan.suse.de> (sfid-20161212_151329_606563_88265219)
References: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxOGo0e9U7eXpUgnnBuxL+x1B0JBf9ZBq2WPbaBE=YZ-g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 10, 2016 at 04:54:41PM +0100, Rafał Miłecki wrote:
> So it would be nice to have version of request_firmware_nowait with
> FW_OPT_NO_WARN. If requesting firmware NVRAM fails *and* getting
> platform NVRAM fails, then I could to print error on my own.
> Does it make sense? Can you see a point of my request?

request_firmware_direct() does hat you describe but this is only 
available for synchronous requests. My old sysdata patches -- which
I need to "rebrand" as the only issue found was the naming -- added
an equivalent to request_firmware_direct() for async calls. The newer
API simply has 2 API exported calls, the idea is we'd enable the caller
to configure the request as per their requirements instead of adding
a new exported routine per new feature.

I'll update docs, rebase my patches by rebranding them, and also add
a bit more as per some recent discussion to resolve the pivot_root()
races upon init if you do not use initramfs. I'll be sure to Cc you.

  Luis
