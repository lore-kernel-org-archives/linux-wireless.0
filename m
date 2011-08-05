Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48090 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab1HEIyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 04:54:39 -0400
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Don't use a buf_size=0 in ADDBA requests
References: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com>
	<1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com>
	<878vr8s29b.fsf@purkki.adurom.net>
	<4365125.pkzJgJtRz2@helmutmobil.site>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 05 Aug 2011 11:54:34 +0300
In-Reply-To: <4365125.pkzJgJtRz2@helmutmobil.site> (Helmut Schaa's message of "Fri\, 05 Aug 2011 10\:35\:39 +0200")
Message-ID: <874o1ws0fp.fsf@purkki.adurom.net> (sfid-20110805_105442_945438_5E80DAD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

>> Also " ? :" inside a function call is not readable IMHO,
>> maybe instead a separate variable with if() statements?
>
> Hmm, in this particular case it looks like overkill to me to use a
> separate variable.

To me it's overkill to optimise few lines with the cost of
readibility. Example:

ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
                        tid_tx->dialog_token, start_seq_num,
                        local->hw.max_tx_aggregation_subframes ?
                        local->hw.max_tx_aggregation_subframes :
                        IEEE80211_MAX_AMPDU_BUF,
                        tid_tx->timeout);

vs.

ampdu_len = local->hw.max_tx_aggregation_subframes

if (ampdu_len == 0)
        ampdu_len = IEEE80211_MAX_AMPDU_BUF;

ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
                        tid_tx->dialog_token, start_seq_num,
                        ampdu_len,
                        tid_tx->timeout);

So only three lines more (plus the variable declaration) but the code
is simpler to read because the if statement is not embedded to the
function call parameters.

But as always, people have different views about coding styles :)

-- 
Kalle Valo
