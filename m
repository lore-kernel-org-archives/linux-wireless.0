Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaCKKE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:04:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/14] ath10k: Refactor rx path little bit
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 11 Mar 2014 12:04:50 +0200
In-Reply-To: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 4 Mar 2014 13:52:13 +0100")
Message-ID: <87a9cxhwzh.fsf@kamboji.qca.qualcomm.com> (sfid-20140311_110502_560945_B6E3F3D3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Refactor rx path, mainly split/reduce calculation we
> did before. Now we caculate variable/flags only once
> per-ppdu, while before we did some calculations for
> each mpdu. Kill some not needed code and fill directly
> ieee80211_rx_status structure.
> TP veryfication required.
>
> Janusz Dziedzic (14):
>   ath10k: add ath10k_htt_rx_amsdu_allowed function
>   ath10k: Fill per-ppdu info in rx_info only once
>   ath10k: move rx related functions to htt_rx.c
>   ath10k: rename process_rx_rates to ath10k_htt_rx_h_rates
>   ath10k: introduce ieee80211_rx_status to htt_rx_info
>   ath10k: kill signal field in htt_rx_info
>   ath10k: setup rx channel per ppdu
>   ath10k: kill rate substruct and tsf from htt_rx_info
>   ath10k: kill fcs_err from htt_rx_info
>   ath10k: kill mic_err/amsdu_more from htt_rx_info
>   ath10k: kill status from htt_rx_info
>   ath10k: kill encrypt_type from htt_rx_info
>   ath10k: return error when ath10k_htt_rx_amsdu_pop() fail
>   ath10k: improve way we play with attention flags

I did now a quick review:

I didn't fully understand your idea with rx status template.

I think the patchset is too long, it will be easier if you split these
into two. First set with all the easy and obvious stuff and a second one
for the rx status template.

Some of the patches are missing commit logs. Even if the patch is
obvious, please write a small commit log. Just oneliner would be enough.

I would prefer the commit logs to answer more why the change is needed.

-- 
Kalle Valo
