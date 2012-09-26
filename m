Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab2IZRxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 13:53:22 -0400
Message-ID: <1348682036.10548.13.camel@jlt4.sipsolutions.net> (sfid-20120926_195326_733826_EFDC6E26)
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Sep 2012 19:53:56 +0200
In-Reply-To: <506339C3.40405@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
	    <1348477154.10257.2.camel@jlt4.sipsolutions.net>
	    <50614089.6020105@posedge.com>
	   <1348557902.10041.17.camel@jlt4.sipsolutions.net>
	   <50617E2C.6050000@posedge.com>
	  <1348582152.10041.36.camel@jlt4.sipsolutions.net>
	  <5062736B.9060008@posedge.com>
	 <1348660422.10548.10.camel@jlt4.sipsolutions.net>
	 <506339C3.40405@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-26 at 22:52 +0530, Mahesh Palivela wrote:
> On 9/26/2012 5:23 PM, Johannes Berg wrote:
> >> you mean to say some drivers which dont provide its own VHT caps, will
> >> use remote STA VHT caps as its own?
> >> If so I feel not correct posing remote STA caps as local caps.
> >
> > No, no. If you look at HT, then you'll see that if the driver has HT but
> > isn't capable of doing everything the peer STA can do, then mac80211
> > restricts tells the driver
> 
> Sorry. Where is it telling the driver? I couldn't find this part of code 
> in mac80211, could you point me?

Well struct ieee80211_sta is what the driver uses. That's where it's
"telling" the driver, by making the data accessible to the driver. Your
new vht_cap field there is also "telling the driver" that way.


> > I agree that this isn't really necessary and can be rather complex in
> > VHT, but I think you need to document the difference very clearly in the
> > documentation for the ieee80211_sta VHT caps.
> 
> Can this go as different patch? take my v2 patch as framework. More 
> implementation of vht.c at later point of time?

I don't think this makes sense, since we're talking only about a
documentation change to your patch. See:

  * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
+ * @vht_cap: VHT capabilities of this STA

The difference is that you don't say "restricted to own", but I think
you should explicitly say that it isn't restricted.

johannes

