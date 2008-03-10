Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from embla.aitel.hist.no ([158.38.50.22]:39981 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbYCJUpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 16:45:09 -0400
Message-ID: <47D59ECE.3010303@mail.aitel.hist.no> (sfid-20080310_204541_889283_B7847C24)
Date: Mon, 10 Mar 2008 21:49:18 +0100
From: Helge Hafting <helgehaf@mail.aitel.hist.no>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: reproducible association with wrong essid, iwl3945
References: <47D508A5.6090805@mail.aitel.hist.no> <1205160801.3347.35.camel@localhost.localdomain>
In-Reply-To: <1205160801.3347.35.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Mon, 2008-03-10 at 11:08 +0100, Helge Hafting wrote:
>   
>> Get a normal association so the network works. (WEP encryption)
>> $ iwconfig wlan0 nonexistent_essid key s:correct_key
>>
>> The network keeps working!  I would expect the driver to look
>> for an access point with the different essid, and fail
>> if no such access point exists.
>> Two different networks with the same encryption string is possible, 
>> after all.
>>     
>
> Should definitely fail, disassociate, and send the SIOCSIWAP event with
> 00:00:00:00:00:00 via wireless_send_event().
>
>   
Instead it works for hours - but if I try wireshark it
puts the interface in promiscuous mode - and sets it normal again
when the sniffing is done. Then the network dies, perhaps the
inerface state change also took the wrong essid into account. Or
maybe it just didn't like the switch from promiscuous mode.

Running with the wrong essid will sometimes cause
slow networking with lots of "too short packets" rejected.



Helge Hafting

