Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54778 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab1BIVO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:14:57 -0500
Subject: Re: SSB AI support code ([RFC4/11] SSB core control and state
 device ops)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297285438.11767.28.camel@dev.znau.edu.ua> (sfid-20110209_221147_001764_10FFD7B7)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <1297262089.18053.24.camel@dev.znau.edu.ua>
	 <AANLkTinC+ijSG=qzzk9OWLGRLsxM0dm12YkERxKbwg6t@mail.gmail.com>
	 <1297285438.11767.28.camel@dev.znau.edu.ua>
	 (sfid-20110209_221147_001764_10FFD7B7)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 22:14:52 +0100
Message-ID: <1297286092.9734.17.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 23:03 +0200, George Kashperko wrote: 
> 1)
> if (sb_bus) 
> 	ssb_write32(dev, (ssb_read32(dev, SSB_TMSLOW) & ~(mask << 16)) | (flags << 16));
> else
> 	ssb_write32(dev, (ssb_read32(dev, SSB_AI_IOCTL) & ~mask) | flags));
> 2)
> ssb_core_ctl_flags(dev, mask, flags, NULL);

3) The non-obfuscated way; in the driver:

if (sb_bus) 
	ssb_write32(dev, (ssb_read32(dev, SSB_TMSLOW) & ~(mask << 16)) | (flags << 16));
else
	ai_write32(dev, (ai_read32(dev, AI_IOCTL) & ~mask) | flags));

-- 
Greetings Michael.

