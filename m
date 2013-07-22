Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtava1.carestreamhealth.com ([205.173.211.14]:45316 "EHLO
	ashop0009.corp.carestreamhealth.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751830Ab3GVMWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:22:17 -0400
Message-ID: <51ED23F5.5030702@carestream.com> (sfid-20130722_142221_811729_D8111631)
Date: Mon, 22 Jul 2013 08:22:13 -0400
From: "greg.huber" <greg.huber@carestream.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	daniel.wagner@oss.bmw-carit.de, Dan Williams <dcbw@redhat.com>
Subject: Re: Wake-On-Wireless and Deauthentication
References: <51E6DE4D.50902@carestream.com> <CAB=NE6UPz=6NuCMvy5FEM9QBg9rhwFTw0mG2YVTX3r3dLG=1cQ@mail.gmail.com> <51E9800C.8040007@carestream.com> <51EABFCA.4060307@broadcom.com>
In-Reply-To: <51EABFCA.4060307@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend, Thank You.

I was able to disable NetworkManager and wpa_supplicant and then
restarted the supplicant manually. The system did not disconnect when
suspended, but it would not wake up on magic packet (what I set it to).
On resume it again disconnected and reconnected however.

I put a WOW compatible NIC in my laptop and will do some more
testing. I also need to verify that the wake packets are making it
onto the air.

Thank you for all your help.

Greg

On 07/20/2013 12:50 PM, Arend van Spriel wrote:
> On 07/19/13 20:06, greg.huber wrote:
>> Thank you for your reply, I'm trying this now.
>>
>> Greg
>>
>> On 07/18/2013 09:38 PM, Luis R. Rodriguez wrote:
>>> On Wed, Jul 17, 2013 at 11:11 AM, greg.huber<greg.huber@carestream.com>  wrote:
>>>> I'm trying to get Wake-on-wireless working with an Atheros AR9462.
>>>> The problem I seem to be having is that there is a Deauth requested
>>>> when the system is suspended. Does anyone know how to keep the
>>>> association while suspended?? I'm using kernel 3.9.9.
>>>>
>>>> The log after waking (from keyboard)
>>>>
>>>> [  320.117062] wlp3s0: deauthenticating from 00:24:01:12:de:7a by local choice
>>>> (reason=3)
>>> Typical managers for networking will disassociate you (and therefore
>>> deauth first) prior to kicking the system to suspend. To test WoW you
>>> need to run the supplicant manually because as far as I can tell the
>>> GUI managers don't consider if WoW was enabled or not. In such a case
>>> that WoW was enabled the GUI managers should not send the
>>> deauth/disassoc.
>
> There has been recent commit, which may affect you:
>
> commit 8125696991194aacb1173b6e8196d19098b44e17
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Thu Feb 28 10:55:25 2013 +0100
>
>     cfg80211/mac80211: disconnect on suspend
>
> It is mentioning something about wowlan so I am not sure whether it does. As
> you are on 3.9.9 I guess you do not have this commit.
>
> Regards,
> Arend
>
>

