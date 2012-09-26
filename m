Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab2IZLxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 07:53:07 -0400
Message-ID: <1348660422.10548.10.camel@jlt4.sipsolutions.net> (sfid-20120926_135311_685606_7DBB71B1)
Subject: Re: [PATCH v2] mac80211: VHT peer STA caps
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Sep 2012 13:53:42 +0200
In-Reply-To: <5062736B.9060008@posedge.com>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF5269@mbx022-e1-nj-10.exch022.domain.local>
	   <1348477154.10257.2.camel@jlt4.sipsolutions.net>
	   <50614089.6020105@posedge.com>
	  <1348557902.10041.17.camel@jlt4.sipsolutions.net>
	  <50617E2C.6050000@posedge.com>
	 <1348582152.10041.36.camel@jlt4.sipsolutions.net>
	 <5062736B.9060008@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-26 at 08:45 +0530, Mahesh Palivela wrote:
> On 09/25/2012 07:39 PM, Johannes Berg wrote:
> >
> > Well imagine you have a driver for some hardware that can do
> > beamforming, and the same driver can also work with hardware that
> > doesn't. If we restrict remote caps, like we do for HT, the driver
> > doesn't have to worry about this but can just do whatever the remote
> > caps say is possible. If we don't restrict it, the driver has to also
> > check its own caps.
> 
> you mean to say some drivers which dont provide its own VHT caps, will 
> use remote STA VHT caps as its own?
> If so I feel not correct posing remote STA caps as local caps.

No, no. If you look at HT, then you'll see that if the driver has HT but
isn't capable of doing everything the peer STA can do, then mac80211
restricts tells the driver only about the peer capabilities that the
device can do as well.

I agree that this isn't really necessary and can be rather complex in
VHT, but I think you need to document the difference very clearly in the
documentation for the ieee80211_sta VHT caps.

johannes

