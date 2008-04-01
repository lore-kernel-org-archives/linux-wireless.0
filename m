Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14776 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYDANdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 09:33:22 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
Date: Tue, 1 Apr 2008 15:30:21 +0200
Cc: Marc Pignat <marc.pignat@hevs.ch>, linux-wireless@vger.kernel.org
References: <200803261021.48470.hs4233@mail.mn-solutions.de> <200804010848.48789.hs4233@mail.mn-solutions.de> <200804010943.56075.marc.pignat@hevs.ch>
In-Reply-To: <200804010943.56075.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804011530.21466.hs4233@mail.mn-solutions.de> (sfid-20080401_143327_080178_C2182717)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 April 2008 09:43:55 Marc Pignat wrote:
> Hi all!
>
> On Tuesday 01 April 2008, Holger Schurig wrote:
> > > Won't this call block? You can't block in the get_wireless
>
> ...
>
> > Do you see a way around this?
>
> what do you think about that:
> * store RSSI with it's associated time (ktime or jiffies?)
> * when the RSSI is requested, send the request message to the
> wireless card (and don't wait for the response), and return
> the old RSSI if not too old, else return -ERESTARTSYS.
>
> The ioctl should be re-called when we return -ERESTARTSYS, (at
> least I hope so).

That's not possible. The wireless_stats aren't handled like the 
other wext IOCTLs, see network/wireless/wext.c, function 
iw_handler_get_iwstats(). The driver can only return NULL or a 
struct iw_statistics *, but not an -ERESTARTSYS.
