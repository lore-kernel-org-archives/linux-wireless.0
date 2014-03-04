Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:40355 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbaCDMwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 07:52:45 -0500
Received: by mail-ea0-f169.google.com with SMTP id h14so339285eaj.28
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2014 04:52:44 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 00/14] ath10k: Refactor rx path little bit
Date: Tue,  4 Mar 2014 13:52:13 +0100
Message-Id: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140304_135253_842505_007A8A5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor rx path, mainly split/reduce calculation we
did before. Now we caculate variable/flags only once
per-ppdu, while before we did some calculations for
each mpdu. Kill some not needed code and fill directly
ieee80211_rx_status structure.
TP veryfication required.

Janusz Dziedzic (14):
  ath10k: add ath10k_htt_rx_amsdu_allowed function
  ath10k: Fill per-ppdu info in rx_info only once
  ath10k: move rx related functions to htt_rx.c
  ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
  ath10k: introduce ieee80211_rx_status to htt_rx_info
  ath10k: kill signal field in htt_rx_info
  ath10k: setup rx channel per ppdu
  ath10k: kill rate substruct and tsf from htt_rx_info
  ath10k: kill fcs_err from htt_rx_info
  ath10k: kill mic_err/amsdu_more from htt_rx_info
  ath10k: kill status from htt_rx_info
  ath10k: kill encrypt_type from htt_rx_info
  ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
  ath10k: improve way we play with attention flags

 drivers/net/wireless/ath/ath10k/htt.h    |   15 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  436 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/txrx.c   |  183 -------------
 drivers/net/wireless/ath/ath10k/txrx.h   |    1 -
 4 files changed, 308 insertions(+), 327 deletions(-)

-- 
1.7.9.5

