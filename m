Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:42313 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZFWICH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 04:02:07 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Proposal enquiry for Wireless Roaming feature enhancement
Date: Tue, 23 Jun 2009 10:01:29 +0200
Cc: Kalle Valo <kalle.valo@iki.fi>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Balaji Ravindran <b@w1an.in>,
	Mircea Gherzan <mgherzan@gmail.com>
References: <4A38672F.9090904@w1an.in> <1245681796.4338.24.camel@dhcp-100-3-98.bos.redhat.com> <87k534nwy3.fsf@litku.valot.fi>
In-Reply-To: <87k534nwy3.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200906231001.29728.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Can you tell anything about the configuration parameters
> available? For example, can the driver configure an rssi
> threshold for enabling background scanning[1]?

Orinoco and WLAGS Hermes1 and Hermes2 has some "sensitivy" 
setting, from 1..3:

$ iwconfig eth1 sens 3

What exactly this does is a bit opaque and handled by the 
firmware.




Madwifi does roaming OK, here we have many iwpriv settings that 
can be used to fine-tune this:

$ iwpriv eth1 bgscan 0
$ pre-up iwpriv eth1 rssi11g 26
$ pre-up iwpriv eth1 rssi11b 26

But this isn't exactly the driver, but their own 802.11 
implementation.
