Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46867 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049Ab2EQJ7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 05:59:19 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 0/2] bind RTS threshold to vif.
Date: Thu, 17 May 2012 11:58:41 +0200
Message-ID: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120517_115923_062368_D327E9AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

following patches bind rts threshold to vif.
I think it might be useful in multi channel operation
(one chip handling multiple virtual interfaces on different
channels).

RTS threshold is still set with NL80211_CMD_SET_WIPHY, and can
be now executed for both hw and vif, so it's backward compatible
(from userspace).

.set_rts_threshold driver's callback has additional
<struct ieee80211_vif *vif> parameter, so it will require
changes in all related drivers.

It's assumed, that when setting is done for hw, null vif pointer
is passed to driver (is that acceptable?).

I'm also not sure about solution in ieee80211_reconfig: I'm
trying to set rts threshold for each vif, and when it fails
(assuming that driver doesn't support setting for vif), I'm
setting rts for hw (so vif == NULL in .set_rts_threshold call).
Maybe it would be better to add new define for ieee80211_hw.flags
indicating whether driver supports setting rts threshold for vif?

BR,
Lukasz
