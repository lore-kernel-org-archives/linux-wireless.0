Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53136 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbaGVWRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 18:17:15 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so6814696wiv.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 15:17:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140722212327.GF1299@tuxdriver.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1405859486-31414-10-git-send-email-lorenzo.bianconi83@gmail.com>
	<20140722180254.GE1299@tuxdriver.com>
	<CAA2SeNLqYvtghDPvBFARjEU4MKSMeSoG_2XFVkUtRWnt66LzJQ@mail.gmail.com>
	<20140722212327.GF1299@tuxdriver.com>
Date: Wed, 23 Jul 2014 00:17:14 +0200
Message-ID: <CAA2SeNKX9C96C_tfJdR8h3h-fi8jo=OziTEAXLY6iD5mVHkXmA@mail.gmail.com> (sfid-20140723_001727_089480_9DDBBFFA)
Subject: Re: [PATCH 09/10] ath9k: add ath9k_enable_dynack() method
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Jul 22, 2014 at 09:52:04PM +0200, Lorenzo Bianconi wrote:
>> Hi John,
>>
>> > On Sun, Jul 20, 2014 at 02:31:25PM +0200, Lorenzo Bianconi wrote:
>> >> Add ath9k_enable_dynack() method to enable ack timeout estimation algorithm.
>> >> Moreover disable dynack if the coverage class has been configured
>> >>
>> >> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> >> ---
>> >>  drivers/net/wireless/ath/ath9k/main.c | 34 ++++++++++++++++++++++++++++++++++
>> >>  1 file changed, 34 insertions(+)
>> >>
>> >> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> >> index e6ac8d2..52ca884 100644
>> >> --- a/drivers/net/wireless/ath/ath9k/main.c
>> >> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> >> @@ -1970,6 +1970,14 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
>> >>       mutex_lock(&sc->mutex);
>> >>       ah->coverage_class = coverage_class;
>> >>
>> >> +     if (ah->dynack.enabled) {
>> >> +             u32 rfilt;
>> >> +
>> >> +             ah->dynack.enabled = false;
>> >> +             rfilt = ath_calcrxfilter(sc);
>> >> +             ath9k_hw_setrxfilter(ah, rfilt);
>> >> +     }
>> >> +
>> >>       ath9k_ps_wakeup(sc);
>> >>       ath9k_hw_init_global_settings(ah);
>> >>       ath9k_ps_restore(sc);
>> >> @@ -1977,6 +1985,28 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
>> >>       mutex_unlock(&sc->mutex);
>> >>  }
>> >>
>> >> +#ifdef CONFIG_ATH9K_DYNACK
>> >> +static int ath9k_enable_dynack(struct ieee80211_hw *hw)
>> >> +{
>> >> +     u32 rfilt;
>> >> +     struct ath_softc *sc = hw->priv;
>> >> +     struct ath_hw *ah = sc->sc_ah;
>> >> +
>> >> +     if (config_enabled(CONFIG_ATH9K_TX99))
>> >> +             return -EOPNOTSUPP;
>> >> +
>> >> +     if (!ah->dynack.enabled) {
>> >> +             ath_dynack_reset(ah);
>> >> +
>> >> +             ah->dynack.enabled = true;
>> >> +             rfilt = ath_calcrxfilter(sc);
>> >> +             ath9k_hw_setrxfilter(ah, rfilt);
>> >> +     }
>> >> +
>> >> +     return 0;
>> >> +}
>> >> +#endif
>> >> +
>> >>  static bool ath9k_has_tx_pending(struct ath_softc *sc)
>> >>  {
>> >>       int i, npend = 0;
>> >> @@ -2651,4 +2681,8 @@ struct ieee80211_ops ath9k_ops = {
>> >>  #endif
>> >>       .sw_scan_start      = ath9k_sw_scan_start,
>> >>       .sw_scan_complete   = ath9k_sw_scan_complete,
>> >> +
>> >> +#ifdef CONFIG_ATH9K_DYNACK
>> >> +     .enable_dynack      = ath9k_enable_dynack,
>> >> +#endif
>> >>  };
>> >
>> >   CC      drivers/net/wireless/ath/ath9k/main.o
>> > drivers/net/wireless/ath/ath9k/main.c:2690:2: error: unknown field ‘enable_dynack’ specified in initializer
>> >   .enable_dynack      = ath9k_enable_dynack,
>> >   ^
>> > drivers/net/wireless/ath/ath9k/main.c:2690:2: warning: initialization from incompatible pointer type [enabled by default]
>> > drivers/net/wireless/ath/ath9k/main.c:2690:2: warning: (near initialization for ‘ath9k_ops.get_stats’) [enabled by default]
>> > make[3]: *** [drivers/net/wireless/ath/ath9k/main.o] Error 1
>> > make[2]: *** [drivers/net/wireless/ath/ath9k] Error 2
>> > make[1]: *** [drivers/net/wireless/ath] Error 2
>> > make: *** [drivers/net/wireless/] Error 2
>> >
>> > Missing a header file change?
>> >
>>
>> The function pointer is defined in "configure ack timeout estimation
>> algorithm through mac80211 stack" patchset sent on linux-wireless.
>> Anyway I will send patchset v3 to take Johannes's hint.
>
> Perhaps you should post them all together, or keep this series as
> RFC until the other one gets merged?
>

Ack. First of all I will include Johannes's hints in "configure ack
timeout estimation algorithm through mac80211 stack" in such a way the
function pointer is merged and then I will send a new patchset for
dynack.

Best regards,
Lorenzo

> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
