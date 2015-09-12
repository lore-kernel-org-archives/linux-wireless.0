Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:50620 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbbILQWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 12:22:38 -0400
Received: from localhost (unknown [192.168.200.7])
	by max.feld.cvut.cz (Postfix) with ESMTP id 7E86D19F46FF
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 18:22:36 +0200 (CEST)
Received: from max.feld.cvut.cz ([192.168.200.1])
	by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10044)
	with ESMTP id CONWaiWtkBDI for <linux-wireless@vger.kernel.org>;
	Sat, 12 Sep 2015 18:22:34 +0200 (CEST)
Received: from imap.feld.cvut.cz (imap.feld.cvut.cz [147.32.192.34])
	by max.feld.cvut.cz (Postfix) with ESMTP id 9D76619F32FF
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 18:22:34 +0200 (CEST)
Received: by lagj9 with SMTP id j9so65106191lag.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 09:22:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F033EE.7030605@openwrt.org>
References: <1441803324-4503-1-git-send-email-kaisrja1@fel.cvut.cz>
	<55F033EE.7030605@openwrt.org>
Date: Sat, 12 Sep 2015 18:22:33 +0200
Message-ID: <CAPnxhu4WigfkUUvhnb8mj5TezM86twW+e=2+BTyYNnYY8OkS8Q@mail.gmail.com> (sfid-20150912_182241_777381_9DEAF5A6)
Subject: Re: [PATCH] ath9k: Add support for OCB mode
From: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, linux-wireless@vger.kernel.org,
	bernd.lehmann@volkswagen.de, jan-niklas.meier@volkswagen.de,
	s.sander@nordsys.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix,

Thank you for the thorough review!
I redesigned this patch based on your idea and it looks good.
I am going to make some additional tests and I'll send new patch.

2015-09-09 15:28 GMT+02:00 Felix Fietkau <nbd@openwrt.org>:
> On 2015-09-09 14:55, Jan Kaisrlik wrote:
>> The patch adds support for "outside the context of a BSS"(OCB) mode
>> to ath9k driver and extends debugfs files by OCB ralated information.
>>
>> This patch was tested on AR9380-AL1A cards.
>>
>> Signed-off-by: Jan Kaisrlik <kaisrja1@fel.cvut.cz>
>> Cc: Michal Sojka <sojkam1@fel.cvut.cz>
>> ---
>>  drivers/net/wireless/ath/ath9k/ani.c          |  1 +
>>  drivers/net/wireless/ath/ath9k/ath9k.h        |  1 +
>>  drivers/net/wireless/ath/ath9k/debug.c        |  4 ++--
>>  drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
>>  drivers/net/wireless/ath/ath9k/hw.c           |  1 +
>>  drivers/net/wireless/ath/ath9k/init.c         |  3 ++-
>>  drivers/net/wireless/ath/ath9k/main.c         | 11 +++++++++--
>>  drivers/net/wireless/ath/ath9k/recv.c         |  2 +-
>>  drivers/net/wireless/ath/debug.c              |  2 ++
>>  9 files changed, 21 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
>> index 25e45e4..0ec2c0b 100644
>> --- a/drivers/net/wireless/ath/ath9k/ani.c
>> +++ b/drivers/net/wireless/ath/ath9k/ani.c
>> @@ -342,6 +342,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
>>
>>       if (is_scanning ||
>>           (ah->opmode != NL80211_IFTYPE_STATION &&
>> +          ah->opmode != NL80211_IFTYPE_OCB &&
>>            ah->opmode != NL80211_IFTYPE_ADHOC)) {
>>               /*
>>                * If we're scanning or in AP mode, the defaults (ini)
> I don't think OCB should be treated like STA/Ad-Hoc for ANI purposes.
> In fact, I think most places inside ath9k_hw should treat OCB the same
> as AP - maybe even by leaving ah->opmode at NL80211_IFTYPE_AP for OCB.
>
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 1dd0339..2144362 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -1234,6 +1234,7 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
>>
>>       ENABLE_REG_RMW_BUFFER(ah);
>>       switch (opmode) {
>> +     case NL80211_IFTYPE_OCB:
>>       case NL80211_IFTYPE_ADHOC:
>>               if (!AR_SREV_9340_13(ah)) {
>>                       set |= AR_STA_ID1_ADHOC;
> Why treat OCB like Ad-hoc for STA_ID1?
>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index c27143b..f121ec0 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>
>> @@ -1122,7 +1127,8 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
>>       ath9k_hw_setopmode(ah);
>>
>>       ctx->switch_after_beacon = false;
>> -     if ((iter_data.nstations + iter_data.nadhocs + iter_data.nmeshes) > 0)
>> +     if ((iter_data.nstations + iter_data.nadhocs +
>> +          iter_data.nmeshes + iter_data.nocbs) > 0)
>>               ah->imask |= ATH9K_INT_TSFOOR;
>>       else {
>>               ah->imask &= ~ATH9K_INT_TSFOOR;
> Enabling the TSFOOR interrupt for OCB seems completely wrong to me. If I
> understand this mode correctly, there are no beacons, hence no TSF
> synchronization.
>
> - Felix
