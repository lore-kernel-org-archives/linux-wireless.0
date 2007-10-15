Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13590 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbXJOOwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 10:52:23 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
Date: Mon, 15 Oct 2007 16:49:26 +0200
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org
References: <200710111151.06989.hs4233@mail.mn-solutions.de> <200710151628.43425.hs4233@mail.mn-solutions.de> <1192459352.12009.25.camel@localhost.localdomain>
In-Reply-To: <1192459352.12009.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710151649.26864.hs4233@mail.mn-solutions.de> (sfid-20071015_155228_496588_832D9521)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I assume you've been running it for a few days or so?

No. I just made this patch 6 hours ago.

I've used it so far only with WEP and no encryption at all, 
always as STA (no ad-hoc, no wpa-supplicant).

After all, the patch was created using "perl -pi -e" :-)


So far I found two quirks:

a) it's no longer /lib/modules/libertas/parameters/libertas_debug 
but /lib/modules/libertas/parameters/lbs_debug. As this is an 
ABI change, we might not want it.

b) it's no longer <debugfs>/libertas_wireless/XXXX but 
<debugfs>/lbs_wireless/XXXX. Also an ABI change.


I could make a "take 2" patch, but because of the size of the 
patch and the hassle to export it in an external git tree I'd 
rather create a fixup patch. But let's see what you un-earth.

