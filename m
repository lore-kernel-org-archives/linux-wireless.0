Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56109 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab2DQW7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 18:59:31 -0400
Received: by lahj13 with SMTP id j13so5255661lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 15:59:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120417163746.35c232c8@destiny.ordissimo>
References: <20120413142352.3b927516@destiny.ordissimo> <20120417163746.35c232c8@destiny.ordissimo>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 Apr 2012 08:59:10 +1000
Message-ID: <CAGRGNgX_T=LGTN90zXp_CrjWfMx3RrkvGs8uKYg9SXqU0q2pxQ@mail.gmail.com> (sfid-20120418_005936_517519_575A0F2A)
Subject: Re: RT5390 not working with rt2800pci
To: Anisse Astier <anisse@astier.eu>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kevin Chou <kevin.chou@mediatek.com>,
	John Li <chen-yang.li@mediatek.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anisse,

On Wed, Apr 18, 2012 at 00:37, Anisse Astier <anisse@astier.eu> wrote:
> Ok, I've found a solution.
>
> After looking into the latest ralink release, for chipset 5572, I saw
> that rt5390 support was updated. And that support for the chip with rev
> 1502 was added, named RT5390R.
> The only difference with "normal" 5390 is that this one supports hardware
> antenna diversity, so the driver should tell the card which antenna to
> use by default (the main one in my case).
> This is replicated in the patch below, which has been tested on both
> working and non-working 1502s, and is proving to work quite well.

That would explain it - I'm guessing the non-working 1502s have their
antennas set up "wrongly" by default.

> I still don't know how to integrate this properly with rt2800pci's
> antenna diversity code, since this is the first chipset to have hardware
> antenna diversity in the rt2800 family (others had it in rt61 and rt73
> for example).

I think the patch you sent is a reasonable workaround (with an
appropriate comment explaining what's happening) while proper antenna
diversity support is added.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
