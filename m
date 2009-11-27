Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:43847 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751009AbZK0UlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 15:41:21 -0500
Message-ID: <4B103971.2020308@free.fr>
Date: Fri, 27 Nov 2009 21:41:21 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: 8an@praha12.net
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] API for setting ACK timeout
References: <200911261826.08576.8an@praha12.net>
In-Reply-To: <200911261826.08576.8an@praha12.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukáš Turek a écrit :
> Hi,
> 
> we discussed this in ath5k-devel, but it involves a mac80211 extension, so I'm 
> bringing it here.
> 
> Although Wi-Fi was designed for outdoor use, it's also sometimes used for long 
> distance outdoor links. However, long distance links require longer ACK 
> timeout, as packets travel "only" at the speed of light and every kilometer 
> adds almost 7 microseconds to the roundtrip. So for a driver to be usable 
> outdoors it has to permit setting ACK timeout from userspace.
> 
> Currently this is supported only by out-of-tree Madwifi driver for Atheros 
> hardware. However, modification of ACK timeout is not an Atheros specific 
> feature. According to a quick skim over the source code in 
> drivers/net/wireless, besides ath5k and ath9k it's at least supported by 
> rt2x00, rtl818x and maybe zd1211.
> 
> I think the current hardware support is sufficient for a generic mac80211 
> solution. The exact interpretation of ACK timeout value is hardware specific, 
> so I propose a higher level API operating with link distance.
> 
> It consists of a new nl80211 parameter:
> [NL80211_ATTR_WIPHY_DISTANCE] = { .type = NLA_U32 },
> 
> The value of the parameter would be a link distance in meters, so after the 
> support is added to iw one could set the ACK timeout on a 3km link using:
> # iw phy0 set distance 3000
> 
> Another required change would be extending cfg80211_ops by functions 
> set_distance and get_distance. Calculation of appropriate ACK timeout (and in 
> the case of ath5k, also CTS timeout and slottime) for the distance would be 
> left to the driver (it's a trivial formula).
> 
> I can prepare the patches, if you think these extension would be acceptable. 
> Suggestions are welcome.
> 
> Lukas Turek

Hello Lukas,

I think that's a good idea indeed. I think the relationship between ACK
timeout, CTS timeout and slottime and distance should be common (ie
implemented at mac80211 level) since the formula is not so trivial to me
(at least, I've seen several formulas flying around). Then, each driver
needs to convert ACK timeout since the HW registers probably takes into
account some specific MAC hw time.

Moreover, the formula is not the same for 2.4 GHz and 5 GHz.

madwifi had a patch for automatically finding the best ACK timeout,
maybe it could be ported to mac80211 as well.

My 2 cents,
Benoit
