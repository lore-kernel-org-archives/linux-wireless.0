Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbYCESiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:38:19 -0500
Subject: Re: Q) what's difference between ../net/ieee80211 and
	../net/mac80211 ?
From: Dan Williams <dcbw@redhat.com>
To: cs010101@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <001201c87e58$76d98d90$3b0aa8c0@39fb6b6b6f434b3>
References: <001201c87e58$76d98d90$3b0aa8c0@39fb6b6b6f434b3>
Content-Type: text/plain; charset=utf-8
Date: Wed, 05 Mar 2008 13:35:13 -0500
Message-Id: <1204742113.9378.25.camel@localhost.localdomain> (sfid-20080305_183823_997601_D1B0D57C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-05 at 09:32 +0900, =EA=B9=80=EC=98=81=ED=99=98 wrote:
> in my case, chipset is an atheros and it used by mac80211, cfg80211.
>=20
> so... what is differ from '../net/ieee80211 driver?

ieee80211 is an older quasi-softmac helper library (note that I didn't
say "stack") that's used by the ipw2100, ipw2200, ipw2915, and ipw3945
drivers.  ipw3945 has recently been replaced by iwl3945 which uses
mac80211 instead.

ieee80211 doesn't really do any 802.11 management stuff, it's really
just a bunch of helpers and some code to encapsulate/decapsulate betwee=
n
802.3 frames and 802.11 frames.  The ipw2100, 2200, and 2915 are all
half-mac; they do association, scanning, and some management duties in
hardware, but the actual datapath is more softmac.

mac80211 is a purely software 802.11 stack and does almost everything i=
n
software on the host CPU.  Most new laptop-class 802.11 chipsets out
today would need to use mac80211.

Dan

>=20
> *^_^*
>=20
>=20
> thanks~
>=20
>=20
> --
> --
> Have a Wonderful Day~~!!
> =EA=B9=80=EC=98=81=ED=99=98 (James-Youngwhan Kim)
> yhkim@corebell.co.kr
> cs010101@gmail.com
> +82-42-863-0340
> +82-10-6753-0987
> HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu,
> Daejon,  Republic of Korea
> 305-701
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
