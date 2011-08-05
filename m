Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55296 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1HEIPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 04:15:14 -0400
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Don't use a buf_size=0 in ADDBA requests
References: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com>
	<1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 05 Aug 2011 11:15:12 +0300
In-Reply-To: <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com> (Helmut Schaa's message of "Tue\, 26 Jul 2011 12\:18\:28 +0200")
Message-ID: <878vr8s29b.fsf@purkki.adurom.net> (sfid-20110805_101520_390742_D36EDCC7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> According to 802.11-2007, 7.3.1.14 it is compliant to use a buf_size of
> 0 in ADDBA requests. But some devices (AVM Fritz Stick N) arn't able to
> handle that correctly and will reply with an ADDBA reponse with a
> buf_size of 0 which in turn will disallow BA sessions for these
> devices.
>
> To work around this problem, if the hardware doesn't specify an upper
> limit for the number of subframes in an AMPDU send the maximum 0x40 by
> default in ADDBA requests.

[...]

> @@ -345,7 +345,9 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
>  	/* send AddBA request */
>  	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
>  				     tid_tx->dialog_token, start_seq_num,
> -				     local->hw.max_tx_aggregation_subframes,
> +				     local->hw.max_tx_aggregation_subframes ?
> +				     local->hw.max_tx_aggregation_subframes :
> +				     0x40,
>  				     tid_tx->timeout);

A define would be better than a magic value. This would also need a
comment but if you choose a good name for the define the comment won't
be needed. Also " ? :" inside a function call is not readable IMHO,
maybe instead a separate variable with if() statements?

-- 
Kalle Valo
