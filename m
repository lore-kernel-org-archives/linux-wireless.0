Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54235 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753191AbdGXPyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 11:54:15 -0400
Date: Mon, 24 Jul 2017 17:54:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: Re: [PATCH v1 4/6] vmbus: Switch to use new generic UUID API
Message-ID: <20170724155413.GB17917@lst.de> (sfid-20170724_175417_707345_690A1973)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-5-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170719182857.73693-5-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 19, 2017 at 09:28:55PM +0300, Andy Shevchenko wrote:
> There are new types and helpers that are supposed to be used in new code.
> 
> As a preparation to get rid of legacy types and API functions do
> the conversion here.

Can you split the uapi changes into a separate patch?

I'd love to kill the guid_le userspace exposure, but I'd also like to
see how current userspace uses them.  Obviously your change is not
a break in the ABI, but it is a break in the API.  I would prefer if
we could not expose it, but I'd like to hear feedback from the consumers
of these UAPI headers - the fields aren't used in kernel space at all,
but userspace might be using it, and we'll need to look into alternatives
for it.
