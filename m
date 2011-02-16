Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35559 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1BPNNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 08:13:32 -0500
Received: by qwa26 with SMTP id 26so1264554qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 05:13:32 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 16 Feb 2011 14:13:32 +0100
Message-ID: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
Subject: [RFC] How to rename SSB_TMSLOW_*, B43_TMSLOW_*?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>,
	George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Except for following 3 defines:
#define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
#define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
#define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */

All our SSB_TMSLOW_* and B43_TMSLOW_* defines are some core control
bits. As we now know, core control bits are not SSB specific or TMSLOW
specific.

Should we (and how) define that names in this situation?

For b43 I propose (quite obvious?) B43_CORE_CTL_*.

However what about SSB_TMSLOW_*? George proposed SSB_CORECTL_*, but it
contains "SSB", while that bits are not SSB specific. Same bits are
used on AI bus. Should we use some SSBAI_CORE_CTL_* then? Any other
ideas? Some better maybe?

P.S.
Personally I prefer CORE_CTL over CORECTL (George). Which one should we use?

-- 
Rafał
