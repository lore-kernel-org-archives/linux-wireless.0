Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54058 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HEIiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 04:38:01 -0400
Received: by fxh19 with SMTP id 19so2593523fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Aug 2011 01:38:00 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Re: [PATCH 2/2] mac80211: Don't use a buf_size=0 in ADDBA requests
Date: Fri, 05 Aug 2011 10:35:39 +0200
Message-ID: <4365125.pkzJgJtRz2@helmutmobil.site> (sfid-20110805_103818_530933_F8D5427B)
In-Reply-To: <878vr8s29b.fsf@purkki.adurom.net>
References: <1311675508-29005-1-git-send-email-helmut.schaa@googlemail.com> <1311675508-29005-2-git-send-email-helmut.schaa@googlemail.com> <878vr8s29b.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 5. August 2011, 11:15:12 schrieb Kalle Valo:
> Helmut Schaa <helmut.schaa@googlemail.com> writes:
> 
> > According to 802.11-2007, 7.3.1.14 it is compliant to use a buf_size of
> > 0 in ADDBA requests. But some devices (AVM Fritz Stick N) arn't able to
> > handle that correctly and will reply with an ADDBA reponse with a
> > buf_size of 0 which in turn will disallow BA sessions for these
> > devices.
> >
> > To work around this problem, if the hardware doesn't specify an upper
> > limit for the number of subframes in an AMPDU send the maximum 0x40 by
> > default in ADDBA requests.
> 
> [...]
> 
> > @@ -345,7 +345,9 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
> >  	/* send AddBA request */
> >  	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
> >  				     tid_tx->dialog_token, start_seq_num,
> > -				     local->hw.max_tx_aggregation_subframes,
> > +				     local->hw.max_tx_aggregation_subframes ?
> > +				     local->hw.max_tx_aggregation_subframes :
> > +				     0x40,
> >  				     tid_tx->timeout);
> 
> A define would be better than a magic value. This would also need a
> comment but if you choose a good name for the define the comment won't
> be needed.

And we even have such a define in ieee80211.h already ;)

	#define IEEE80211_MAX_AMPDU_BUF 0x40

> Also " ? :" inside a function call is not readable IMHO,
> maybe instead a separate variable with if() statements?

Hmm, in this particular case it looks like overkill to me to use a
separate variable.

So, I'll respin this one with s/0x40/IEEE80211_MAX_AMPDU_BUF

Thanks,
Helmut
