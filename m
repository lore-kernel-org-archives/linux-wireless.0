Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbYIZOoD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 10:44:03 -0400
Subject: Re: Getting country alpha2 on network manager and using it for crda
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 10:43:38 -0400
Message-Id: <1222440218.19895.19.camel@localhost.localdomain> (sfid-20080926_164407_779457_AA0EB254)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-26 at 00:24 -0700, Luis R. Rodriguez wrote:
> So since this may not happen for a while I figure I can give a shot.
> But I'm curious where we should get our country alpha2 from? Does LSB
> define a country has to be somewhere? Maybe the locale? Timezone?
> Anyway, in the end the user should be able to change the country too.
> 
> I'm thinking to start by just letting the user pick a country for now.
> We can figure out where the hell it gets the country by default later
> but if you have ideas that'd be great. It seems reasonable to ask for
> this upon installation time (?)

My suggestion: use the current timezone as a fallback unless the user
has specified the locale somewhere.  That can obviously be done in NM or
lower, ideally we delegate this sort of thing to the supplicant and just
pass the alpha2 when NM adds the interface to the supplicant.  The
addInterface() call args are just a dict, so it would be trivial to add
another item in that dict for country code.  Since the country code is
global to the machine it's probably something we should just store in
the system settings service, and it's also something that probably
requires privileges to change.

Dan


