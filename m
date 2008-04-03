Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:42666 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbYDCKlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:41:13 -0400
Received: by wr-out-0506.google.com with SMTP id c48so2227069wra.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 03:41:12 -0700 (PDT)
Message-ID: <1ba2fa240804030341v7d1c20ecva35cc169095deb3d@mail.gmail.com> (sfid-20080403_114421_573216_6369E0A3)
Date: Thu, 3 Apr 2008 13:41:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
Cc: Chr <chunkeey@web.de>, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1207218083.3636.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200804012145.18294.chunkeey@web.de>
	 <1207128858.10910.19.camel@johannes.berg>
	 <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com>
	 <1207218083.3636.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 3, 2008 at 1:21 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  > >  On Tue, 2008-04-01 at 21:45 +0200, Chr wrote:
>  > >  > This patch is necessary for the upcoming Accesspoint patch for p54.
>  > >
>  > >  Hm. I don't like increasing the tx control structure size but I guess
>  > >  you really need that :)
>
>
> > Not sure why this cannot be bookeeped in the driver.
>  > Upon association AID is delivered to driver, so every packet that will
>  > be sent to this AP has this AID?
>
>  We're talking about AP mode, and afaict to do that in the driver you'd
>  have to have a hash table from sta MAC -> AID.

I see, AP mode is different story and in second thought it think we
can use this to speed up TX path
also for iwliwfi, we waste significant time on searching for STA based
on MAC address.
So it's ACK from me. Thanks for opening my eyes :)

Another question is if there will be more info needed for station in the driver.
Currently in iwlwifi we have STA representation, this is HW
requirement but some data are kept twice in iwlwifi and mac.
The question is whether STA mac80211 representation cannot be more
accessible to the driver?  Not sure how this can be done
without over complicated station book keeping.


Thanks
Tomas.
