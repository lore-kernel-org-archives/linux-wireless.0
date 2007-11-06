Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45135 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbXKFTM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:12:57 -0500
Message-ID: <4730BCB8.900@lwfinger.net> (sfid-20071106_191302_744902_07A72509)
Date: Tue, 06 Nov 2007 13:12:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: [RFC 0/6] ssb and friends: Change layout and naming of SPROM data
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the various Broadcom devices that are supported, several revisions of the SPROM have been
encountered. Current code takes advantage of the fact that Revision 2 inherits all the data of
1, and that Revision 3 inherits from 2. This scheme breaks down with revision 4, which does not
inherit from the earlier models. In deciding how best to implement the new design, a fresh approach
is warranted. Furthermore, we decided not to include any SPROM variables not used in b44, b43 or
b43legacy, the supported drivers. To keep the patches small while preserving compilation and correct
execution during bisection, the change has been split into the following pieces:

1. Introduce new structure while maintaining the old.
2. Convert the ssb module to the new structure.
3. Convert the b44 driver.
4. Convert b43.
5. convert b43legacy.
6. Remove the old structures from ssb.

Larry

