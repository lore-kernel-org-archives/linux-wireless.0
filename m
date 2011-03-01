Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45060 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab1CATOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 14:14:15 -0500
Subject: Re: [PATCH] lib-average: Make config option selectable
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1299006479.6015.22.camel@jlt3.sipsolutions.net> (sfid-20110301_200804_242695_0DA7AFA8)
References: <1299006185.28897.5.camel@marge>
	 <1299006479.6015.22.camel@jlt3.sipsolutions.net>
	 (sfid-20110301_200804_242695_0DA7AFA8)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 20:14:08 +0100
Message-ID: <1299006848.28897.9.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 20:07 +0100, Johannes Berg wrote:
> On Tue, 2011-03-01 at 20:03 +0100, Michael Buesch wrote:
> > Make CONFIG_AVERAGE selectable for out-of-tree users
> > such as compat-wireless.
> 
> Is that really necessary? We haven't typically done this, and often just
> shipped the code in compat instead?

Well, there are a lot more options in lib that do this (The help text is
copied from the others).

compat-wireless does include a backport of the
function, but only for <=2.6.37. So from .38 on
compat-wireless expects the option to be enabled.
Which is unfortunate, because it's impossible to
enable without enabling something else that SELECTs
it. I hit this situation in OpenWRT.

-- 
Greetings, Michael.

