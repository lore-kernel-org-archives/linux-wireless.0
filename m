Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36318 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932333AbcJZUqw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 16:46:52 -0400
Date: Wed, 26 Oct 2016 13:46:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Rajat Jain <rajatja@google.com>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh@kernel.org>, rajatxjain@gmail.com
Subject: Re: [PATCH v6] mwifiex: parse device tree node for PCIe
Message-ID: <20161026204648.GD3989@dtor-ws> (sfid-20161026_224656_597961_E626DDF7)
References: <1477070156-109965-1-git-send-email-rajatja@google.com>
 <1477084869-15612-1-git-send-email-rajatja@google.com>
 <20161026201735.GA10192@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026201735.GA10192@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 26, 2016 at 01:17:36PM -0700, Brian Norris wrote:
> Hi Rajat,
> 
> On Fri, Oct 21, 2016 at 02:21:09PM -0700, Rajat Jain wrote:
> > From: Xinming Hu <huxm@marvell.com>
> > 
> > This patch derives device tree node from pcie bus layer framework, and
> > fixes a minor memory leak in mwifiex_pcie_probe() (in failure path).
> > Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> > marvell-8xxx.txt) to accommodate PCIe changes.
> > 
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Rajat Jain <rajatja@google.com>
> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > ---
> > v2: Included vendor and product IDs in compatible strings for PCIe
> > chipsets(Rob Herring)
> > v3: Patch is created using -M option so that it will only include diff of
> > original and renamed files(Rob Herring)
> > Resend v3: Resending the patch because I missed to include device tree mailing
> > while sending v3.
> > v4: Fix error handling, also move-on even if no device tree node is present.
> > v5: Update commit log to include memory leak, return -EINVAL instead of -1.
> 
> I've been working on reworking some bugfixes for this driver, and I
> noticed we have some problems w.r.t. memory leaks, and the "memory leak"
> fix is not actually a fix. See below.

Sorry, I just saw this... Why do we need devicetree data for
discoverable bus (PCI)? How does the driver work on systems that do not
use DT? Why do we need them to behave differently?

Thanks.

-- 
Dmitry
