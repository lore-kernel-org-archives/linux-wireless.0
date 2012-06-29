Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:60681 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab2F2PEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 11:04:46 -0400
Message-ID: <4FEDC3F0.1000201@net.t-labs.tu-berlin.de> (sfid-20120629_170450_726652_83D54499)
Date: Fri, 29 Jun 2012 11:04:16 -0400
From: thomas <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	brcm80211-dev-list@broadcom.com, pieterpg@broadcom.com,
	gregkh@suse.de, frankyl@broadcom.com, arend@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com, linville@tuxdriver.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling as
 it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120629_145655_517679_6EED29D4) <1340975210.4472.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340975210.4472.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:

> On Fri, 2012-06-29 at 05:56 -0700, Thomas Huehn wrote:
>> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
>> changes the usage of the structure info->control.sta, as it is going to be
>> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
>> order to add transmission power control (TPC) to the mac80211 subsystem.
>>
>> Suggested-by: Felix Fietkau <nbd@openwrt.org>
>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>> ---
>> Change sequence of overwriting data. Thx to Johannes.
> 
> 
>> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>>  			u8 plcp0, plcp3, is40, sgi;
>>  			struct ieee80211_sta *sta;
>>  
>> -			sta = tx_info->control.sta;
>> +			sta = tx_info->rate_driver_data[0];
> 
> Are you sure it actually works now?


>From locking at the code, sta is never used after it gets overridden.
The brcmsmac driver does not use the vif pointer at all. I asked Felix
to double check as I do not have a Broadcom device over here.

Bye Thomas
