Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:13271 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100AbXIKHyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 03:54:37 -0400
Message-ID: <46E64935.9010905@gentoo.org>
Date: Tue, 11 Sep 2007 08:52:21 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Ulrich Kunitz <kune@deine-taler.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: zd-mac80211: Fix TX status reports.
References: <200709082341.31720.mb@bu3sch.de> <200709091259.00237.mb@bu3sch.de>	 <1189421542.4506.46.camel@johannes.berg>	 <200709101258.39619.mb@bu3sch.de>	 <1189422611.4506.58.camel@johannes.berg> <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
In-Reply-To: <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> Receiving all ACKs packets will degraded performance greatly for sure,
> even on PCI interface.
> Receving ACK can maybe allowed selectively only for management packets
> including EAPOLS in some synchronous way, yet this is still error
> prone.

I don't think we have such control. It's either all ACKs or no ACKs.

> It looks strange to me that there is no other HW mechanism that does that?
> Is this driver reverse engineered?

No. There is another mechanism for detecting failed transmissions: we 
get an interrupt for every failed TX. I feel that this should be enough 
to implement rate control, however mac80211 at the moment requires 
reports of both success and failure for rate control to work. Detecting 
success is the tricky part.

Daniel

