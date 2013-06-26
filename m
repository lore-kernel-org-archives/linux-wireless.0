Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58303 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3FZTQZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 15:16:25 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0Lse5X-1U7cBa2AeX-012HSg for
 <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 21:16:23 +0200
Message-ID: <51CB3E04.3000402@rempel-privat.de> (sfid-20130626_211628_212259_707C083B)
Date: Wed, 26 Jun 2013 21:16:20 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Thomas Pedersen <thomas@cozybit.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Subject: Re: regression after, " ath9k_htc: Add support for mesh interfaces"
References: <51C52E79.30104@rempel-privat.de> <CAG6hwVOCfDK9nkh3e0fFMGcWp8XLQnPC8TzQb9eET2fwFPq3SA@mail.gmail.com> <51C93538.4050304@rempel-privat.de> <CAG6hwVMa+i=wXRyfcwaXH8NesCXgKXW6Ad4dzgd9DZONGYA=xQ@mail.gmail.com> <1372231882.8157.0.camel@jlt4.sipsolutions.net> <CAG6hwVNk-sA_RFYJN+MzSURwWZYd-X3Uu8g2sRP8AfyKWQUQbw@mail.gmail.com>
In-Reply-To: <CAG6hwVNk-sA_RFYJN+MzSURwWZYd-X3Uu8g2sRP8AfyKWQUQbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 26.06.2013 20:52, schrieb Thomas Pedersen:
> On Wed, Jun 26, 2013 at 12:31 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2013-06-25 at 13:05 -0700, Thomas Pedersen wrote:
>>
>>> That warning is triggered by wiphy_verify_combinations():
>>>
>>>                          if (WARN_ON((wiphy->interface_modes & types) != types))
>>>                                  return -EINVAL;
>>>
>>> But before that, the mesh iftype bit is cleared in ieee80211_register_hw():
>>>
>>> #ifndef CONFIG_MAC80211_MESH
>>>          /* mesh depends on Kconfig, but drivers should set it if they want */
>>>          local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
>>> #endif
>>>
>>> It seems the intention was to avoid an #ifdef CONFIG_MAC80211_MESH in
>>> every driver, but then mac80211 also has to clear the MESH_POINT bit
>>> for each ieee80211_iface_limit? I don't really see a cleaner way of
>>> resolving this.
>>
>> The problem is that the data structures there are const, so we can't
>> modify them. I think the other drivers just have an #ifdef on
>> MAC80211_MESH or so in there.
>
> Indeed, ath5k and rt2x00 at least already do this.
>
> Thanks,

I just discovered one more issue with mesh on ath9k* devices.
if i try to do "ifconfig mesh0 down" this task will freeze and after 
some time kernel will oops.

Steps to reproduce:
iw dev wlan2 interface add mesh0 type mp mesh_id mesh
iwconfig mesh0 channel 1
ifconfig mesh0 10.0.0.1 netmask 255.255.255.0 up
sleep 30
ifconfig mesh0 down

-- 
Regards,
Oleksij
