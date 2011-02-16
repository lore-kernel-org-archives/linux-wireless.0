Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:12492 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1BPPHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 10:07:03 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000021884.msg
	for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 17:06:20 +0200
Subject: Re: [RFC] How to rename SSB_TMSLOW_*, B43_TMSLOW_*?
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
References: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Feb 2011 16:58:40 +0200
Message-Id: <1297868320.24013.18.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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
I'm still sure AI us much more SSB rather than lets say BCMAI. In
current SSB architecture each core software-wise is represented by 4k
registers' space with own core registers and bus-specific registers in
that single 4k page. AI cores keep own core registers same as SSB in
single 4k space whereas bus-specific registers are in separate page and
have somewhat another layout. But among all the bus specific registers
for both SSB and AI despite the fact they located in different places
they either share the same meaning with just different layout
(TMSLOW/TMSHIGH) or can be abstracted by appropriate handlers
(admatch/irqflag). It looks to me much like pcie and pci which share
single software bus ideology rather than introducing two different
buses. Therefore I still don't really convinced with idea that just for
that difference in where bus-specific registers are located we should
introduce one more bus. Actually it looks somewhat similar to
core-wrappers' technique already in SSB - those admatch thingys used to
access sub-cores withing SSB core. We don't expose any sw buildups for
just those, same as we could do for AI if only let it share SSB code
base.

> 
> P.S.
> Personally I prefer CORE_CTL over CORECTL (George). Which one should we use?
> 
I decided on CORECTL/CORESTAT over CORE_CTL/CORE_STATE just to get long
things to be bits shorter.

Have nice day,
George


