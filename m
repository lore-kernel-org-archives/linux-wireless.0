Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:58867 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZKZRc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 12:32:56 -0500
Received: by fxm5 with SMTP id 5so941449fxm.28
        for <linux-wireless@vger.kernel.org>; Thu, 26 Nov 2009 09:33:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911261826.08576.8an@praha12.net>
References: <200911261826.08576.8an@praha12.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 26 Nov 2009 18:32:39 +0100
Message-ID: <69e28c910911260932n4bc3e82du33a28ad9a5e8482@mail.gmail.com>
Subject: Re: [RFC] API for setting ACK timeout
To: 8an@praha12.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2009 at 6:26 PM, Lukáš Turek <8an@praha12.net> wrote:
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

Why not instead allow setting ACK timeout directly, e.g. in
milliseconds? (Similar to how signal strength is almost always
returned in dBm, even though the devices themselves use all kinds of
units.)

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
