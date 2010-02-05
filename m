Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:37135 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0BEQ0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 11:26:21 -0500
To: Dan Williams <dcbw@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] airo: fix WEP key clearing after c0380693520b1a1e4f756799a0edc379378b462a 
In-reply-to: dcbw's message of Thu, 04 Feb 2010 23:06:54 -0800.
             <1265353614.11066.11.camel@localhost.localdomain>
Date: Fri, 05 Feb 2010 11:26:20 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100205162620.0B2632B0054@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

| The firmware apparently needs the WEP key RID touched when turning
| WEP off, otherwise it gets angry and refuses to return scan results.
| The firmware doesn't handle zero-length WEP keys so quite the warning
| message that was inadvertently printed when disabling WEP, which
| wpa_supplicant could trigger repeatedly.
|
| Signed-off-by: Dan Williams <dcbw@redhat.com>

 This patch does *not* work for me; with it applied to the 2.6.33-rc6
from-git that I have been using as the testing basis, the resulting
kernel does not see any wireless networks. dmesg has multiple reports
of:

	airo(eth1): cmd:103 status:7f03 rsp0:0 rsp1:ff10 rsp2:c0f0
	airo(eth1): cmd:103 status:7f03 rsp0:0 rsp1:ff10 rsp2:c0f0

	- cks
