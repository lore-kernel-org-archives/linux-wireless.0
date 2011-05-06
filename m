Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60939 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab1EFPxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 11:53:46 -0400
Received: by fxm17 with SMTP id 17so2433836fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 08:53:45 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2.6.39] mac80211: always clear PS filtering for non-AP interfaces
Date: Fri, 6 May 2011 17:53:41 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	greearb@candelatech.com
References: <1304642474-32935-1-git-send-email-nbd@openwrt.org> <1304689402.3595.12.camel@jlt3.sipsolutions.net> <4DC3FBFF.1010504@openwrt.org>
In-Reply-To: <4DC3FBFF.1010504@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201105061753.41835.chunkeey@googlemail.com> (sfid-20110506_175349_584551_656D2C45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 May 2011 15:47:43 Felix Fietkau wrote:
> On 2011-05-06 3:43 PM, Johannes Berg wrote:
> > On Fri, 2011-05-06 at 15:35 +0200, Felix Fietkau wrote:
> >
> >>  >>   >>    +		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
> >
> >>  Rely on what being set in AP mode only? The patch ensures that the flag
> >>  for *clearing* PS filtering gets set for all non-AP modes.
Yes, but p54 fw can and will filter frames in STA PS mode as well [This is
great because we can sent any frames to the device without caring about
the RX/TX races in the PS design, since the FW will return all frames with 
"tx rejected due to PS"  until the device receives the wake-up command].

> >>  This flag
> >>  already gets set whenever tx->sta is unset, so I think it also makes
> >>  sense to extend that for other cases where the hardware is not supposed
> >>  to enable any PS filtering on its own.
> >
> > I didn't remember/know about the case where sta is unset, but still,
> > what if the driver checks for the flag and does something that's only
> > valid in AP mode? I'm thinking firmware API here, not HW like ath9k.
> >
> >>  >  Your patch makes those drivers responsible for checking the mode, but
> >>  >  that makes less sense than having drivers that need to do some magic in
> >>  >  all modes, no?
> >>  How does my patch make drivers responsible for checking the mode?
> >
> > Well, say I implement the clearing by sending something command to the
> > device, like p54. If that's only valid in AP mode in the firmware, now
> > this driver has to check that it's AP mode, where before it didn't have
> > to. That's not counting the sta==NULL case I guess.
> >
> > OTOH, we only have two drivers using the flag anyway. Go figure it out
> > between those two :)
> mac80211 already sets the flag for all modes. If drivers were depending 
> on it being set only for AP mode, then those drivers would break even 
> without my patch.
Setting the flag for broadcast is not a problem and neither is it when
the frame was filtered, but now it will be always "on" [in STA mode]
and this should be reserved for PS-POLLs [which is a different flag].

Regards,
	Chr
