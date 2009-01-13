Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:54786 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbZAMXJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 18:09:41 -0500
Received: by yw-out-2324.google.com with SMTP id 9so127065ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 15:09:39 -0800 (PST)
Message-ID: <43e72e890901131502u5484bdc5t6059e82cf4aac8e5@mail.gmail.com> (sfid-20090114_000957_064093_8AD377EC)
Date: Tue, 13 Jan 2009 15:02:11 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 07/12] cfg80211: allow driver read access to cfg80211_regdomain
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1231887238.3728.8.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
	 <1231886819.3728.2.camel@johannes> <20090113225112.GT4416@tesla>
	 <1231887238.3728.8.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 2:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-13 at 14:51 -0800, Luis R. Rodriguez wrote:
>> On Tue, Jan 13, 2009 at 02:46:59PM -0800, Johannes Berg wrote:
>> > On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
>> > > A driver's reg_notfier() may want to inspect the currently set
>> > > regulatory domain.
>> >
>> > > +const struct ieee80211_regdomain *cfg80211_regdomain;
>> > > +EXPORT_SYMBOL(cfg80211_regdomain);
>> >
>> > Can't we just pass it to the notifier instead of exporting it?
>>
>> I as thinking about that too, sure, either or is fine. Any preference?
>
> I prefer not exporting it. That makes it more local, and saves the
> export. Not that I see why we need it at all? You're not using it, so
> let's not do anything with it until we need it.

Actually -- you're right, I thought we needed in the reg_notifier()
but freq_reg_info() was used instead. Hmm, brain fart I guess. Good
catch.

  Luis
