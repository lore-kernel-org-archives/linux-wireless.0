Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:51061 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753148Ab2FTI4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:56:06 -0400
Received: by lbbgj10 with SMTP id gj10so302627lbb.9
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 01:56:02 -0700 (PDT)
Message-ID: <1340182559.1631.208.camel@cumari.coelho.fi> (sfid-20120620_105609_697217_482DE9EF)
Subject: Re: [PATCH v2] mac80211: initialize sta pointer to avoid
 false-positive warning
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tony@atomide.com
Date: Wed, 20 Jun 2012 11:55:59 +0300
In-Reply-To: <1340182340.4655.46.camel@jlt3.sipsolutions.net>
References: <1340023971-9754-1-git-send-email-coelho@ti.com>
	 <1340182340.4655.46.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 10:52 +0200, Johannes Berg wrote:
> On Mon, 2012-06-18 at 15:52 +0300, Luciano Coelho wrote:
> > Some compilers (eg. gcc 4.4.1 for ARM) report a false positive warning
> > in mlme.c:
> > 
> > net/mac80211/mlme.c: In function 'ieee80211_prep_connection':
> > net/mac80211/mlme.c:3035: warning: 'sta' may be used uninitialized in this function
> > 
> > This is a false positive because the place where 'sta' is used is
> > inside an if with the same condition of where it is set:
> 
> I still think it's a workaround, but what the hell ... applied.

Yes, it is a workaround, but a lean one.  :) And I think after your
suggestion it makes the code slightly more readable.

Thanks for applying!

BTW, when you say you applied, does it mean you have pushed to your
tree? We want to remove some of our mac80211 patches from our internal
trees and "inherit" them from upstream instead, that's why I'm
asking. ;)

--
Luca.

