Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656AbaLJTOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 14:14:21 -0500
From: Jes.Sorensen@redhat.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/1] mac80211: Avoid accessing uninitialized stack data
Date: Wed, 10 Dec 2014 14:14:06 -0500
Message-Id: <1418238847-3332-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20141210_201424_840396_4E710370)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

Working on a wifi driver I hit the case where
ieee80211_determine_chantype() could end up accessing uninitialized
stack data, if a driver advertised it's supported bands as having HT
support, but only 20MHz channel support.

This patch should take care of the issue by copying over *chandef into
vht_chandef. I don't think it would be correct to set
IEEE80211_STA_DISABLE_VHT here since I believe it is valid for a
driver to support VHT without 40+MHz support? Please correct me if I
am wrong.

This is against the current staging tree, but should be valid for 3.18
and probably also the stable kernels.

Cheers,
Jes


Jes Sorensen (1):
  wireless: mac80211: Avoid using uninitialized stack data

 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

-- 
1.9.3

