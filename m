Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:32925 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXHTCca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 22:32:30 -0400
Message-ID: <46C8FD3C.9040804@lwfinger.net>
Date: Sun, 19 Aug 2007 21:32:28 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <200708140025.56708.chunkeey@web.de> <46C1638C.7070704@hhs.nl> <200708200244.22841.chunkeey@web.de>
In-Reply-To: <200708200244.22841.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Tuesday, 14. August 2007, Hans de Goede wrote:
> 
> Hans,
> 
> Any updates? Or are you on holiday?
> 
> I've prepared a patch, which should theoretically lower the excessive retry count.
> 
> however I don't think it will magically solve anything...
> 
> 
> OT: Michael/anyone else:
> 
> 1. Do you know why the rate algorithm (rc80211_simple) starts with the lowest speed?
>   or is this really only a p54 bug?

I cannot answer any other of your questions, but rc80211_simple starting at 1 Mbs is not a bug, it 
is a feature. The reason is that particular speed offers the greatest chance of authenticating and 
associating. It used to start at the highest rate and many systems would give up trying to connect 
before the rate was dropped to a point at which they could communicate. If the connection is really 
capable of higher speeds, it gets there very quickly.

Larry
