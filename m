Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bandspeed.com ([24.227.171.243]:53002 "EHLO
	mars.bandspeed.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753167AbYJHPs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 11:48:56 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: HT capabilities IE
Date: Wed, 8 Oct 2008 10:33:42 -0500
Message-ID: <6EACAD9615B47B42A780C005414307E1014956B2@mars.bandspeed.com> (sfid-20081008_174900_688439_E17CECA3)
In-Reply-To: <1223460098.3618.53.camel@johannes.berg>
References: <1223460098.3618.53.camel@johannes.berg>
From: "Nils Bagge" <nbagge@bandspeed.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My humble opinion is yes, the HT capabilities field should be constant,
from the perspective of a typical AP.

Practically speaking, I doubt that an AP would want to toggle SM power
save at all, let alone on a per-beacon basis, as historically power
consumption is not as critical at the AP vs. at the client.

But, if you want to be 'green'... (I can see how this would benefit a
'low power AP') The only problem I see is with the AP entering 'static
SM power save'. You might run into interoperability trouble with varying
behavior of client STA's, due to different interpretations of the
standard or assumptions. It wouldn't surprise me if some clients ignore
changes to the HT capabilities IE once associated, or if some ignore the
SM power save field in beacons entirely. Hence, they could transmit a
2-stream MCS which would not be decodable with a single RX chain.

Theoretically, the only SM power save mode I'd recommend for an AP is
dynamic SM power save. 

Nils

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Johannes Berg
Sent: Wednesday, October 08, 2008 5:02 AM
To: linux-wireless
Cc: Tomas Winkler
Subject: HT capabilities IE

Hi,

quick question, I can't seem to read that from the draft, is the HT
capabilities IE supposed to be constant when, say, sent from an AP in
every beacon? Most fields look very constant, but e.g. the SM power save
mode might not be?

johannes
