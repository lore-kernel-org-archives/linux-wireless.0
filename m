Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54443 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbbK0JoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 04:44:10 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?Q?Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>
Subject: Re: [PATCH v2 6/8] cfg80211: reg: Add NL80211_RRF_USER_REGD_NEEDED flag
In-Reply-To: <1448613316.2531.13.camel@sipsolutions.net>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz> <1448303241-27747-7-git-send-email-sojkam1@fel.cvut.cz> <1448613316.2531.13.camel@sipsolutions.net>
Date: Fri, 27 Nov 2015 10:43:59 +0100
Message-ID: <87si3r22w0.fsf@steelpick.2x.cz> (sfid-20151127_104415_814161_3C2AB1B0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 27 2015, Johannes Berg wrote:
> On Mon, 2015-11-23 at 19:27 +0100, Michal Sojka wrote:
>> 
>> The NL80211_RRF_USER_REGD_NEEDED flag introduced in this commit
>> allows
>> drivers to specify that certain band is enabled only if it is
>> additionally enabled in user-supplied regulatory database. If the
>> band
>> is not present there, the channels are simply disabled.
>
> I can see why you'd want this flag internally (although it'll require
> rework given the comments on the previous patch) - but is there a
> reason to export it in nl80211?

I don't see any reason either. Only all regulatory rule flags
(nl80211_reg_rule_flags) happen to be "exported". Shall I add new field
(e.g. internal_flags) to struct ieee80211_reg_rule and define new enum
for it?

> Then again, perhaps it *would* be good to show this information in
> userspace?

What do you mean by "show"? nl80211_put_regdom() already sends regdom
flags to userspace. Or do you mean introducing a new channel attribute
and send it in nl80211_msg_put_channel()?

-Michal
