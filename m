Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58291 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbcFIIj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 04:39:59 -0400
Message-ID: <1465461594.3442.7.camel@sipsolutions.net> (sfid-20160609_104007_839805_F27295C4)
Subject: Re: [PATCH] nl80211: avoid possible memleak on nl80211_set_reg
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	Eduardo Abinader <eabinader@ocedo.com>,
	linux-wireless@vger.kernel.org
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>
Date: Thu, 09 Jun 2016 10:39:54 +0200
In-Reply-To: <a961b2ee-b4fa-dec9-72ed-f9b600fa51b2@broadcom.com> (sfid-20160609_103604_383463_C1E1294A)
References: <1465224967-26892-1-git-send-email-eduardo.abinader@riverbed.com>
	 <1465459080.3442.2.camel@sipsolutions.net>
	 <a961b2ee-b4fa-dec9-72ed-f9b600fa51b2@broadcom.com>
	 (sfid-20160609_103604_383463_C1E1294A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > +++ b/net/wireless/nl80211.c
> > > @@ -5839,10 +5839,11 @@ static int nl80211_set_reg(struct sk_buff
> > > *skb, struct genl_info *info)
> > >  
> > >  	r = set_regdom(rd, REGD_SOURCE_CRDA);
> > >  	/* set_regdom took ownership */
> > > -	rd = NULL;
> > >  
> > >   bad_reg:
> > >  	kfree(rd);
> > > +	rd = NULL;
> > To this I can only say: what?
> The patch is bad, but the confusion starts with the original code
> (ab)using kfree() behaviour by setting rd to NULL. Personally, I do
> not like it, but prefer it over bugs ;-)
> 

Yeah, fair enough. I'll make the following patch:

-	r = set_regdom(rd, REGD_SOURCE_CRDA);
-	/* set_regdom took ownership */
-	rd = NULL;
+	/* set_regdom takes ownership of rd */
+	return set_regdom(rd, REGD_SOURCE_CRDA);

johannes
