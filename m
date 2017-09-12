Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45714 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdILUE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 16:04:27 -0400
Message-ID: <1505246657.1974.11.camel@sipsolutions.net> (sfid-20170912_220440_737165_99634FF7)
Subject: Re: iwlwifi firmware load broken in current -git
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Axboe <axboe@kernel.dk>, Luca Coelho <luca@coelho.fi>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        srinath.mannam@broadcom.com, Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Sep 2017 22:04:17 +0200
In-Reply-To: <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk> (sfid-20170912_214331_920708_6F6B2A72)
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
         <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
         <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
         (sfid-20170912_214331_920708_6F6B2A72)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-12 at 13:43 -0600, Jens Axboe wrote:

> CC'ing the guilty part and Bjorn. I'm assuming it's the
> pci_is_enabled() check, since the rest of the patch shouldn't have
> functional changes.

and pci_enable_bridge() already checks if it's already enabled, but
still enables mastering in that case if it isn't:

static void pci_enable_bridge(struct pci_dev *dev)
{
[...]
        if (pci_is_enabled(dev)) {
                if (!dev->is_busmaster)
                        pci_set_master(dev);
                return;
        }

so I guess due to the new check we end up with mastering disabled, and
thus the firmware can't load since that's a DMA thing?

johannes
