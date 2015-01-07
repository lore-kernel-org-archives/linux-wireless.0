Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58574 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbbAGOjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:39:44 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so1725126wid.17
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2015 06:39:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420639929.3407.18.camel@sipsolutions.net>
References: <1420566070-25336-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1420639929.3407.18.camel@sipsolutions.net>
Date: Wed, 7 Jan 2015 15:39:43 +0100
Message-ID: <CAA2SeN+KZqXcBpOuW=J_vyznOn03NceuH8RDdmcB30-7-9xyQw@mail.gmail.com> (sfid-20150107_153957_389122_A1022B74)
Subject: Re: [PATCHv4] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2015-01-06 at 18:41 +0100, Lorenzo Bianconi wrote:
>
>> + * @txpower_type: TX power adjustment used to control per packet Transmit
>> + *   Power Control (TPC) in lower driver for the current vif. In particular
>> + *   TPC is enabled if value passed in %txpower_type is
>> + *   NL80211_TX_POWER_AUTOMATIC (no limit from userspace) or
>> + *   NL80211_TX_POWER_LIMITED (allow using less than specified from
>> + *   userspace), whereas TPC is disabled if %txpower_type is set to
>> + *   NL80211_TX_POWER_FIXED (use value configured from userspace)
>
> I was going to apply this, but now I have second thoughts.
>
> Does it really make sense to ask the driver to do "automatic"? After
> all, there are other limits in mac80211 (like 11h from the AP and
> regulatory) that need to be considered. So perhaps if userspace says
> "automatic", the driver should still see only "limited"?
>

IMHO "automatic" means lower driver has to take into account just
channel/regulatory constraints (that is ath9k behavior), since the
user/mac80211 does not cap TX power, whereas "limited" means the
user/mac80211 has set a limit for emitted power, so that configuration
has to be taken into account. Maybe we have just left to set
txpower_type to NL80211_TX_POWER_LIMITED for the current vif when TX
power is limited by the AP (802.11h). What do you think? Are there any
other cases when TX power is limited by mac80211 (excluding 802.11h
and when TX power is limited by the user)?

> johannes
>

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
