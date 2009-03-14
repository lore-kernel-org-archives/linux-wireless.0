Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:52548 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbZCNRdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:33:51 -0400
Message-ID: <49BBEA60.6070702@nokia.com> (sfid-20090314_183352_573096_BC691F09)
Date: Sat, 14 Mar 2009 19:33:20 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlagn: default to MAX_UCODE_BEACON_INTERVAL	in	iwl_adjust_beacon_interval
References: <154E55ADF9629D4E8D13F08BF92ABEB629C9D28B8D@PDSMSX501.ccr.corp.intel.com>	 <20090220145223.GA15006@tuxdriver.com> <1235155966.5860.44.camel@rc-desk>	 <20090220194306.GA4051@tuxdriver.com> <20090221003013.GA3890@tuxdriver.com>	 <20090221003133.GB3890@tuxdriver.com>	 <1235443093.4455.77.camel@johannes.local>	 <20090225014454.GA3577@tuxdriver.com>	 <1237046388.5235.82.camel@johannes.local>  <49BBE4A0.3060901@nokia.com> <1237050872.5235.95.camel@johannes.local>
In-Reply-To: <1237050872.5235.95.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-03-14 at 19:08 +0200, Kalle Valo wrote:
>> Johannes Berg wrote:
>>> Kalle, I suspect that your beacon offload will require something like
>>> holding on to BSS structs too, is that correct?
>> My current solution is just to disable beacon filtering (and power save) 
>> whenever we are scanning. That way beacon filtering doesn't interfere 
>> scanning in anyway.
> 
> That makes sense, but disabling beacons means that
> 
> 	iwlist wlan0 scan last
> 
> will not show _any_ BSS while associated, but it should really show the
> BSS we're associated to. This is the problem I was referring to.

Oh man, I wasn't even aware of this feature. So yes, my patches 
definitely need a way to hold bss structs. I need to study the 
implementation more before I can comment.

(Dropping the ipw3945 list from CC, it bugs me about not being subscribed.)

Kalle
