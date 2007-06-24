Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXFXLsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 07:48:07 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: wmm_acm setting
Date: Sun, 24 Jun 2007 14:47:40 +0300
Message-ID: <D0122E209EBF8D4CAB38EC6A8AF244E502BCD5AC@hasmsx412.ger.corp.intel.com>
From: "Cohen, Guy" <guy.cohen@intel.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In mac80211/ieee80211_sta.c, ieee80211_sta_wmm_params(), line ~267, is
wmm_acm setting for case 1 (BK) and case 0 (BE) right (and not swapped)?

Regards,
Guy.


		switch (aci) {
		case 1:
			queue = IEEE80211_TX_QUEUE_DATA3;
			if (acm) {
				local->wmm_acm |= BIT(0) | BIT(3);
			}
			break;
		case 2:
			queue = IEEE80211_TX_QUEUE_DATA1;
			if (acm) {
				local->wmm_acm |= BIT(4) | BIT(5);
			}
			break;
		case 3:
			queue = IEEE80211_TX_QUEUE_DATA0;
			if (acm) {
				local->wmm_acm |= BIT(6) | BIT(7);
			}
			break;
		case 0:
		default:
			queue = IEEE80211_TX_QUEUE_DATA2;
			if (acm) {
				local->wmm_acm |= BIT(1) | BIT(2);
			}
			break;
		}

