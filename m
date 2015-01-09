Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46092 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbAITSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:20 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so14624199obc.11
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:20 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/8] wcn36xx locking and a-mpdu fixes
Date: Fri,  9 Jan 2015 14:15:44 -0500
Message-Id: <1420830952-9624-1-git-send-email-me@bobcopeland.com> (sfid-20150109_201823_977616_B9063CDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

These patches have been merged into the wcn36xx github tree but have
been collecting dust for some time.  I pinged Eugene (CCed) who said I
could just go ahead and send them upstream.  Rebased and re-tested on
an Android target (and newer checkpatch warnings removed).

At some point I can go through other patches (not by me) that aren't yet
upstream and send them along as well, unless someone else wants to do that.

Bob Copeland (8):
  wcn36xx: initialize device defaults on start
  wcn36xx: use !! when assigning int as a boolean
  wcn36xx: let device generate qos seq numbers
  wcn36xx: don't process 'valid' descriptors
  wcn36xx: initialize skb_lock
  wcn36xx: initialize dxe lock
  wcn36xx: move set_tx_pdu inside set_tx_data/mgmt
  wcn36xx: initiate TX BA sessions

 drivers/net/wireless/ath/wcn36xx/dxe.c     |    3 +
 drivers/net/wireless/ath/wcn36xx/main.c    |   16 +++++-
 drivers/net/wireless/ath/wcn36xx/smd.c     |   73 +++++++++++++++++++++++-
 drivers/net/wireless/ath/wcn36xx/txrx.c    |   83 ++++++++++++++++++++++------
 drivers/net/wireless/ath/wcn36xx/txrx.h    |    9 ++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |   20 +++++++
 6 files changed, 182 insertions(+), 22 deletions(-)

-- 
1.7.10.4

