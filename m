Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54483 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbcAMIYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 03:24:33 -0500
Message-ID: <1452673471.2191.2.camel@sipsolutions.net> (sfid-20160113_092437_648897_3AEFB536)
Subject: Re: Advice about otherbss monitor flag for Wireshark use
From: Johannes Berg <johannes@sipsolutions.net>
To: Mikael Kanstrup <mikael.kanstrup@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 13 Jan 2016 09:24:31 +0100
In-Reply-To: <CACZXzRCSnc_5vTBRVpX7Z1eY8JtAeeOux_UQknbRCvj5ysbAFQ@mail.gmail.com> (sfid-20160113_085813_855380_BD3C4A26)
References: <CACZXzRCSnc_5vTBRVpX7Z1eY8JtAeeOux_UQknbRCvj5ysbAFQ@mail.gmail.com>
	 (sfid-20160113_085813_855380_BD3C4A26)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-13 at 08:58 +0100, Mikael Kanstrup wrote:
> Hi,
> 
> Roger James reported that capturing wireless data on monitor
> interfaces created by Wireshark only capture frames to/from BSSID of
> the monitor interface. This was solved using iw by setting otherbss
> monitor flag. See Wireshark mailing list thread here:
> https://www.wireshark.org/lists/wireshark-dev/201601/msg00031.html
> 
> I suggested a patch to handle this within Wireshark:
> https://code.wireshark.org/review/#/c/13219
> 
> Now before merging I hope to get some feedback here if this is safe
> for the general case? For most users/drivers it appears explicitly
> setting the flag is not needed.
> 

It should be safe I think. However, it's really only necessary if the
monitor interface isn't the only interface in the system, and more
generally, if that's the case, monitoring may always be less reliable
(though very much depending on the driver.)

However, I'm not entirely happy with this patch (by default, and not
configurable) since we routinely use wireshark (and often tcpdump,
which isn't affected) to debug things where "otherbss" is *not* desired
since we really might *want* to have only packets from the BSS to debug
issues within, and to not affect the wifi NICs operation.

Could it perhaps be made configurable?

johannes
