Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62920 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755796AbaLWKU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 05:20:58 -0500
Message-ID: <1419330055.30945.76.camel@x220> (sfid-20141223_112132_178464_CBB7E17F)
Subject: Re: [PATCH RFC] ipw2200: select CFG80211_WEXT
From: Paul Bolle <pebolle@tiscali.nl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 23 Dec 2014 11:20:55 +0100
In-Reply-To: <871tnqhn7j.fsf@kamboji.qca.qualcomm.com>
References: <1419271817.2317.12.camel@tiscali.nl>
	 <871tnqhn7j.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-12-23 at 08:52 +0200, Kalle Valo wrote:
> Paul Bolle <pebolle@tiscali.nl> writes:
> 
> > Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
> > made it impossible to depend on CFG80211_WEXT. It does still allow to
> > select that symbol. (Yes, the commit summary is confusing.)
> >
> > So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
> > built again.
> 
> I think the last sentence is a bit misleading (this isn't a compilation
> error, right?)

No, it's not a compilation error.

The reasoning here is that all code hidden behind a Kconfig symbol that
cannot be set will, in practice, never be built. Sure, there are hoops
one can jump through to try to bypass the generated .config, but no one
should have to do that.

>  and I would like to clarify it like this:
> 
> "So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
> enabled in config again."
> 
> Does that look ok?

I understand the confusion my text might cause, so I'm fine with your
amendment.

Thanks,


Paul Bolle

