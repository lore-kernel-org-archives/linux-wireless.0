Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbXJFMEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:16 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:15 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/16] rt2x00: Reorganize configuration handler
Date: Sat, 6 Oct 2007 14:17:39 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200710061417.40152.IvDoorn@gmail.com> (sfid-20071006_131651_528439_736CE7FC)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorganize configuration handling by creating a extra
structure which contains precalculated values based
on the mac80211 values which are usefull for all
individual drivers.

This also fixes the preamble configuration problem,
up untill now preamble was never configured since
by default the rate->val value was used when changing
the mode.
Now rate->val will only be used to set the basic rate mask.
The preamble configuration will now be done correctly
through the erp_ie_changed callback function.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

http://kernel.org//pub/linux/kernel/people/ivd/rt2x00-2.0.10/0013-rt2x00-Reorganize-configuration-handler.patch
