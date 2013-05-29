Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965341Ab3E2TXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 15:23:18 -0400
Message-ID: <51A65599.5040000@broadcom.com> (sfid-20130529_212322_076217_CE8033F0)
Date: Wed, 29 May 2013 21:23:05 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH for 3.10 00/16] brcmfmac: firmware-signalling fixes
References: <1369845546-31950-1-git-send-email-arend@broadcom.com>
 <20130529184426.GC8770@tuxdriver.com>
In-Reply-To: <20130529184426.GC8770@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2013 08:44 PM, John W. Linville wrote:
> On Wed, May 29, 2013 at 06:38:50PM +0200, Arend van Spriel wrote:
>> This is a somewhat large series and reading the message of the announcement
>> of v3.10-rc3 I think it is good to give our story up front. Firmware-signalling
>> is a new feature merged in for 3.10, which was a major overhaul of the transmit
>> path in brcmfmac. During and after the merge window we still have some blanks
>> in our test coverage and further testing revealed issues with P2P, TDLS, and
>> power-saving clients in AP mode. These issues have been fixed in this series.
>>
>> As said this series is intended for 3.10 and applies to the master branch of
>> the wireless repository.
>>
>> Arend van Spriel (6):
>>    brcmfmac: allow firmware-signal tlv to be longer than specified
>>    brcmfmac: remove fifo bitfield from brcmf_skbuff_cb::if_flags
>>    brcmfmac: rework credit pickup to assure consistent handling
>>    brcmfmac: explicitly indicate sk_buff is sent upon request credit
>>    brcmfmac: reducing debug logging in firmware-signalling code
>>    brcmfmac: Sent TIM information in case of data available.
>>
>> Hante Meuleman (10):
>>    brcmfmac: Take bus flowcontrol at credit mgmt into account.
>>    brcmfmac: On bus flow control use fw signalling or netif.
>>    brcmfmac: For FW signalling it is necessary to track gen bit.
>>    brcmfmac: Correct creditmap when credit borrowing is active.
>>    brcmfmac: Find correct MAC descriptor in case of TDLS.
>>    brcmfmac: fix invalid ifp lookup in firmware-signalling
>>    brcmfmac: Accept only first creditmap event.
>>    brcmfmac: Signalling header push and pull on logic places.
>>    brcmfmac: Fix endless loop when brcmf_fws_commit_skb fails.
>>    brcmfmac: Simplify counting transit count.
>>
>>   drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +
>>   .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   21 +-
>>   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
>>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  639 ++++++++++----------
>>   drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
>>   drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    8 +
>>   6 files changed, 340 insertions(+), 333 deletions(-)
>
> Grr...I'll merge it, and pass your plea on to Dave.  But, there can't
> be any more batches like this for 3.10...

Sorry to make you growl. If there are regressions being reported I 
expect that this was it for 3.10 (from us).

Gr. AvS

(not Growling, but Greeting)

