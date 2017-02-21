Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdBUSCN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 13:02:13 -0500
Date: Tue, 21 Feb 2017 19:02:10 +0100
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
Subject: Re: [PATCH V2 1/2] firmware: add more flexible
 request_firmware_async function
Message-ID: <20170221180210.GL31264@wotan.suse.de> (sfid-20170221_190216_457454_BC6FAD20)
References: <20170215222948.21030-1-zajec5@gmail.com>
 <20170216072636.7128-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170216072636.7128-1-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 16, 2017 at 08:26:35AM +0100, Rafał Miłecki wrote:
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

As I noted in the v1 post, just exposing all the flags under the hood is not
enough to ensure sanity here. Additionally just flags won't cut it to make this
as flexible as we need. I've addressed this in the driver data series, so I'll
take this feature request and fold it in there.

  Luis
