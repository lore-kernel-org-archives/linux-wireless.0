Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39147 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbAFQ2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 11:28:41 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so5689632wiv.11
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 08:28:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420540894.1966.13.camel@sipsolutions.net>
References: <1419412868-28938-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1420540894.1966.13.camel@sipsolutions.net>
Date: Tue, 6 Jan 2015 17:28:40 +0100
Message-ID: <CAA2SeNK3ak7OPP2uqtSrzqFQTf1PMvjP_d14RjGmU2VFNfDhWw@mail.gmail.com> (sfid-20150106_172844_872288_6E3D3091)
Subject: Re: [PATCHv3] mac80211: enable TPC through mac80211 stack
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 2014-12-24 at 10:21 +0100, Lorenzo Bianconi wrote:
>> -     list_for_each_entry(sdata, &local->interfaces, list)
>> +     list_for_each_entry(sdata, &local->interfaces, list) {
>>               sdata->user_power_level = local->user_power_level;
>> +             if (!update_tpc && type != sdata->vif.bss_conf.txpower_type)
>> +                     update_tpc = true;
>
> Why bother checking - if it's already true then setting it to true won't
> matter, and IMHO makes the code easier to read.
>
> I also think "update_tpc" is a bad name - transmit power control is the
> actual usage here, but you really mean "update_txp_type" or so.
>

ack. V4 on the way

> johannes
>

Best regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
