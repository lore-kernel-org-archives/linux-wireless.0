Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45161 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaEGL5d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:57:33 -0400
Message-ID: <536A1FA9.7010404@broadcom.com> (sfid-20140507_135737_326204_4316A38D)
Date: Wed, 7 May 2014 13:57:29 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: scheduled scan api
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I received a couple of reports from people who got problem with brcmfmac 
when a scheduled scan is requested, without any ssid specified. 
Currently, brcmfmac basically rejects the request. So what are valid 
usage scenarios for scheduled scans with respect to the n_ssid, 
n_channels, and n_matchsets. In the kernel doc below it says a 
zero-length ssid means 'no match'. I suppose it means any ssid which 
signal is above RRSI threshold will match.

Regards,
Arend
---8<----------------------------------------------------------
/**
  * struct cfg80211_match_set - sets of attributes to match
  *
  * @ssid: SSID to be matched; may be zero-length for no match (RSSI only)
  * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
  */
