Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:40867 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYIPIvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:51:18 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Tue, 16 Sep 2008 10:50:41 +0200
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Helmut Schaa <hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de> <1221491952.10177.65.camel@localhost.localdomain> <87fxo0zee1.fsf@nokia.com>
In-Reply-To: <87fxo0zee1.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809161050.41482.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 September 2008 10:25:10 Kalle Valo wrote:

>> My main problem is that adding a beacon threshold to mac80211 
>> isn't a

> Still I don't see a problem here, all the mac80211 drivers
> should already now report similar signal strenght to the
> mac80211 in comparable level.

And we could later allow something similar to "iwconfig ethX sens 
Y" to modify the the threshold (or whatever else we use, even 
some arbitrary calculated quality value). The possibility to 
modify this would allow the user to define how eager mac80211 is 
when it comes to roaming.


I actually believe that we shouldn't use Quality as roaming 
decision base. From what I know, Quality also counts in 
re-transmissions, transfer speed (1 MBit/s is worse then 54 
MBit/s) and whatever else. Therefore you can calculate quality 
only for the current conection. 

But when you scan, you only see signal strength and/or SNR of the 
APs in sight. You won't know their quality of those APs.

But you could compare your current signal strength and/or SNR to 
the signal strength/SNR of the APs in sight.



That would mean that you can use the Quality still for a 
decision "Should I do a background scan or not?". But you cannot 
use it for a decision "Should I switch to this AP or not?".

And so I wonder why I should use quality in the first place if it 
brings me only so far ...
