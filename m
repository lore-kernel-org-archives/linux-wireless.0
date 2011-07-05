Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1GEOi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 10:38:56 -0400
Message-Id: <20110705143538.696899280@sipsolutions.net> (sfid-20110705_163900_388383_7D4E7E1D)
Date: Tue, 05 Jul 2011 16:35:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] first step towards GTK rekey offload
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are a first step to allow devices
to implement GTK rekeying while suspended (or
really at any time).

The key iteration (first patch) is necessary as
we need to load a different firmware image, and
I don't want to do double-bookkeeping (tracking
all keys in the driver).

The second and third patch allow wpa_supplicant
to give the necessary information to the driver
to implement GTK rekeying.

Note that for iwlwifi this isn't yet sufficient
as it also needs access to the CCMP PN/TKIP IVs
to encrypt the GTK rekey reply frame correctly.
However, I have only tested with CCMP so I'll
submit those patches only when I've also tested
TKIP.

johannes

