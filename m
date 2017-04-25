Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59139 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S979462AbdDYA0E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 20:26:04 -0400
Date: Mon, 24 Apr 2017 17:19:17 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/7] NFC: trf7970a: Fixups & convert to desc-based GPIO
Message-ID: <20170425001917.GA14396@animalcreek.com> (sfid-20170425_022608_813130_8E24B8CC)
References: <20170120191745.29255-1-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170120191745.29255-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[-CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org> and
 Aloisio Almeida Jr <aloisio.almeida@openbossa.org>]
[+CC: linux-wireless]

On Fri, Jan 20, 2017 at 12:17:38PM -0700, Mark Greer wrote:
> These trf7970a driver patches do the following things:
>  - a couple minor fixups
>  - allow EN2 to not be managed by the driver (e.g., when its tied low by
>    hardware
>  - convert the driver to use the descriptor-based GPIO interface
>  - remove support for 'vin-voltage-override' DT property
>  - change the DTS example to indicate that EN and EN2 are active high GPIOs
>  - add Mark Greer as the maintainer of the trf7970a driver
> 
> Based on k.o. 44b4b46 (Merge tag 'armsoc-fixes' of
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
> 
> v2->v3:
>  - Removed "[PATCH v2 5/7] NFC: trf7970a: Clean up coding style issues"
>    because it will make merging patches from Geoff Lansberry and others
>    hard to apply.  I will resubmit once those patches have been merged
>    or rejected.
>  - Added a patch to remove 'vin-voltage-override' DT property support as
>    proper DT regulator set up makes it unnecessary.
> 
> v1->v2:
>  - Commit description fixups only; no functional changes.
> 
> Mark Greer (7):
>   NFC: trf7970a: Don't de-assert EN2 unless it was asserted
>   NFC: trf7970a: Don't manage EN2 when not specified in DT
>   NFC: trf7970a: Convert to descriptor based GPIO interface
>   NFC: trf7970a: Remove useless comment
>   NFC: trf7970a: Remove support for 'vin-voltage-override' DT property
>   NFC: trf7970a: Enable pins are active high not active low
>   MAINTAINERS: NFC: trf7970a: Add Mark Greer as maintainer
> 
>  .../devicetree/bindings/net/nfc/trf7970a.txt       |  6 +-
>  MAINTAINERS                                        |  7 ++
>  drivers/nfc/Kconfig                                |  2 +-
>  drivers/nfc/trf7970a.c                             | 75 +++++++++-------------
>  4 files changed, 40 insertions(+), 50 deletions(-)


I've already mentioned this to Samuel privately but for everyone's sake,
I will respin this series because some patches that cause conflicts have
been accepted.  I will also add some patches that I have made in the
interim.  I apologize for the churn.

Mark
--
