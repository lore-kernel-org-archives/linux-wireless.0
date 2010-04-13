Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42007 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab0DMVmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 17:42:33 -0400
Received: by pwj9 with SMTP id 9so5830492pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 14:42:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BC4D0DA.2070109@openwrt.org>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	<1270754858-26266-13-git-send-email-lrodriguez@atheros.com>
	<20100413195408.GC6722@tuxdriver.com> <4BC4D0DA.2070109@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 13 Apr 2010 14:42:13 -0700
Message-ID: <m2y43e72e891004131442jab214ed3hdf2cbd59b8910d58@mail.gmail.com>
Subject: Re: [PATCH 012/102] ath9k_hw: add a private callback for PLL control
	computation
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 13, 2010 at 1:15 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-04-13 9:54 PM, John W. Linville wrote:
>> On Thu, Apr 08, 2010 at 03:26:08PM -0400, Luis R. Rodriguez wrote:
>>> The PLL control computation used to program the AR_RTC_PLL_CONTROL
>>> register varies between our harware so just add a private callback for it.
>>> AR9003 will use its own callback.
>>>
>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/ar5008_phy.c |   55 +++++++++++++++++++++++
>>>  drivers/net/wireless/ath/ath9k/ar9002_phy.c |   31 +++++++++++++
>>>  drivers/net/wireless/ath/ath9k/hw.c         |   64 +++------------------------
>>>  drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
>>>  4 files changed, 97 insertions(+), 57 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>>> index 4459d63..31ecea8 100644
>>> --- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>>> +++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
>>> @@ -961,6 +961,54 @@ static void ar5008_set_diversity(struct ath_hw *ah, bool value)
>>
>> <snip>
>>
>> drivers/net/wireless/ath/ath9k/ar5008_phy.c doesn't seem to exist...?
> Luis' git version creates patches that mark renames in metadata, so they
> probably won't apply when using 'patch', only with 'git apply'...
> Patch 009 renames phy.c to ar5008_phy.c

Right, so this is part of the -M on git format-patch, we do this to
keep the patch diff stat to 0 so that its clear no changes were
actually made to the file.

  Luis
