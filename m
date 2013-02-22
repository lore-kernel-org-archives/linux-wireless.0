Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1214 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab3BVNcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 08:32:55 -0500
From: "Piotr Haber" <phaber@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
Date: Fri, 22 Feb 2013 13:32:23 +0000
Message-ID: <53E0CDA8188165468B8B837459C34CA901053EEA@SJEXCHMB15.corp.ad.broadcom.com> (sfid-20130222_143302_006875_F3E66BB8)
References: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
 <1361524092-4814-2-git-send-email-phaber@broadcom.com> (
 sfid-20130222_100804_524805_03F665CB),<1361533924.8146.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361533924.8146.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> From: Johannes Berg [johannes@sipsolutions.net]
>> Sent: Friday, February 22, 2013 12:52 PM
>> To: Piotr Haber
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth coexistence mode

>On Fri, 2013-02-22 at 10:08 +0100, Piotr Haber wrote:
>> Some devices share antenna/analog front end between Wifi
>> and Bluetooth. The hardware coexistence interface allows
>> them to do so, but there are situations when it would
>> be beneficial if software had a way to have influence on it
>> as well. It can be used to protect time sensitive
>> traffic in presence of Bluetooth voice stream,
>> for an example EAPOL handshake or DHCP negotiation.
>>
>> This patch adds new attribute to SET_WIPHY command
>> and a new field in struct wiphy to allow control of the
>> coexistence behavior. Devices that do not share resources
>> with Bluetooth can ignore this parameter.

> Apart from a few minor technical comments that I'll omit for now, I'm
> not sure what value this really has? EAPOL can already be "protected" by
> way of knowing when the station is marked authorized, and DHCP is pretty
> tricky because it could take "forever", might not be there at all, etc.
By "protect" I meant give Wifi a priority over BT so these time sensitive things 
can finish quicker/on first try, limiting the possibility of dropping packets because of BT 
using the medium.
This is supposed to be temporary and time limited, so if say DHCP finishes in the window 
we give it - great, if not the coexistence goes back to default behavior and Wifi traffic is
treated as usual. 

> What application would actually call this? I don't really see how it
> could be integrated like that.
For EAPOL wpa_supplicant might use it. For DHCP it could be used from enter/exit hooks
via iw or some other utility able to send nl messages.

This feature is styled after Android one.
There a Wifi state machine tries to "protect" DHCP traffic.
It uses extra wpa_supplicant command (DRIVER) with linked driver specific library.
Which means there can be only one wifi device and one needs to recompile wpa_supplicant 
to use another.
I wanted to make it more device independent.

Piotr




