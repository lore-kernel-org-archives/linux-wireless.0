Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56366 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752742AbcILGl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 02:41:57 -0400
Message-ID: <1473662509.4201.0.camel@sipsolutions.net> (sfid-20160912_084202_742284_FBA547D6)
Subject: Re: [PATCH 2/3] ath10k:  Grab rcu_read_lock before the txqs
 spinlock.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 12 Sep 2016 08:41:49 +0200
In-Reply-To: <57D2CB92.3020407@candelatech.com> (sfid-20160909_164754_211937_A51918C3)
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
         <1471569995-10028-2-git-send-email-greearb@candelatech.com>
         <87k2elp53z.fsf@kamboji.qca.qualcomm.com>
         <57D2CB92.3020407@candelatech.com> (sfid-20160909_164754_211937_A51918C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > -	rcu_read_unlock();
> > >   	spin_unlock_bh(&ar->txqs_lock);
> > > +	rcu_read_unlock();
> > 
> > I'm no RCU expert but this isn't making any sense. Maybe it changes
> > timings on your kernel so that it hides the real problem?
> 
> I'm not sure this fixed anything or not, it just seemed weird so I
> changed it.
> 
> I was hoping someone that understood rcu locking would comment...
> 

RCU is no "locking". The sooner you get over that notion, the better.

This therefore make no sense whatsoever.

In fact, you want to keep the RCU protected section *small*, so having
the spinlock inside hurts overall system performance.

johannes
