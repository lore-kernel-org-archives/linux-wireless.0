Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1LNNIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 08:08:13 -0500
Message-Id: <20111214130338.347106528@sipsolutions.net> (sfid-20111214_140819_481174_E287EBB8)
Date: Wed, 14 Dec 2011 14:03:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] station management complexity reduction
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The complexity of locking in sta_info.c has bothered
me for a while, and it would not have been possible to
inform drivers of station state in a sleeping callback
from IBSS anyway.

Make IBSS not add the stations in RX context, and thus
reduce complexity in sta_info and actually make the new
sta_info_move_state() sleeping.

johannes
