Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61294 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2K1QuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 11:50:00 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"mathias.kretschmer@fokus.fraunhofer.de"
	<mathias.kretschmer@fokus.fraunhofer.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>
Subject: Re: [ath9k-devel] [RFC 1/3] nl80211: add spec scan flag
Date: Wed, 28 Nov 2012 16:49:58 +0000
Message-ID: <8887AA04B7EC49479420AE48C5F94A930172CDA2@NASANEXD02D.na.qualcomm.com> (sfid-20121128_175013_167478_C81B77EF)
In-Reply-To: <20121128161219.GA6642@pandem0nium>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/28/12 8:12 AM, "Simon Wunderlich"
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

>Hmm, that would be possible as well ... Using the scan function is very
>convenient as I don't have to think about cycling, channel lists, etc.
>But putting more control to userspace is also possible, if we can ask the
>driver to just have a "quick spectral peek" on another channel.

Well, you may not need to think about channel cycling etc. for scan
operations, but you won't get much control over the timing or dwell
duration for that matter. Remain-on-channel gives you that.

>Anyway, you'd suggest to use the NL80211 remain on channel command for
>that?

Yes.

>Or add a new "spectral scan" nl80211 command to do a spectral scan on this
>(or multiple) channels, and use the various functions from
>mac80211/offchannel.c?

I would rather add a flag to the existing r-o-c command to indicate that
spectral scan functionality is to be enabled (well, assuming Johannes is
fine with this).

>BTW, is there any limitation to remain on channel commands, like will they
>work on AP ifaces, Ad-Hoc ifaces, MultiSSID in general, etc?

I hope not. There may be some practical issues with not all drivers
supporting this, but remain-on-channel is the mechanism we use for
supporting concurrent operations (e.g., P2P negotiations or GAS/ANQP) and
making this work in all combinations would be important regardless.

- Jouni

