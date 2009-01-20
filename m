Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:41186 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZATWzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 17:55:23 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1610123ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 14:55:21 -0800 (PST)
Message-ID: <43e72e890901201455k7fe7e953la6f808391a07e5ed@mail.gmail.com> (sfid-20090120_235528_012771_8260B999)
Date: Tue, 20 Jan 2009 14:55:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Cc: "Kyle McMartin" <kyle@infradead.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Paul Hickey" <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	"Kyle McMartin" <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090120223707.GA5988@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20090119191138.GA4018@tesla> <20090120000336.GB4018@tesla>
	 <1232433738.3696.3.camel@localhost.localdomain>
	 <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com>
	 <20090120201316.GG19581@tesla> <20090120201613.GA5313@kroah.com>
	 <20090120211630.GJ19581@tesla>
	 <20090120220810.GE17452@bombadil.infradead.org>
	 <20090120223707.GA5988@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 2:37 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 20, 2009 at 05:08:10PM -0500, Kyle McMartin wrote:
>>
>> *sigh* I don't know, and don't really want to argue about it. ;-) People
>> with backports are pretty much always going to get screwed. What's the
>> use case for wireless-testing backports? bugfixes or new features? Could
>> we improve the stable process to help wireless stuff get into 2.6.$(x-1)
>> more easily so this won't happen in the future?
>
> I don't think we want to start adding entire new drivers to the -stable
> releases, which is what the wireless backport stuff is for, right?

Amongst a good amount of other things, yes, getting new drivers is one
reason for it. compat-wireless allows users of stable series to get
bleeding edge updates on the wireless subsystem. Sometimes this may
mean even non-oops fixes to drivers or mac80211 which may be too big
to be merged into the stable release series. Basically anything that
John maintains on his wireless-testing tree get pulled into the
compat-crap except the ancient drivers. Another reason for it is that
if you want a bleeding edge mac80211 driver, say foo you will also
need bleeding edge mac80211 and cfg80211 and since iwlwifi and ath9k
drivers depend on mac80211 and cfg80211 as well for example, so we
just provide backport work for all mac80211 drivers. This should
prevent vendors from doing nutty things like pushing their own version
of mac80211, say foo_mac80211, for their own drivers which can cause
divergence and patch hogging through unintended forks.

>That
> would really be adding new features, which is not the goal.

Sure.

  Luis
