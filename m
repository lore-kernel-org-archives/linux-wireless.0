Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:17481 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXJaTdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 15:33:50 -0400
Received: by py-out-1112.google.com with SMTP id u77so488261pyb
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 12:33:48 -0700 (PDT)
Message-ID: <43e72e890710311233vc2cce3cs71effa69d8394bc9@mail.gmail.com> (sfid-20071031_193353_089319_F8B7B3F7)
Date: Wed, 31 Oct 2007 15:33:48 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [RFC] ath5k: set rate duration table correctly for non-B channels on ar5212
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <40f31dec0710311230w51aff5a5g98c4f989335d2bda@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1193852696-19589-1-git-send-email-linville@tuxdriver.com>
	 <40f31dec0710311230w51aff5a5g98c4f989335d2bda@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2007/10/31, John W. Linville <linville@tuxdriver.com>:
> > Currently we are passing MODE_ATHEROS_TURBO or MODE_ATHEROS_TURBOG to
> > ath5k_hw_get_rate_table if ah_version is AR5K_AR5212 and the channel
> > passed to ath5k_hw_reset is not a B channel.  This is a problem if
> > for no other reason than we are not registering those channels.
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > This is untested.  Does this look like the right fix?
> >
> > Also, just above the change is the comment "For 802.11a/g Turbo/XR mode
> > (AR5K_MODE_XR here is O.K. for both a/g - OFDM)".  Is this the right
> > comment?
> >
> >  drivers/net/wireless/ath5k/hw.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> > index c8d1fbd..a31443e 100644
> > --- a/drivers/net/wireless/ath5k/hw.c
> > +++ b/drivers/net/wireless/ath5k/hw.c
> > @@ -695,8 +695,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
> >
> >                                 /* Get rate table for this operation mode */
> >                                 rt = ath5k_hw_get_rate_table(ah,
> > -                                   channel->val & CHANNEL_TURBO ?
> > -                                   MODE_ATHEROS_TURBO : MODE_ATHEROS_TURBOG);
> > +                                               MODE_IEEE80211G);
> >                                 if (!rt)
> >                                         return -EINVAL;
> >
> > --
> > 1.5.3.3
> >
> >
>
> On madwif-old-openhal we had MODE_XR which is a special (proprietary)
> mode and returns a special rate table, during porting this bit was
> misunderstood and xr was changed with turbog. Any one of a/g/xr rate
> tables would do here i believe (all we want is a rate table with
> MODULATION_OFDM and the right values in kbps -which are common for
> a/g- so that computetxtime is ok with it), we prefer xr rate table so
> that rate duration is also written for xr rates.
>
> We also have to fix ath5k_hw_get_rate_table because it returns xr rate
> table for turbog mode and xr has nothing to do with it (it operates on
> 5Ghz), TURBO table is ok for both turboa/turbog modes (that's why
> MODE_ATHEROS_TURBO is ok there and shouldn't be removed -rate duration
> table is different for turbo modes, they have MODULATION_TURBO and
> computetxtime behaves differently-).
>
> I believe we should define MODE_XR as we defined TURBOG internally and
> do the same thing we did on madwifi-old-openhal.
>
> As for the comment it says:
>
> /* For 802.11a/g Turbo/XR mode (AR5K_MODE_XR here is
>  * O.K. for both a/g - OFDM) */
>
> so for a/g and xr we use XR rate table and for turboa/turbog we use
> TURBO rate table. If it's misleading plz change it to something
> better.

Actually this caused by a bug I had sent a primer fix to ath5k-devel a
while back. Let me just post these patches as they're long due... I'll
post the rework of rates stuff I have been working on later.. This
just needs to get fixed ASAP.

  Luis
