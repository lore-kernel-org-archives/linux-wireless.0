Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37322 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932960AbeFTIpT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:45:19 -0400
Message-ID: <1529478069.3130.1.camel@sipsolutions.net> (sfid-20180620_104525_661966_DC831A36)
Subject: Re: [BUG] mac80211: Using smp_processor_id() in preemptible code:
 iwd
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>
Cc: "McGinn, Dan" <dan.mcginn@imperial.ac.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Jun 2018 09:01:09 +0200
In-Reply-To: <C7853888-5B20-4695-BD6F-4438B7ADF58D@gmail.com> (sfid-20180620_050502_120486_A63637FB)
References: <DB5PR06MB106451FE83810B8A129CE1E4A47C0@DB5PR06MB1064.eurprd06.prod.outlook.com>
         <1529065843.10037.22.camel@sipsolutions.net>
         <C7853888-5B20-4695-BD6F-4438B7ADF58D@gmail.com>
         (sfid-20180620_050502_120486_A63637FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-06-19 at 22:04 -0500, Denis Kenzior wrote:
> 
> Right, but you’re much more aware of all the locking issues than I am.

:-)

> > Clearly this comes from cfg80211 without any locking other than rtnl, so
> > you don't have preemption disabled. That's the minimum needed to get rid
> > of the warning you found.
> 
> In my defense, I did ask you whether there are any potential locking
> issues in the RFC and you didn’t think there were any.

Yep, I missed that too. More precisely, ISTR actually thinking about it
and deciding it was fine, so ... my bad for sure.

> I posted a fix for this.  Could you please review?

I think it's fine. I'll make a pass later today/this week and send
patches upstream.

johannes
