Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53861 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1K0WQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 17:16:05 -0500
Received: by vcbfk14 with SMTP id fk14so3181487vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 14:16:03 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH 0/2] mac80211: use timeout from addba resp
Date: Sun, 27 Nov 2011 17:15:51 -0500
Message-Id: <1322432153-17425-1-git-send-email-mar.kolya@gmail.com> (sfid-20111127_231609_949056_E5E23CE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  If other side sent us non zero timeout in addba response use it as a
timeout for TX session. Before this patch initiator and recipient
could have different timeouts if recipient decides to change timeout
offered by initiator.
  This patchset also adds timeout information into agg_status sysfs file.
  This should be applied after patches for "timeout tx agg sessions in
way similar to rx agg sessions".

  All comments and suggestions are appreciated.
  Thanks.

Nikolay Martynov (2):
  mac80211: Use timeout from addba resp
  mac80211: add session timeout to agg_status debugfs file

 net/mac80211/agg-tx.c      |   10 +++++++++-
 net/mac80211/debugfs_sta.c |    9 +++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
1.7.4.1

