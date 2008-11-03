Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:64453 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYKCCKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 21:10:30 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2324671rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 18:10:30 -0800 (PST)
Message-ID: <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com> (sfid-20081103_031041_000527_EB368874)
Date: Sun, 2 Nov 2008 21:10:30 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] ath5k: enable RXing beacons
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225676353.13684.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
	 <1225676353.13684.2.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 8:39 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Sun, 2008-11-02 at 16:36 -0800, Luis R. Rodriguez wrote:
>> Prior to this we would rely only on probe responses
>> from the AP to keep associated. We now receive beacons
>> on ath5k. This should fix sporadic disassociations.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> Is this also a candidate for -stable?

Don't think so, see below...

>
>> ---
>>  drivers/net/wireless/ath5k/base.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
>> index f5f46fe..5505f45 100644
>> --- a/drivers/net/wireless/ath5k/base.c
>> +++ b/drivers/net/wireless/ath5k/base.c
>> @@ -2948,6 +2948,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>>                       AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
>>       if (sc->opmode != NL80211_IFTYPE_STATION)
>>               rfilt |= AR5K_RX_FILTER_PROBEREQ;
>> +     if (sc->opmode == NL80211_IFTYPE_STATION)
>> +             rfilt |= AR5K_RX_FILTER_BEACON;
>>       if (sc->opmode != NL80211_IFTYPE_AP &&
>>               sc->opmode != NL80211_IFTYPE_MESH_POINT &&
>>               test_bit(ATH_STAT_PROMISC, sc->status))

Sorry, my fault, this was a direct result of
60c7e22196fb4230b76db1f5fb283e811b8f3fb3 "ath5k: honor
FIF_BCN_PRBRESP_PROMISC."  The problem remains that we have too many
interrupts though if PRBRESP_PROMISC is not set.  IIRC my patch made
ath5k behave same as ath9k.  Any ideas on a proper fix?

-- 
Bob Copeland %% www.bobcopeland.com
