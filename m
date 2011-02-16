Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:57842 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab1BPWRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 17:17:48 -0500
Subject: Re: [RFC] How to rename SSB_TMSLOW_*, B43_TMSLOW_*?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com> (sfid-20110216_141342_431478_3C8E43BA)
References: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
	 (sfid-20110216_141342_431478_3C8E43BA)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 23:17:37 +0100
Message-ID: <1297894657.32237.2.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-16 at 14:13 +0100, Rafał Miłecki wrote: 
> Except for following 3 defines:
> #define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
> #define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
> #define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */
> 
> All our SSB_TMSLOW_* and B43_TMSLOW_* defines are some core control
> bits. As we now know, core control bits are not SSB specific or TMSLOW
> specific.
> 
> Should we (and how) define that names in this situation?
> 
> For b43 I propose (quite obvious?) B43_CORE_CTL_*.
> 
> However what about SSB_TMSLOW_*? George proposed SSB_CORECTL_*, but it
> contains "SSB", while that bits are not SSB specific. Same bits are
> used on AI bus. Should we use some SSBAI_CORE_CTL_* then? Any other
> ideas? Some better maybe?
> 
> P.S.
> Personally I prefer CORE_CTL over CORECTL (George). Which one should we use?

Let's simply put those bits into the drivers and call them
DRIVERNAME_TMSLOW_FOOBAR

The "TMSLOW" part seems rather important to me, because that makes it
obvious what register these bits belong to. Note that's there's also
TMSHIGH. It also follows current naming convention.

-- 
Greetings Michael.

