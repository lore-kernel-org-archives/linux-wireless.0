Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:60875 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2K0OiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 09:38:15 -0500
Message-ID: <50B4CDE7.9040308@neratec.com> (sfid-20121127_153818_757792_1250C0F2)
Date: Tue, 27 Nov 2012 15:27:51 +0100
From: Matthias May <matthias.may@neratec.com>
MIME-Version: 1.0
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
CC: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH] Improve passive scanning: check not only for proberesp_ies
 but also for beacon_ies
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     Improve passive scanning: check not only for proberesp_ies but also 
for beacon_ies
     Without this improvement, it always attempts to send a probe 
request (which it's not allowed) and then wait for auth_data->timeout.

     The log without patch:
     Jan  1 02:48:03 (none) kern.info kernel: [10084.062491] wlan0: 
authenticate with 04:f0:21:02:46:93
     Jan  1 02:48:03 (none) kern.info kernel: [10084.064933] wlan0: 
direct probe to 04:f0:21:02:46:93 (try 1/3)
     Jan  1 02:48:04 (none) kern.info kernel: [10084.078417] wlan0: send 
auth to 04:f0:21:02:46:93 (try 2/3)
     Jan  1 02:48:04 (none) kern.info kernel: [10084.079363] wlan0: 
authenticated
     Jan  1 02:48:04 (none) kern.info kernel: [10084.082648] wlan0: 
associate with 04:f0:21:02:46:93 (try 1/3)
     Jan  1 02:48:04 (none) kern.info kernel: [10084.083726] wlan0: RX 
AssocResp from 04:f0:21:02:46:93 (capab=0x11 status=0 aid=1)

     The log with patch:
     Jan  1 02:46:25 (none) kern.info kernel: [ 9985.696798] wlan0: 
authenticate with 04:f0:21:02:46:53
     Jan  1 02:46:25 (none) kern.info kernel: [ 9985.699234] wlan0: send 
auth to 04:f0:21:02:46:53 (try 1/3)
     Jan  1 02:46:25 (none) kern.info kernel: [ 9985.700211] wlan0: 
authenticated
     Jan  1 02:46:25 (none) kern.info kernel: [ 9985.702583] wlan0: 
associate with 04:f0:21:02:46:53 (try 1/3)
     Jan  1 02:46:25 (none) kern.info kernel: [ 9985.703624] wlan0: RX 
AssocResp from 04:f0:21:02:46:53 (capab=0x11 status=0 aid=1)


Signed-off-by: Matthias May <matthias.may@neratec.com>
---
  net/mac80211/mlme.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2a4f78..fae5f9c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2817,7 +2817,7 @@ static int ieee80211_probe_auth(struct 
ieee80211_sub_if_data *sdata)

         drv_mgd_prepare_tx(local, sdata);

-       if (auth_data->bss->proberesp_ies) {
+       if (auth_data->bss->proberesp_ies || auth_data->bss->beacon_ies) {
                 u16 trans = 1;
                 u16 status = 0;

-- 
Matthias May
Software Engineer

Neratec Solutions AG
Postfach 83, CH-8608 Bubikon, Switzerland
Direct: +41 55 253 2074
Office: +41 55 253 2000
Fax:    +41 55 253 2070
email:  matthias.may@neratec.com
Web:   www.neratec.com

