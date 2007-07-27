Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41831
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765481AbXG0WeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 18:34:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 09/17] iwlwifi: EEPROM reading fix
Date: Sat, 28 Jul 2007 00:32:40 +0200
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	ipwpatch@vger.kernel.org, linux-wireless@vger.kernel.org,
	"Gregory Greenman" <gregory.greenman@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com> <200707271322.50303.mb@bu3sch.de> <1ba2fa240707271524i591ed932jd3f2998ba6203ad8@mail.gmail.com>
In-Reply-To: <1ba2fa240707271524i591ed932jd3f2998ba6203ad8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707280032.40475.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 28 July 2007 00:24:42 Tomas Winkler wrote:
> On 7/27/07, Michael Buesch <mb@bu3sch.de> wrote:
> > On Friday 27 July 2007 11:26:33 Zhu Yi wrote:
> > >               if (!(r & 1)) {
> > >                       IWL_ERROR("Time out reading EEPROM[%d]", addr);
> > > -                     return -ETIMEDOUT;
> > > +                     rc = -ETIMEDOUT;
> > > +                     goto done;
> > >               }
> > >
> > >               e[addr / 2] = le16_to_cpu(r >> 16);
> >
> > Seems like you really want cpu_to_le16() here, as "r" should better
> > be CPU-endian when shifting it by >>.
> >
> > Though, I don't see enough code context here to judge if the
> > endianess conversion is correct at all or not.
> >
> This line is empirically correct.

No, you need cpu_to_le16 here, instead of le16_to_cpu.
I know that these generate the same code, but it makes
a difference for sparse.

-- 
Greetings Michael.
