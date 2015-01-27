Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60669 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340AbbA0KYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 05:24:40 -0500
Message-ID: <1422354271.1890.62.camel@sipsolutions.net> (sfid-20150127_112501_686109_D83488D8)
Subject: Re: [RFCv4 3/3] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 11:24:31 +0100
In-Reply-To: <1422348243-4928-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150127_094518_689625_288E01DC)
References: <1422348243-4928-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1422348243-4928-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150127_094518_689625_288E01DC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 09:44 +0100, Janusz Dziedzic wrote:

> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
> +				const struct cfg80211_chan_def *chandef)

> +	/* 1 stream, MCS0-7 as a min Basic VHT MCS rates */
> +	vht_oper->basic_mcs_set = cpu_to_le16(0xfffc);

Unless I'm mistaken in my reading of the spec, this will make any
well-behaved client (i.e. not mac80211) not join this network since it
supports VHT MCSes.

We seem to do the same for HT:

        /* It seems that Basic MCS set and Supported MCS set
           are identical for the first 10 bytes */
        memset(&ht_oper->basic_set, 0, 16);
        memcpy(&ht_oper->basic_set, &ht_cap->mcs, 10);

but I'm not convinced it's right. It probably only works because nobody
ever tested against a well-behaved non-HT client? Or perhaps there isn't
even one?

I for one am not really comfortable with this restriction - there's very
little point in making such a restriction in IBSS since if you have it
then the other node will just form its own network on the same channel
and you've won nothing - only lost interoperability.

johannes

