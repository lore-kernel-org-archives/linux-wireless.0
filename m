Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57445 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752417AbcJJQ4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 12:56:22 -0400
Message-ID: <1476118573.7895.13.camel@sipsolutions.net> (sfid-20161010_185641_470417_1EAF3391)
Subject: Re: [PATCH] Revert "rtlwifi: rtl818x: constify local structures"
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 10 Oct 2016 18:56:13 +0200
In-Reply-To: <20161010152520.9812-1-Larry.Finger@lwfinger.net> (sfid-20161010_172530_909818_2A75F665)
References: <20161010152520.9812-1-Larry.Finger@lwfinger.net>
         (sfid-20161010_172530_909818_2A75F665)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-10 at 10:25 -0500, Larry Finger wrote:
> This reverts commit d86e64768859fca82c78e52877ceeba04e25d27a.
> 
> For drivers rtl8188ee, rtl8192ce, rtl8192ee, rtl8723ae, and
> rtl8821ae,
> the Coccinelle script missed the fact that the code changes the
> firmware
> name. When that happens, the kernel issues a BUG splat because
> it is unable to overwrite the old name.

Hmm. That seems somewhat problematic, for example if you have multiple
devices that use the same driver but need different firmware?

Not that I really know what's going on, but changing static variables
based on runtime seems like it could cause issues in such cases.

johannes
