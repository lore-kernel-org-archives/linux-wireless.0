Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4793 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab3HUTBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 15:01:07 -0400
Message-ID: <52150E66.4090507@broadcom.com> (sfid-20130821_210111_014628_A9AE9FDB)
Date: Wed, 21 Aug 2013 21:00:54 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Maximilian Engelhardt" <maxi@daemonizer.de>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT 00/13] brcmsmac: bcm4313 iPA related patches
References: <1376424220-10765-1-git-send-email-arend@broadcom.com>
 <7288564.kdgq91zD8T@eisbaer>
In-Reply-To: <7288564.kdgq91zD8T@eisbaer>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/13 18:17, Maximilian Engelhardt wrote:
> On Tuesday 13 August 2013 22:03:27 Arend van Spriel wrote:
>> This series replaces the patch "[PATCH 12/12] brcmsmac: support 4313iPA"
>> with Message-ID:<1376130450-29746-13-git-send-email-arend@broadcom.com>.
>>
>> It has been split up into individual patches. Please test this series
>> especially if you had issues with the original commit b6fc28a that was
>> reverted.
>>
>> Cc: Jonas Gorski<jogo@openwrt.org>
>> Cc: David Herrmann<dh.herrmann@gmail.com>
>> Cc: Maximilian Engelhardt<maxi@daemonizer.de>
>> Cc: David Costa<david@zarel.net>
>>
>> Arend van Spriel (13):
>>    brcmsmac: cosmetic change in phy_lcn.c
>>    brcmsmac: change pa_gain for bcm4313 iPA
>>    brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
>>    brcmsmac: add switch control table for BCM4313 iPA BT-combo cards
>>    brcmsmac: add debug info message providing phy and radio info
>>    brcmsmac: update transmit gain table for lcn phy
>>    brcmsmac: change lcnphy receive i/q calibration routine
>>    brcmsmac: fix TSSI idle estimation
>>    brcmsmac: avoid calling set_txpwr_by_index() twice
>>    brcmsmac: rework switch control table init including iPA BT-combo
>>    brcmsmac: correct phy registers for TSSI-based power control
>>    brcmsmac: reinitialize TSSI power control upon channel switch
>>    brcmsmac: add support for BCM4313 iPA variant
>>
>>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
>>   .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  397
>> +++++++++++-------- .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |
>> 405 +++++++++++--------- .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
>> |    1 +
>>   4 files changed, 475 insertions(+), 332 deletions(-)
>
> Hello Arend,
>
> I finally had some time to test your patches.
>
> On my hardware I couldn't find any regressions with these patches. I also
> verified that the reception problems I had with my card are fixed by these
> patches.
>
> I did test the patches on top of 3.10.5 as they did apply without any
> problems.

Appreciated. I did send the patches for wireless-next already, ie. for 
v3.12 kernel. Good to know that they apply to 3.10 as is.

Regards,
Arend

