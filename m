Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3LCKsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 05:48:07 -0500
Message-ID: <1386067682.4393.5.camel@jlt4.sipsolutions.net> (sfid-20131203_114810_996608_4C530AAE)
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Tue, 03 Dec 2013 11:48:02 +0100
In-Reply-To: <529DB560.40805@lri.fr>
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
	  <529DA7FB.6020600@lri.fr> <1386063957.4393.4.camel@jlt4.sipsolutions.net>
	 <529DB560.40805@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 11:41 +0100, Nicolas Cavallari wrote:
> On 03/12/2013 10:45, Johannes Berg wrote:
> > On Tue, 2013-12-03 at 10:44 +0100, Nicolas Cavallari wrote:
> >> On 02/12/2013 19:51, Johannes Berg wrote:
> >>> +			if (!ipv4_is_multicast(ip.hdr4.daddr))
> >>> +				return -1;
> >>
> >> So broadcasting to e.g. 192.168.255.255 is now forbidden ?
> > 
> > Please, read the patch :)
> 
> I read the patch further. ipv4_is_multicast only checks if the
> address is in 224/4, so this patch makes __ieee80211_data_to_8023
> returns 0 for 224.0.0.0 to 239.255.255.255, and returns -1 for
> everything else, including the 255.255.255.255, 192.168.255.255 and
> other limited broadcast addresses, which are actually indistinguishable
> from unicast addresses if you don't know the IP configuration.
> 
> If __ieee80211_data_to_8023 returns -1, the packet is dropped as
> being unusable -- no less.

You still haven't even begun to understand the patch. It only cares
about GTK-encrypted frames.

johannes

