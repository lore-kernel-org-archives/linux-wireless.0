Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:33038 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbbKZVLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 16:11:08 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?Q?Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>
Subject: Re: [PATCH v2 7/8] cfg80211: Add Kconfig option for ITS-G5 band (5.9 GHz)
In-Reply-To: <1448560529.2167.43.camel@sipsolutions.net>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz> <1448303241-27747-8-git-send-email-sojkam1@fel.cvut.cz> <1448560529.2167.43.camel@sipsolutions.net>
Date: Thu, 26 Nov 2015 22:10:58 +0100
Message-ID: <87d1uw31r1.fsf@steelpick.2x.cz> (sfid-20151126_221150_021191_F9C548E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26 2015, Johannes Berg wrote:
> On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
>> This option is meant for use by drivers and other subsystems to
>> enable
>> support for the Intelligent Transportation System (ITS-G5) band. The
>> option depends on CFG80211_CERTIFICATION_ONUS as the use of this band
>> is
>> restricted. EU allows using it only for certain applications, USA
>> require certification.
>
> Hm. Why do we need this now? I see that you're checking it in ath9k, to
> enable the "ITSG5" channels, but why wouldn't you always do that, now
> that you have the extra checks with the user regdb being required and
> all?

Because in [1] Jouni said that

   "kernel config option + custom regdb would certainly be much closer
   to what I'd like to see from the regulatory enforcement view point"

I also like the fact that the help text mentions the relevant regulatory
documents. I guess the users would appreciate that.

-Michal

[1] http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg13795.html
