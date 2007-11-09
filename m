Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45480 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbXKIWxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 17:53:39 -0500
Message-ID: <4734E4ED.5000800@lwfinger.net> (sfid-20071109_225345_215762_66541F6D)
Date: Fri, 09 Nov 2007 16:53:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 0/6] ssb and friends: Change layout and naming of SPROM data
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the various Broadcom devices that are supported, several revisions of the SPROM have been
encountered. Current code takes advantage of the fact that Revision 2 inherits all the data of
1, and that Revision 3 inherits most data from 2. This scheme breaks down with revision 4, which
does not inherit from the earlier models. In addition, the current code has an error for Rev. 3
SPROMS. In deciding how best to implement the new design, a fresh approach is warranted.
Furthermore, we decided not to include any SPROM variables not used in the supported drivers (b44,
b43 and b43legacy). To keep the patches small while preserving compilation and correct execution
during bisection, the change has been split into the following pieces:

1. Introduce new structure while maintaining the old.
2. Convert the ssb module to the new structure.
3. Convert the b44 driver.
4. Convert b43.
5. convert b43legacy.
6. Remove the old structures from ssb.

Larry


