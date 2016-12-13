Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34016 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932705AbcLMWLV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 17:11:21 -0500
Date: Tue, 13 Dec 2016 15:05:45 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        justin@kuvee.com
Subject: Re: [Patch] NFC: trf7970a:
Message-ID: <20161213220545.GA29317@animalcreek.com> (sfid-20161213_231138_955682_937DED62)
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
 <20160422000119.GA21754@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160422000119.GA21754@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 21, 2016 at 05:01:19PM -0700, Mark Greer wrote:
> On Mon, Apr 18, 2016 at 03:48:37PM -0400, Geoff Lansberry wrote:
> 
> Hi Geoff.
> 
> > The current version of the trf7970a driver is missing support for several features that we needed to operate a custom board. 
> > We feel that these features will be useful to others as well, and we want to share them.
> > 
> > 1: Support for using a gpio as Slave-Select. Our processor has several devices on the spi bus, and we ran out of ss lines.  This patch gives TRF7970A the ability to
> >  drive the ss line of the chip from a gpio that is defined in the device tree.
> > 
> > 2. When reviewing problems we were having in our implementation with TI support staff, they recommended that during initialization, address 0x18 should be written to zero.  This patch adds that change
> > 
> > 3. This existing version of the driver assumes that the crystal driving the trf7970a is 13.56 MHz, because there are several places in the driver code where the rel
> > ated register is re-written, there is clean way to change to 27.12 MHz.  This patch adds a device tree option for 27 MHz and properly or's in changes in locations w
> > here the register is changed.
> > 
> > 4. the existing version of the driver assumes that 3.3 volt io is used. The trf7970a has a special register where you can configure it for 1.8 volt io.  This patch
> > adds a device tree option to select that this setting should be made.
> > 
> >  [PATCH 1/4] NFC: trf7970a: Add support for gpio as SS
> >  [PATCH 2/4] NFC: trf7970a: add TI recommended write of zero to
> >  [PATCH 3/4] NFC: trf7970a: add device tree option for 27MHz clock
> >  [PATCH 4/4] NFC: trf7970a: Add device tree option of 1.8 Volt IO
> 
> I'm on vacation this week but will be back next week.  I'll take a
> look once I'm back.
> 
> In the meantime, for emails sent to public (techie) list always keep
> the lines less than 80 characters and always bottom-post (i.e., put
> your text *underneath* the text that you are responding to).  Also,
> when you change one or more patches in a series, re-submit the entire
> series with the version number incremented (.e.g., v2, v3, ...) even
> when you change only one of them.  It is a easier for others to know
> what the latest versions are that way.

Hi Geoff.

I know its been a ridiculously long time since I said I would look at
your patches but I have time now.  Do you have an updated version of
your patch series?

Mark
--
