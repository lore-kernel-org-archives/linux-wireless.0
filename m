Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:40338 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758973AbXEOGHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 02:07:47 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] mac80211: fail back to use associate from reassociate
Date: Mon, 14 May 2007 22:41:49 -0700
Message-ID: <9C9B2DC3D78A6142AC8D10C89669528603F63B68@msiexch01.marvell.com>
In-Reply-To: <1178767250.3045.36.camel@debian.sh.intel.com>
References: <20070509054152.GA30839@mail.intel.com> <20070509152855.GB941@devicescape.com> <1178767250.3045.36.camel@debian.sh.intel.com>
From: "Sandesh Goel" <sgoel@marvell.com>
To: "Zhu Yi" <yi.zhu@intel.com>, "Jouni Malinen" <jkm@devicescape.com>
Cc: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I would like to offer my 2 cents here.

While the proposed fix for this problem seems reasonable, I think the AP
behavior is definitely suspect. 

It is certainly legal for a STA to send a reassoc request to an AP with
which it has no existing association as long as the STA has an existing
association with some other AP within the same ESS. 

Therefore, the AP should not return the said error code
(WLAN_STATUS_REASSOC_NO_ASSOC) unless it has checked (using some inter
AP protocol) that no other AP in the ESS has an existing association
with the requesting STA. If the AP is returning the error without doing
this check, I would think that it is an AP bug. 

It would be interesting to know which AP behaves in this way and whether
is really does the check correctly or not. Note that the AP itself
having rebooted shouldn't cause this error code to be returned, which is
what I found strange.

Regards,
Sandesh

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Zhu Yi
Sent: Thursday, May 10, 2007 8:51 AM
To: Jouni Malinen
Cc: linux-wireless@vger.kernel.org; John W. Linville
Subject: Re: [PATCH] mac80211: fail back to use associate from
reassociate

On Wed, 2007-05-09 at 08:28 -0700, Jouni Malinen wrote:
> Can you please identify such an AP? This sounds like a workaround that
> makes the non-AP STA (client) behave in a way that does not match with
> IEEE 802.11 standard and in general, I'm against this change without a
> very good reason for it. 

I take it an error handling code. When an AP denies a STA reassociation
request with the reason "there is no previous association, why do you
send reassociation request to me?", this is an indication for the STA to
switch to association request and retry. Currently, mac80211 just try
reassociation over and over. The result is it can never associate with
the AP.

I don't see how it breaks the 802.11 standard. If you do, please point
it out and how are you going to fix this problem?

> This type of change would, e.g., break IEEE
> 802.11r fast transition which can only be done using reassociation. 

In .11r, can AP reject reassociation request if there is no previous
association from the same STA?

Thanks,
-yi
-
To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
