Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50806 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZLWTTz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 14:19:55 -0500
MIME-Version: 1.0
In-Reply-To: <1261595489.27798.0.camel@johannes.local>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<20091222193010.GB30201@bombadil.infradead.org> <1261570081.25008.1.camel@johannes.local>
	<20091223162813.GB2609@tux> <1261586828.7304.13.camel@johannes.local>
	<20091223190840.GI2609@tux> <1261595489.27798.0.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 23 Dec 2009 11:19:33 -0800
Message-ID: <43e72e890912231119l79ef5a99h6b57362e38f189ed@mail.gmail.com>
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
	issue and mac80211 suspend corner) case
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2009 at 11:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-12-23 at 11:08 -0800, Luis R. Rodriguez wrote:
>
>> So you want drivers to handle start() failures (even if its not for
>> resume) with an unregistration to mac80211?
>
> Not necessarily. If it's a temporary error, that's fine, of course, but
> if the hardware is suddenly inaccessible for whatever reason then yes,
> of course, unregistering is the only good choice no matter when it
> happens.

Reason for me suggesting for mac80211 to deal with this is drivers
won't know if their failed start() call will have been from resume and
we likely won't add a bool to start() callback since we already
debated this a while back.

I don't really care about hardware failures in other cases right now,
and do think resume is reasonable enough to check for and handle on
mac8021 alone. Since stop() would have stopped everything in the
driver and is documented as such I don't see why it would be
complicated to unregister it instead from mac80211.

  Luis
