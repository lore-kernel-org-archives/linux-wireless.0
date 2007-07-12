Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXGLDcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 23:32:31 -0400
Subject: Re: [PATCH 2.6] SoftMAC : fix duplicate display of channel in scan
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: jt@hpl.hp.com, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <4693DD18.1010905@lwfinger.net>
References: <20070710184155.GA6955@bougret.hpl.hp.com>
	 <4693DD18.1010905@lwfinger.net>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 23:30:17 -0400
Message-Id: <1184211018.9446.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-10 at 14:25 -0500, Larry Finger wrote:
> Jean,
> 
> Jean Tourrilhes wrote:
> > 	Hi,
> > 
> > 	SoftMAC output the channel twice in the scan output. It should
> > display frequency and channel, but only once for each.
> > --------------------------------------------------------
> >           Cell 02 - Address: A2:00:04:XX:XX:XX
> >                     ESSID:"TheESSID"
> >                     Protocol:IEEE 802.11b
> >                     Mode:Ad-Hoc
> > ->                  Channel:5
> > ->                  Frequency:2.432 GHz (Channel 5)
> 
> The frequency output is needed by NetworkManager, which is why I added it. At that time, I thought 
> that some tool or other might be scanning the output looking for "Channel:", not "Channel "; 
> therefore I left both in. If we are sure that removing the channel-only line will not break 
> something, I'll be happy to send your patch upstream.

Should fix NM, really, to deal with either channel or frequency and
handle each as appropriate.

Dan

> Larry
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

