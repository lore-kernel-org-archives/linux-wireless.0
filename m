Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41215 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759031AbXGTWHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 18:07:03 -0400
Date: Sat, 21 Jul 2007 01:06:58 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Li YanBo <dreamfly281@gmail.com>
cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jeff willam <angelbane@gmail.com>
Subject: Re: Airgo MIMO Wireless card mac80211 driver (unfinished)
In-Reply-To: <1197ff4c0707200644n74159abbr47dfebd17556a8d8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707210051480.20847@kivilampi-30.cs.helsinki.fi>
References: <1197ff4c0707190820s26f28fafy784900d41f6b1ad4@mail.gmail.com>
 <Pine.LNX.4.64.0707201142480.20559@kivilampi-30.cs.helsinki.fi>
 <1197ff4c0707200644n74159abbr47dfebd17556a8d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-2096844185-1184969218=:20847"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-2096844185-1184969218=:20847
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

...hopefully I got the quoting level mess fixed... :-)

On Fri, 20 Jul 2007, Li YanBo wrote:
> On 7/20/07, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> >
> > - agnx_read32 & agnx_write32
> >         * change to static inline, solves also the use of implicit
> >           variable (reg) as you have return & assign instead (implicit
> >           variables confuse readers, see Documentation/CodingStyle)
> 
> It will be fixed later.
> 
> >         * You seem to be also doing direct access using ioread/write32
> >           here and there?!?
> 
> Yes, do you mean using  __raw_readl and __raw_writel are better?

...I was just asking whether you're _not_ using agnx_read32/write32 but
ioread32/iowrite32 directly on purpose or not...

> > - I'm not sure if the comments per reg in phy_init() are that useful if
> > the same information is found in the header file already (just a matter
> > of taste though, shouldn't prevent merging, just IMHO)
> 
> That just used to sync with the SPECS, for the SPECS always change, so it help
> me to change the code, it will be removed when the SPECS be more stable.

Like I indicated already you can as well keep them and nobody is
hurt... :-)


-- 
 i.
---696243703-2096844185-1184969218=:20847--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
