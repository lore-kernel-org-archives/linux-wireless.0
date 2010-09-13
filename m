Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44847 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0IMCfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 22:35:20 -0400
Received: by qwh6 with SMTP id 6so3123060qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Sep 2010 19:35:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009131017.35762.br1@einfach.org>
References: <20100908070427.11255.17659.stgit@tt-desk>
	<20100908070459.11255.52256.stgit@tt-desk>
	<20100911172752.GH20385@hash.localnet>
	<201009131017.35762.br1@einfach.org>
Date: Sun, 12 Sep 2010 22:35:19 -0400
Message-ID: <AANLkTik0Ph67jN3od3NAcwwLrQXnpyEqsJU5rfNAJWAJ@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Use common crypt capabilities flags
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: bob@bobcopeland.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 12, 2010 at 9:17 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Sun September 12 2010 02:27:52 you wrote:
>> On Wed, Sep 08, 2010 at 04:04:59PM +0900, Bruno Randolf wrote:
>> > Replace ah_aes_support and ah_combined_mic with common ath_crypt_caps
>> > ATH_CRYPT_CAP_CIPHER_AESCCM and ATH_CRYPT_CAP_MIC_COMBINED.
>> >
>> > Signed-off-by: Bruno Randolf <br1@einfach.org>
>> >
>> > --- a/drivers/net/wireless/ath/ath5k/base.c
>> > +++ b/drivers/net/wireless/ath/ath5k/base.c
>> > @@ -3298,7 +3298,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum
>> > set_key_cmd cmd,
>> >
>> >     case WLAN_CIPHER_SUITE_TKIP:
>> >             break;
>> >
>> >     case WLAN_CIPHER_SUITE_CCMP:
>> > -           if (sc->ah->ah_aes_support)
>> > +           if (common->crypt_caps & ATH_CRYPT_CAP_CIPHER_AESCCM)
>> >
>> >                     break;
>> >
>> >             return -EOPNOTSUPP;
>>
>> This could be done by the common code too, right?
>
> yes... ath9k doesn't do this, but i left the old code because i wasn't sure if
> we need it or not. can we sort this out in a following patch?

Yeah, I guess only certain ath5k chipsets do CCMP while all
ath9k ones do..  for sure, follow-up patches are fine for
my minor comments, none of them affect functionality.

-- 
Bob Copeland %% www.bobcopeland.com
