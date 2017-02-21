Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59505 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754508AbdBUSEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 13:04:21 -0500
Date: Tue, 21 Feb 2017 19:04:19 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V3 1/2] firmware: add more flexible
 request_firmware_async function
Message-ID: <20170221180419.GM31264@wotan.suse.de> (sfid-20170221_200604_917589_EE0D5B6D)
References: <20170216072636.7128-1-zajec5@gmail.com>
 <20170221094754.15406-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170221094754.15406-1-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2017 at 10:47:53AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far we got only one function for loading firmware asynchronously:
> request_firmware_nowait. It didn't allow much customization of firmware
> loading process - there is only one bool uevent argument. Moreover this
> bool also controls user helper in an unclear way.
> 
> Resolve this problem by adding a one flexible function and making old
> request_firmware_nowait a simple inline using new solution. This
> implementation:
> 1) Modifies only single bits on existing code
> 2) Doesn't require adjusting / rewriting current drivers
> 3) Adds new function for drivers that need more control over loading a
>    firmware. Thanks to using flags more features can be added later.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> This patch is based on top of
> [PATCH V2 RESEND] firmware: simplify defining and handling FW_OPT_FALLBACK
> applied on top of Linux 4.10-rc8.
> 
> Ming/Luis/Greg: assuming this gets a positive review, could someone of you pick
> this patchset? Second patch modifies brcmfmac, I'll try to get a proper Ack for
> that one.
> Unless you want this to go through wireless tree, then let me know please.

As noted in the v1 and v2 series:

This is not as flexible as we need. I'll fold this functionality in to the
driver data series as it provides more flexibility and enables more testing to
be done in userspace.

  Luis
