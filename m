Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1662 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2KARno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 13:43:44 -0400
Message-ID: <5092B4C0.7060701@broadcom.com> (sfid-20121101_184350_390509_5DDECF6F)
Date: Thu, 1 Nov 2012 18:43:28 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 01/18] brcmsmac: Rework tx code to avoid internal
 buffering of packets
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <1351261413-20821-2-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1351261413-20821-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2012 04:23 PM, Seth Forshee wrote:
> The brcmsmac internal tx buffering is problematic for a number of
> reasons. The amount of buffering is excessive (228 packets in addition
> to the 256 slots in each DMA ring), frames may be dropped due to a lack
> of flow control, and the structure of the queues complicates the
> otherwise straightforward mapping of mac80211 queues to device fifos.
>
> This patch reworks the transmit code path to eliminate the internal
> buffering. Frames are immediately handed off to the DMA support rather
> than passing through an intermediate queue. ieee80211_(stop|wake)_queue()
> are used for flow control to stop receiving frames when a DMA tx ring is
> full.
>
> To handle aggregation the concept of AMPDU sessions is added to the
> driver. The AMPDU session allows MPDUs to be temporarily queued by the
> DMA code until either a full AMPDU has been collected or circumstances
> dictate that transmission should start with a partial AMPDU. The use of
> a queue ensures that the tx headers are fully initialized before the
> buffers are synced for DMA, and it allows non-aggregate frames to be
> immediately placed in the tx ring so that more frames can be collected
> for aggregation.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |  666 ++++++++++-------------
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.h |   29 +-
>   drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  182 ++++++-
>   drivers/net/wireless/brcm80211/brcmsmac/dma.h   |    9 +-
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  |  514 +++++------------
>   drivers/net/wireless/brcm80211/brcmsmac/main.h  |   39 +-
>   drivers/net/wireless/brcm80211/brcmsmac/types.h |    1 -
>   7 files changed, 628 insertions(+), 812 deletions(-)

Hi Seth,

The idea behind the change is a good move. However, this change is quite 
a overhaul especially for ampdu code. This makes it pretty hard to 
review. At least against the previous implementation. So we still need 
some time to chew on this one. We have been testing it and it looks good 
there.

Could you somehow split this change into smaller steps?

Gr. Avs

