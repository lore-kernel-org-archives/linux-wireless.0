Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1339 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab3E2Qro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 12:47:44 -0400
Message-ID: <51A63120.7020102@broadcom.com> (sfid-20130529_184748_292370_CC2F5759)
Date: Wed, 29 May 2013 18:47:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH for 3.10 00/16] brcmfmac: firmware-signalling fixes
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1369845546-31950-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2013 06:38 PM, Arend van Spriel wrote:
> This is a somewhat large series and reading the message of the announcement
> of v3.10-rc3 I think it is good to give our story up front. Firmware-signalling
> is a new feature merged in for 3.10, which was a major overhaul of the transmit
> path in brcmfmac. During and after the merge window we still have some blanks
> in our test coverage and further testing revealed issues with P2P, TDLS, and
> power-saving clients in AP mode. These issues have been fixed in this series.

forgot: last but not least inconsistent firmware behaviour for different 
devices.

Regards,
Arend

> As said this series is intended for 3.10 and applies to the master branch of
> the wireless repository.
>
> Arend van Spriel (6):
>    brcmfmac: allow firmware-signal tlv to be longer than specified
>    brcmfmac: remove fifo bitfield from brcmf_skbuff_cb::if_flags
>    brcmfmac: rework credit pickup to assure consistent handling
>    brcmfmac: explicitly indicate sk_buff is sent upon request credit
>    brcmfmac: reducing debug logging in firmware-signalling code
>    brcmfmac: Sent TIM information in case of data available.
>
> Hante Meuleman (10):
>    brcmfmac: Take bus flowcontrol at credit mgmt into account.
>    brcmfmac: On bus flow control use fw signalling or netif.
>    brcmfmac: For FW signalling it is necessary to track gen bit.
>    brcmfmac: Correct creditmap when credit borrowing is active.
>    brcmfmac: Find correct MAC descriptor in case of TDLS.
>    brcmfmac: fix invalid ifp lookup in firmware-signalling
>    brcmfmac: Accept only first creditmap event.
>    brcmfmac: Signalling header push and pull on logic places.
>    brcmfmac: Fix endless loop when brcmf_fws_commit_skb fails.
>    brcmfmac: Simplify counting transit count.
>
>   drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +
>   .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   21 +-
>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  639 ++++++++++----------
>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
>   drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    8 +
>   6 files changed, 340 insertions(+), 333 deletions(-)
>


