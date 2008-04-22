Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58757 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYDVEmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 00:42:19 -0400
Message-ID: <480D6CA4.8040205@trash.net> (sfid-20080422_064316_030036_9B157C90)
Date: Tue, 22 Apr 2008 06:42:12 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Roy Marples <uberlord@gentoo.org>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: prism54 regression in current -git
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "prism54: set carrier flags correctly" makes my
prism54 device in AP mode come up without a carrier, which
in causes IPv6 to not add a link-local address, which in
turn causes radvd (configured to announce routes on that
device) to refuse to start, breaking IPv6 for the entire
network.

I didn't check whether a carrier is detected once a client
associates, but in any case it seems to me that a device
in AP mode should always indicate a carrier.

