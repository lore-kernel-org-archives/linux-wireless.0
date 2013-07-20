Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4528 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab3GTQuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 12:50:23 -0400
Message-ID: <51EABFCA.4060307@broadcom.com> (sfid-20130720_185033_984593_046F0826)
Date: Sat, 20 Jul 2013 18:50:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "greg.huber" <greg.huber@carestream.com>
cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	daniel.wagner@oss.bmw-carit.de, "Dan Williams" <dcbw@redhat.com>
Subject: Re: Wake-On-Wireless and Deauthentication
References: <51E6DE4D.50902@carestream.com>
 <CAB=NE6UPz=6NuCMvy5FEM9QBg9rhwFTw0mG2YVTX3r3dLG=1cQ@mail.gmail.com>
 <51E9800C.8040007@carestream.com>
In-Reply-To: <51E9800C.8040007@carestream.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/13 20:06, greg.huber wrote:
> Thank you for your reply, I'm trying this now.
>
> Greg
>
> On 07/18/2013 09:38 PM, Luis R. Rodriguez wrote:
>> On Wed, Jul 17, 2013 at 11:11 AM, greg.huber<greg.huber@carestream.com>  wrote:
>>> I'm trying to get Wake-on-wireless working with an Atheros AR9462.
>>> The problem I seem to be having is that there is a Deauth requested
>>> when the system is suspended. Does anyone know how to keep the
>>> association while suspended?? I'm using kernel 3.9.9.
>>>
>>> The log after waking (from keyboard)
>>>
>>> [  320.117062] wlp3s0: deauthenticating from 00:24:01:12:de:7a by local choice
>>> (reason=3)
>> Typical managers for networking will disassociate you (and therefore
>> deauth first) prior to kicking the system to suspend. To test WoW you
>> need to run the supplicant manually because as far as I can tell the
>> GUI managers don't consider if WoW was enabled or not. In such a case
>> that WoW was enabled the GUI managers should not send the
>> deauth/disassoc.

There has been recent commit, which may affect you:

commit 8125696991194aacb1173b6e8196d19098b44e17
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Feb 28 10:55:25 2013 +0100

     cfg80211/mac80211: disconnect on suspend

It is mentioning something about wowlan so I am not sure whether it 
does. As you are on 3.9.9 I guess you do not have this commit.

Regards,
Arend

