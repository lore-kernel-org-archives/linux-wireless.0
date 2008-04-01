Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:20278 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYDAGvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 02:51:46 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Marcelo Tosatti <marcelo@kvack.org>
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
Date: Tue, 1 Apr 2008 08:48:48 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
References: <200803261021.48470.hs4233@mail.mn-solutions.de> <1206653042.21106.10.camel@localhost.localdomain> <20080401031530.GA14633@dmt>
In-Reply-To: <20080401031530.GA14633@dmt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804010848.48789.hs4233@mail.mn-solutions.de> (sfid-20080401_075154_554327_C3EBB4E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Won't this call block? You can't block in the get_wireless
> handler (it holds the rtnl lock). See wext_handle_ioctl.

Yes, this blocks.

So you mean that when I cannot get a current RSSI value at this 
time I have to re-use some old value?  The older code used this 
schema:


when associated:
   get rssi in-the-background and store it away

when AdHoc network created:
   get rssi in-the-background and store it away


in lbs_get_wireless_stats()
   use stored away RSSI value
   get rssi in-the-background and store it away
   

The problem with this scheme is that the "stored away RSSI" might 
be an hour ago. So the first call to to get the wireless stats 
gives you back a blatant lie.

Do you see a way around this?
