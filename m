Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:56603 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaANPsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 10:48:46 -0500
Message-ID: <52D55C5C.8010402@broadcom.com> (sfid-20140114_164859_389054_8AD9D276)
Date: Tue, 14 Jan 2014 16:48:44 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wpa_supplicant and driver reload
References: <52A82A1D.80409@broadcom.com> <2323CBC6-B7B3-49FF-882F-66B9F0B9A879@w1.fi> <52AD7335.1090101@broadcom.com>
In-Reply-To: <52AD7335.1090101@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2013 10:15 AM, Arend van Spriel wrote:
> On 12/15/2013 06:46 AM, Jouni Malinen wrote:
>>
>> On 11 Dec 2013, at 1:02 am, Arend van Spriel <arend@broadcom.com> wrote:
>>
>>> A basic questionIn my testing I normally stop wpa_supplicant when
>>> reloading my driver and start it again, but I was wondering whether
>>> this is needed. Can wpa_supplicant deal with interface index change
>>> for the network interface?
>>
>> Yes, it can.
>>
>> (Did you not try it before asking? Or did it fail in some way?)
> 
> It failed. On my Ubuntu machine it works fine, but it seems
> NetworkManager does give explicit RemoveInterface and CreateInterface
> dbus primitives. When running wpa_supplicant without NetworkManager it
> fails and it seems to be using the previous if_index. I will give
> another stare the wpa_s log and send it out when I can not make sense of
> it.

Found the problem in the way brcmfmac does cleanup upon unload. With
that fixed I notice some other behaviour. After 3 driver reloads (within
1 minute) wpa_supplicant requests a scheduled scan. I fixed that by
resetting wpa_s->normal_scans to zero upon entering
WPA_INTERFACE_DISABLED state. The only thing left is that after each
reload the delay before requesting a scan increases with 1 second. This
is caused by the fact that in wpa_supplicant_driver_init() the delay is
determined by a static counter that increments upon each call (if there
are enabled networks). I think this is mainly intended for wpa_s startup
so scans for each interface are not colliding. Not sure what the best
way is to solve that.

Regards,
Arend
