Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:50408 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbXCUEdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 00:33:47 -0400
Received: from thot.informatik.uni-kl.de (thot.informatik.uni-kl.de [131.246.166.35])
	by mailgw1.uni-kl.de (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id l2L4CqNI018015
	for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2007 05:12:52 +0100
Date: Wed, 21 Mar 2007 05:12:52 +0100
From: Joerg Mayer <jmayer@loplof.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Message-ID: <20070321041252.GB10005@thot.informatik.uni-kl.de>
References: <20070318101535.251183750@warmcat.com> <200703190156.07984.flamingice@sourmilk.net> <45FE6C02.5050605@warmcat.com> <200703191250.47929.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200703191250.47929.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 19, 2007 at 12:50:42PM -0400, Michael Wu wrote:
> > I googled for radiotap specs but I didn't find anything useful.  I added
> > some small code to enforce the alignment rules you mention above.
> >
> I got the information on padding from:
> http://madwifi.org/wiki/DevDocs/RadiotapHeader
>
> I don't remember how I managed to find that, but there it is.

The packet-radiotap.c in Wireshark has the following comments:

/* Written with info from:
 *
 * http://madwifi.org/wiki/DevDocs/RadiotapHeader
 * NetBSD's ieee80211_radiotap.h file
 */

/*
 * The NetBSD ieee80211_radiotap man page
 * (http://netbsd.gw.com/cgi-bin/man-cgi?ieee80211_radiotap+9+NetBSD-current)
 * says:
 *
 *    Radiotap capture fields must be naturally aligned.  That is, 16-, 32-,
 *    and 64-bit fields must begin on 16-, 32-, and 64-bit boundaries, respec-
 *    tively.  In this way, drivers can avoid unaligned accesses to radiotap
 *    capture fields.  radiotap-compliant drivers must insert padding before a
 *    capture field to ensure its natural alignment.  radiotap-compliant packet
 *    dissectors, such as tcpdump(8), expect the padding.
 */

Ciao
     Joerg
--
Joerg Mayer                                           <jmayer@loplof.de>
We are stuck with technology when what we really want is just stuff that
works. Some say that should read Microsoft instead of technology.

