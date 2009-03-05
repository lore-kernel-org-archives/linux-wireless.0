Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50104 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbZCETNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 14:13:06 -0500
Message-ID: <49B02425.5030005@candelatech.com> (sfid-20090305_201321_705998_F5BB2D26)
Date: Thu, 05 Mar 2009 11:12:37 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: pat-lkml@erley.org
CC: Dan Williams <dcbw@redhat.com>,
	Alexey Yudichev <ayudichev@yahoo.co.uk>,
	"Christoph .J Thompson" <cjsthompson@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com> <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com> <20090304232625.cc47eb46.cjsthompson@gmail.com> <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com> <49AF077D.2020408@erley.org> <1236253402.31456.8.camel@localhost> <041a41424b1a9851b471a7a3b794dc47@127.0.0.1>
In-Reply-To: <041a41424b1a9851b471a7a3b794dc47@127.0.0.1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pat-lkml@erley.org wrote:

>>> I don't know if it's intended, or just not implemented, but iwconfig
>>> <iface> mode master
>>> won't work with mac80211 drivers.  Hostapd knows how to set master mode
>>> on it's own.
>> Hostapd needs to be used for master mode in *any* case.  So yes, its
>> intended that you need hostapd for master mode with mac80211 drivers.
>> Just switching the card to master mode simply won't work, because
>> there's oh-so-much-more setup required in addition to that, which
>> hostapd knows how to do.
>>
>> Dan
> 
> Thanks for confirming this.  It was what I understood to be the case, 
> and what experimentation had shown, but I was not sure if it was by 
> design, or just not implemented yet.

Seems like iwconfig should have a more useful error message,
telling users to use hostapd for this particular driver,
instead of just a generic error...

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

