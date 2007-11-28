Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:36265 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXK1SUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 13:20:18 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1850362wah
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 10:20:17 -0800 (PST)
Message-ID: <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com> (sfid-20071128_182025_726461_6DFC1C92)
Date: Wed, 28 Nov 2007 20:20:17 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
In-Reply-To: <1196189059.6058.95.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1196189059.6058.95.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you would compose your email in less arrogant tone I would answer
you why your assumptions are wrong.
I know it is tempting to teach BIG Intel, but please try to keep good
spirit on this mailing list as it was so far.
Thanks
Tomas.


On Nov 27, 2007 8:44 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Today's lesson is brought to you by the motivation to teach you how to
> write simpler code since apparently the only way you found so far to get
> drivers working on big endian platforms is to use a big endian
> conversion hammer (ambiguity intentional :) ). Which is not at all
> necessary. Maybe you don't want to do this as it's a lot of work to
> start with, but the current way you do things more than suboptimal.
>
> But let me explain. And since examples are always good, I picked one at
> random from the iwl4965 driver.
>
> Consider the phy_flags field in the iwl4965_rx_phy_res structure which
> is defined as follows:
>         __le16 phy_flags;       /* general phy flags: band, modulation, ... */
>
> along with these definitions:
>
> #define RX_RES_PHY_FLAGS_BAND_24_MSK            __constant_cpu_to_le16(1 << 0)
> #define RX_RES_PHY_FLAGS_MOD_CCK_MSK            __constant_cpu_to_le16(1 << 1)
> #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK     __constant_cpu_to_le16(1 << 2)
> #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK        __constant_cpu_to_le16(1 << 3)
> #define RX_RES_PHY_FLAGS_ANTENNA_MSK            __constant_cpu_to_le16(0xf0)    [1]
>
> This is very complex. Why? Because you continually have to use __le16
> for any phy flags field. To extract the antenna, here's what you need to
> do:
>
> __le16 phy_flags_hw = phy_res->phy_flags;
> [...]
>
> antenna = le16_to_cpu(phy_flags_hw & ANTENNA_MSK) >> 4;
>
> Also, on a big-endian architecture that expands to this beast:
> rt_antenna =
>   (__builtin_constant_p((__u16)(( __u16)(__le16)(phy_flags_hw &
> (( __le16)((__u16)( (((__u16)((0xf0)) & (__u16)0x00ffU) << 8) |
> (((__u16)((0xf0)) & (__u16)0xff00U) >> 8) )))))) ?
> ((__u16)( (((__u16)((( __u16)(__le16)(phy_flags_hw &
> (( __le16)((__u16)( (((__u16)((0xf0)) & (__u16)0x00ffU) << 8) |
> (((__u16)((0xf0)) & (__u16)0xff00U) >> 8) )))))) & (__u16)0x00ffU) << 8)
> | (((__u16)((( __u16)(__le16)(phy_flags_hw &
> (( __le16)((__u16)( (((__u16)((0xf0)) & (__u16)0x00ffU) << 8) |
> (((__u16)((0xf0)) & (__u16)0xff00U) >> 8) )))))) & (__u16)0xff00U) >>
> 8) )) : __fswab16((( __u16)(__le16)(phy_flags_hw &
> (( __le16)((__u16)( (((__u16)((0xf0)) & (__u16)0x00ffU) << 8) |
> (((__u16)((0xf0)) & (__u16)0xff00U) >> 8) ))))))) >> 4;
>
> It also results in a compiler warning:
> [...] warning: integer overflow in expression
>
> although I have to admit that right now I do not know where in that
> beast the compiler thinks it got an overflow. Twice, in fact. In any
> case, it's pretty hard on the compiler.
>
> Additionally, doing it this way means that programmers continually need
> to think about endianness *all over the code*. Literally *everywhere*
> that touches values coming from hardware/going to hardware, which is
> pretty much everywhere in a driver.
>
> Now, here's what I want to teach you to do instead.
>
> Keep the phy_flags field defined as it was:
>         __le16 phy_flags;       /* general phy flags: band, modulation, ... */
>
> but do it like everybody else and define the values as they are in the
> phy_flags field without thinking about endianness at all:
>
> #define RX_RES_PHY_FLAGS_BAND_24_MSK            (1 << 0)
> #define RX_RES_PHY_FLAGS_MOD_CCK_MSK            (1 << 1)
> #define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK     (1 << 2)
> #define RX_RES_PHY_FLAGS_NARROW_BAND_MSK        (1 << 3)
> #define RX_RES_PHY_FLAGS_ANTENNA_MSK            0xf0
>
> This is easier for the person writing the definitions and looks much
> cleaner to boot.
>
> Then, when it comes to using a value, simply do:
>
> u16 phy_flags = le16_to_cpu(phy_res->phy_flags);
>
> (and if you get it wrong, sparse will warn here.)
>
> Then, you can do the easy:
> antenna = (phy_flags & ANTENNA_MASK) >> 4;
>
> without having to think about endianness. And if you use the field again
> and again you never have any conversion functions.
>
> Presto. As long as you think in terms of
>         this is the phy_flags field that contains X, Y and Z at
>         positions x, y, z
>
> rather than
>
>         this is 16 bits that are laid out in such and such way
>
> (which I think everybody except hardware designers does), you win.
>
> As a bonus, your code is much easier to read and much smaller (C/header
> file size I mean). Also, it's a lot more efficient for fields that
> contain multiple fields like the antenna field (with more than one bit)
> because you do the conversion only once.
>
> Think of it this way:
>
> Your current style of taking care of endianness requires thinking about
> it everywhere, is thus prone to errors and looks ugly.
>
> The way I'm suggesting is to convert all data to native (CPU) endianness
> _as it enters the system_, i.e. at the driver/hardware boundary and then
> think in terms of the "field" after that, never bothering to think about
> endianness again. In fact, you shouldn't ever need to use cpu_to_le*()
> in the RX path, only in any control/TX paths where you need to push a
> value down to the hardware.
>
> The iwlwifi code is a big mess this way. I'm willing to help with the
> conversion, it should be a pretty mechanical removal of many many
> cpu_to_le16/32 calls and some fixups and will definitely make the code
> much easier to maintain. In fact, it would probably have been easier if
> you'd written the code without respect for endianness and then we'd
> simply annotated all structures that are shared with the hardware and
> fixed the sparse warnings at the system boundaries.
>
> I hope this helps. Let me know if you have any questions.
>
> I have one for you: Whatever gave you the idea of doing it this way?
> Isn't it common sense that converting data at system boundaries is much
> easier and less prone to errors than trying to pull it through the whole
> second system in a non-native format? Whether it's endianness, character
> set conversion, ...
>
> johannes
>
> [1] By the way, using __constant_cpu_to_le16() is not useful because
> cpu_to_le16() already checks whether the argument is a constant. You
> should only use it if absolutely necessary for some reason. That's why
> it has two underscores.
>
