Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54543 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754054AbZB0RQW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 12:16:22 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 27 Feb 2009 18:16:18 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <200902271714.54181.mb@bu3sch.de>
Message-ID: <20090227171618.254890@gmx.net> (sfid-20090227_181625_236326_BFF32853)
MIME-Version: 1.0
References: <20090226234307.51520@gmx.net> <200902271503.13308.mb@bu3sch.de>
 <20090227153418.254900@gmx.net> <200902271714.54181.mb@bu3sch.de>
Subject: Re: [PATCH v2] mac80211: Call commit() on channel setting
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Michael!

> I think this is desired behavior.

Yes.

> We voluntarily associated with the
> "test" AP on channel 4.

Yes this is correct because IEEE80211_IBSS_AUTO_CHANNEL_SEL flag was se=
t.

> Who says that we want to assoc to the "test" ssid on channel 11?

Because this setting is now outdated. The channel is set to 11 and the =
IEEE80211_IBSS_AUTO_CHANNEL_SEL flag is clear.

If we now set the SSID to test again, we assoc to "test" on channel 11.=
 Do not recover from the channel set automatically, is a broken behavio=
r, I think.

> This is a
> policy decision and such policy
> doesn't belong into the kernel. Userspace can initiate a reassociatio=
n
> after the channel change,
> if the AP switch is desired.
> There are good reasons to leave roaming decisions in userspace, becau=
se
> these decisions are simply very
> complex and would put lots of policy into the kernel or require lots =
of
> kernel API.

I think the basic functionality should work without any userspace daemo=
n. All the that can be implemented without real problems with a few lin=
es of code. This would better for embedded systems, if we don't need th=
e wpa_supplicant for an unencrypted network, or so.

Regards
Alina

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
