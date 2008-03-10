Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYCJO5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 10:57:08 -0400
Subject: Re: reproducible association with wrong essid, iwl3945
From: Dan Williams <dcbw@redhat.com>
To: Helge Hafting <helgehaf@mail.aitel.hist.no>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47D508A5.6090805@mail.aitel.hist.no>
References: <47D508A5.6090805@mail.aitel.hist.no>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 10:53:21 -0400
Message-Id: <1205160801.3347.35.camel@localhost.localdomain> (sfid-20080310_145713_611409_0786AD66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-10 at 11:08 +0100, Helge Hafting wrote:
> Get a normal association so the network works. (WEP encryption)
> $ iwconfig wlan0 nonexistent_essid key s:correct_key
> 
> The network keeps working!  I would expect the driver to look
> for an access point with the different essid, and fail
> if no such access point exists.
> Two different networks with the same encryption string is possible, 
> after all.

Should definitely fail, disassociate, and send the SIOCSIWAP event with
00:00:00:00:00:00 via wireless_send_event().

Dan


