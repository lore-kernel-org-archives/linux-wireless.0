Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168Ab3JQSdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 14:33:54 -0400
Message-ID: <1382035171.22901.13.camel@dcbw.foobar.com> (sfid-20131017_203357_086786_DED09499)
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe
 frequency ranges(s)
From: Dan Williams <dcbw@redhat.com>
To: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>
Date: Thu, 17 Oct 2013 13:39:31 -0500
In-Reply-To: <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAD14@nasanexd01a.na.qualcomm.com>
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1382020835.14410.16.camel@jlt4.sipsolutions.net>
	  <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAD14@nasanexd01a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 17:46 +0000, Chauhan, Rajesh wrote:
> Hi Johannes,
> 
> Let me also replace SAP with SoftAP.
> 
> So now commit text would be:
> 
> cfg80211/nl80211: Add API to report frequency range(s) to be avoided
> 
> Add support for WLAN driver to report frequency range(s) to be avoided because of interference. If SoftAP/P2P-GO is operating on interfering frequency then user space should stop and restart them avoiding interfering frequency range(s). User space may decide to continue operation on interfering frequency, but in such case, there might be impact on performance.

Wouldn't a better interface be to:

a) provide a list of undesirable frequencies at all times, instead of an
event, so that userspace can decide *before* creating a Soft AP or P2P
which is the best channel to use, if it wants.  Possibly through the
same mechanisms that it's other capabilities are exposed through (like
the full list of supported frequencies, eg "iw phy phy0 info").

Driver can update this list at any time if it notices changes to the RF
environment.

b) if the current operating channel for some Soft AP or P2P interface
becomes undesirable, emit an event indicating that this channel is
undesirable.  Userspace can then decide to continue operating on that
channel, or it can check the list of "undesirable" channels from (a) and
pick a different one, and move to it.  This is essentially your current
patch, but the event need not carry the channel list, since that's
exposed by (a) already.

There is a small race between a client reading (a) and a client creating
the SoftAP/P2P interface, so it would also be useful that if the channel
a client is creating the SoftAP/P2P on is undesirable the event gets
emitted immediately after creation.

My issue with the original patch is that it only defines the event, it
doesn't define a mechanism for the client to get this information
*before* doing the operation that may be undesirable.

Dan

> Regards,
> Rajesh Chauhan
> 
> 
> -----Original Message-----
> From: Chauhan, Rajesh 
> Sent: Thursday, October 17, 2013 10:20 AM
> To: 'Johannes Berg'
> Cc: linux-wireless@vger.kernel.org; Rodriguez, Luis; Malinen, Jouni; Bahini, Henri; Chang, Leo; Luo, Xun; Chauhan, Rajesh
> Subject: RE: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency ranges(s)
> 
> Hi Johannes,
> 
> Thanks for your comment. Purpose of this patch is to add an API for WLAN driver to report frequency ranges which should be avoided for SAP/P2P-GO because of interference.
> 
> How about if I reword commit test as below?
> 
> cfg80211/nl80211: Add API to report frequency range(s) to be avoided
> 
> Add support for WLAN driver to report frequency range(s) to be avoided because of interference. If SAP/P2P-GO is operating on interfering frequency then user space should stop and restart them avoiding interfering frequency range(s). User space may decide to continue operation on interfering frequency, but in such case, there might be impact on performance.
> 
> Regards,
> Rajesh Chauhan
> 
> 
> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net]
> Sent: Thursday, October 17, 2013 7:41 AM
> To: Chauhan, Rajesh
> Cc: linux-wireless@vger.kernel.org; Rodriguez, Luis; Malinen, Jouni
> Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency ranges(s)
> 
> On Wed, 2013-10-16 at 21:57 -0700, Rajesh Chauhan wrote:
> > Add support for WLAN driver to report unsafe frequency range(s). 
> 
> Why?
> 
> > User
> > space should move SAP/P2P-GO out of those unsafe frequency range(s).
> > User space may decide to continue operation on unsafe frequency but in 
> > such case there might be impact on performance because of interference.
> 
> SAP? I don't think SAP will move - they're pretty stuck in Walldorf :P
> 
> This is pretty strange patch, and very little justification.
> 
> "Unsafe" is also a really bad word.
> 
> johannes
> 
> NrybXǧv^)޺{.n+{*ޕ,{ayʇڙ,jfhzwj:+vwjmzZ+ݢj"!


