Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:40918 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FZS7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 14:59:46 -0400
Received: by mail-ie0-f180.google.com with SMTP id f4so30594706iea.25
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 11:59:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372231882.8157.0.camel@jlt4.sipsolutions.net>
References: <51C52E79.30104@rempel-privat.de> <CAG6hwVOCfDK9nkh3e0fFMGcWp8XLQnPC8TzQb9eET2fwFPq3SA@mail.gmail.com>
 <51C93538.4050304@rempel-privat.de> <CAG6hwVMa+i=wXRyfcwaXH8NesCXgKXW6Ad4dzgd9DZONGYA=xQ@mail.gmail.com>
 <1372231882.8157.0.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 26 Jun 2013 11:52:35 -0700
Message-ID: <CAG6hwVNk-sA_RFYJN+MzSURwWZYd-X3Uu8g2sRP8AfyKWQUQbw@mail.gmail.com> (sfid-20130626_205949_151864_EDB89FF1)
Subject: Re: regression after, " ath9k_htc: Add support for mesh interfaces"
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 12:31 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2013-06-25 at 13:05 -0700, Thomas Pedersen wrote:
>
>> That warning is triggered by wiphy_verify_combinations():
>>
>>                         if (WARN_ON((wiphy->interface_modes & types) != types))
>>                                 return -EINVAL;
>>
>> But before that, the mesh iftype bit is cleared in ieee80211_register_hw():
>>
>> #ifndef CONFIG_MAC80211_MESH
>>         /* mesh depends on Kconfig, but drivers should set it if they want */
>>         local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
>> #endif
>>
>> It seems the intention was to avoid an #ifdef CONFIG_MAC80211_MESH in
>> every driver, but then mac80211 also has to clear the MESH_POINT bit
>> for each ieee80211_iface_limit? I don't really see a cleaner way of
>> resolving this.
>
> The problem is that the data structures there are const, so we can't
> modify them. I think the other drivers just have an #ifdef on
> MAC80211_MESH or so in there.

Indeed, ath5k and rt2x00 at least already do this.

Thanks,

--
Thomas
