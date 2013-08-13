Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53818 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab3HMUJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 16:09:46 -0400
Received: by mail-ie0-f170.google.com with SMTP id e14so11382430iej.15
        for <linux-wireless@vger.kernel.org>; Tue, 13 Aug 2013 13:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1376424220-10765-1-git-send-email-arend@broadcom.com>
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
Date: Tue, 13 Aug 2013 22:09:45 +0200
Message-ID: <CANq1E4TO8radaMFoLjiwhSq2JAFqcLm8UMQvaq9oJRHiWz=60w@mail.gmail.com> (sfid-20130813_220949_384844_DED8EC3F)
Subject: Re: [RFT 00/13] brcmsmac: bcm4313 iPA related patches
From: David Herrmann <dh.herrmann@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jonas Gorski <jogo@openwrt.org>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	David Costa <david@zarel.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Aug 13, 2013 at 10:03 PM, Arend van Spriel <arend@broadcom.com> wrote:
> This series replaces the patch "[PATCH 12/12] brcmsmac: support 4313iPA"
> with Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com>.
>
> It has been split up into individual patches. Please test this series
> especially if you had issues with the original commit b6fc28a that was
> reverted.
>
> Cc: Jonas Gorski <jogo@openwrt.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Maximilian Engelhardt <maxi@daemonizer.de>
> Cc: David Costa <david@zarel.net>

Is this available in a public branch that I can merge? And what should
be used as base? 3.11-rc5? linux-next?

Cheers
David

> Arend van Spriel (13):
>   brcmsmac: cosmetic change in phy_lcn.c
>   brcmsmac: change pa_gain for bcm4313 iPA
>   brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
>   brcmsmac: add switch control table for BCM4313 iPA BT-combo cards
>   brcmsmac: add debug info message providing phy and radio info
>   brcmsmac: update transmit gain table for lcn phy
>   brcmsmac: change lcnphy receive i/q calibration routine
>   brcmsmac: fix TSSI idle estimation
>   brcmsmac: avoid calling set_txpwr_by_index() twice
>   brcmsmac: rework switch control table init including iPA BT-combo
>   brcmsmac: correct phy registers for TSSI-based power control
>   brcmsmac: reinitialize TSSI power control upon channel switch
>   brcmsmac: add support for BCM4313 iPA variant
>
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  397 +++++++++++--------
>  .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  405 +++++++++++---------
>  .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |    1 +
>  4 files changed, 475 insertions(+), 332 deletions(-)
>
> --
> 1.7.10.4
>
>
