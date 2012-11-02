Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2KBH2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 03:28:36 -0400
Date: Fri, 2 Nov 2012 08:28:32 +0100
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 01/18] brcmsmac: Rework tx code to avoid internal
 buffering of packets
Message-ID: <20121102072832.GA19430@ubuntu-mba51> (sfid-20121102_082850_187599_D22BD1D2)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <1351261413-20821-2-git-send-email-seth.forshee@canonical.com>
 <5092B4C0.7060701@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5092B4C0.7060701@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 01, 2012 at 06:43:28PM +0100, Arend van Spriel wrote:
> On 10/26/2012 04:23 PM, Seth Forshee wrote:
> >The brcmsmac internal tx buffering is problematic for a number of
> >reasons. The amount of buffering is excessive (228 packets in addition
> >to the 256 slots in each DMA ring), frames may be dropped due to a lack
> >of flow control, and the structure of the queues complicates the
> >otherwise straightforward mapping of mac80211 queues to device fifos.
> >
> >This patch reworks the transmit code path to eliminate the internal
> >buffering. Frames are immediately handed off to the DMA support rather
> >than passing through an intermediate queue. ieee80211_(stop|wake)_queue()
> >are used for flow control to stop receiving frames when a DMA tx ring is
> >full.
> >
> >To handle aggregation the concept of AMPDU sessions is added to the
> >driver. The AMPDU session allows MPDUs to be temporarily queued by the
> >DMA code until either a full AMPDU has been collected or circumstances
> >dictate that transmission should start with a partial AMPDU. The use of
> >a queue ensures that the tx headers are fully initialized before the
> >buffers are synced for DMA, and it allows non-aggregate frames to be
> >immediately placed in the tx ring so that more frames can be collected
> >for aggregation.
> >
> >Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >---
> >  drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |  666 ++++++++++-------------
> >  drivers/net/wireless/brcm80211/brcmsmac/ampdu.h |   29 +-
> >  drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  182 ++++++-
> >  drivers/net/wireless/brcm80211/brcmsmac/dma.h   |    9 +-
> >  drivers/net/wireless/brcm80211/brcmsmac/main.c  |  514 +++++------------
> >  drivers/net/wireless/brcm80211/brcmsmac/main.h  |   39 +-
> >  drivers/net/wireless/brcm80211/brcmsmac/types.h |    1 -
> >  7 files changed, 628 insertions(+), 812 deletions(-)
> 
> Hi Seth,
> 
> The idea behind the change is a good move. However, this change is
> quite a overhaul especially for ampdu code. This makes it pretty
> hard to review. At least against the previous implementation. So we
> still need some time to chew on this one. We have been testing it
> and it looks good there.

Great!

The AMPDU changes do look significant, but in large part they're just
rearranging the code.

> Could you somehow split this change into smaller steps?

I'd given a little thought to breaking it up before I sent the patches,
but for the bulk of the changes it's a little challenging to do so
without making some of the commits regress (e.g. break AMPDU in one
commit then fix it in the next one). I'll take a closer look while I'm
travelling and see if I can work something out.

Thanks,
Seth
