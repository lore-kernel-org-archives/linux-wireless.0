Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33370 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161183AbcFMUZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 16:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <575F09D7.6030505@broadcom.com>
References: <1464219876-13776-1-git-send-email-zajec5@gmail.com>
 <5759C09F.7020704@broadcom.com> <575F09D7.6030505@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 13 Jun 2016 22:25:05 +0200
Message-ID: <CACna6rwJUFzBbggtcmz_LYLRe-9TN1LeKtsGDuavLhAkWD90nQ@mail.gmail.com> (sfid-20160613_222532_720603_765B225D)
Subject: Re: [PATCH] brcmfmac: rework function picking free BSS index
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 June 2016 at 21:30, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> On 09-06-16 21:16, Arend van Spriel wrote:
>> On 26-05-16 01:44, Rafał Miłecki wrote:
>>> The old implementation was overcomplicated and slightly bugged in some
>>> corner cases.
>>>
>
> [...]
>
>>> New code is simpler, placed in file where it's really used, handles
>>> running out of free BSS-es and allows using 4 interfaces at the same
>>> time. It also looks for the first free BSS instead of one after the last
>>> in use. It works well with current driver (which doesn't allow deleting
>>> interfaces) and should be future proof (if we ever allow deleting).
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 17 ++++++++++++++-
>>>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 ----------------------
>>>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  1 -
>>>  3 files changed, 16 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> index 3d09d23..d00eef8 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> @@ -541,6 +541,21 @@ brcmf_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
>>>                                              ADDR_INDIRECT);
>>>  }
>>>
>>> +static int brcmf_get_first_free_bsscfgidx(struct brcmf_pub *drvr)
>>> +{
>>> +    int bsscfgidx;
>>> +
>>> +    for (bsscfgidx = 0; bsscfgidx < BRCMF_MAX_IFS; bsscfgidx++) {
>>> +            /* bsscfgidx 1 is reserved for legacy P2P */
>>
>> Hi Rafał,
>>
>> A bit late as the patch is already applied, but this reserved index is
>> no longer needed as we removed all trickery that was build on the
>> assumption that the P2P_DEVICE interface was always in bsscfgidx 1.
>> Hence this could be removed.
>
> I tested STA on bsscfgidx=0, AP on bsscfgidx=1, and P2P_DEV on
> bsscfgidx=2. P2P discovery on P2P_DEV interface works as expected so we
> can indeed drop the 'bsscfgidx 1 is reserved' statement. I want to
> verify on an older device before creating a patch.

Thanks for taking look at this.

-- 
Rafał
