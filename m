Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50323 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbZAZTzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 14:55:51 -0500
Received: from localhost (perninha.conectiva.com.br [127.0.0.1])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 052993EB3
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 14:30:33 -0500 (EST)
Received: from perninha.conectiva.com.br ([127.0.0.1])
	by localhost (perninha.conectiva.com.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id 5WDeF2+yIeqm for <linux-wireless@vger.kernel.org>;
	Mon, 26 Jan 2009 14:30:32 -0500 (EST)
Received: from fox.conectiva (fox.conectiva [10.0.2.195])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 9FD1B3EAB
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 14:30:32 -0500 (EST)
Received: from gotham.conectiva (gotham.conectiva [10.0.2.23])
	by fox.conectiva (Postfix) with ESMTP id 2087D2F3F0
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 16:30:14 -0300 (BRT)
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: Invalid JP regulatory domain
Date: Mon, 26 Jan 2009 17:30:28 -0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901261730.29555.herton@mandriva.com.br> (sfid-20090126_205556_487714_77097A40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While trying to set JP as regulatory domain I get in my kernel log:
cfg80211: Calling CRDA for country: JP
cfg80211: Invalid regulatory domain detected:
cfg80211: Regulatory domain: JP
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (2474000 KHz - 2494000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (4910000 KHz - 4930000 KHz @ 10000 KHz), (N/A, 2300 mBm)
        (4910000 KHz - 4990000 KHz @ 40000 KHz), (N/A, 2300 mBm)
        (4930000 KHz - 4950000 KHz @ 10000 KHz), (N/A, 2300 mBm)
        (5030000 KHz - 5045000 KHz @ 10000 KHz), (N/A, 2300 mBm)
        (5030000 KHz - 5090000 KHz @ 40000 KHz), (N/A, 2300 mBm)
        (5050000 KHz - 5060000 KHz @ 10000 KHz), (N/A, 2300 mBm)
        (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
        (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2300 mBm)

Looks like the check "freq_range->max_bandwidth_khz > freq_diff" fails in 
net/wireless/reg.c (is_valid_reg_rule function) for the second and third 
ranges. Got this with wireless-regdb-2009-01-15 and kernel 2.6.28.1

Is there some error in regulatory domain ranges for JP, or kernel check 
missing something additional? I couldn't find proper information about the 
rules.

--
[]'s
Herton
