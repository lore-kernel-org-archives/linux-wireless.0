Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55129 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaCUJcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 05:32:42 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so1569557eek.23
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 02:32:41 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 0/8] ath10k: refactor htt_rx path
Date: Fri, 21 Mar 2014 10:32:13 +0100
Message-Id: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140321_103248_430209_97CFAE85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset remove htt_rx_info and intoduce usage
of ieee80211_rx_status template. Introduce calculation
split for per-ppdu and per-mpdu. Remove not needed
calculation we did before for each mpdu. Before we
did calculation for each mpdu and in case of heavy
traffic we could have eg. 15mpdus in one ppdu.

This ieee80211_rx_status template will be also required
to fix rates, rssi we will report to mac80211. I will
send this patches soon.

First two patches - no functional changes.

Tested on AP135, didn't notice any TP drop with this patchset.

Base on:
[PATCH 1/2] ath10k: add ath10k_htt_rx_amsdu_allowed function
[PATCH 2/2] ath10k: Fill per-ppdu info in rx_info only once
I send before.

Please review.

Janusz Dziedzic (8):
  ath10k: move rx related functions to htt_rx.c
  ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
  ath10k: introduce ieee80211_rx_status to htt_rx_info
  ath10k: setup rx channel per ppdu
  ath10k: kill not needed fields from htt_rx_info
  ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
  ath10k: improve way we play with attention flags
  ath10k: finally kill htt_rx_info

 drivers/net/wireless/ath/ath10k/htt.h    |   18 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  440 ++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/txrx.c   |  183 -------------
 drivers/net/wireless/ath/ath10k/txrx.h   |    1 -
 4 files changed, 299 insertions(+), 343 deletions(-)

-- 
1.7.9.5

