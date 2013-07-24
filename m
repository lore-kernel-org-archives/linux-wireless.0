Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtava1.carestreamhealth.com ([205.173.211.14]:41841 "EHLO
	ashop0009.corp.carestreamhealth.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751323Ab3GXN4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 09:56:37 -0400
Message-ID: <51EFDD13.5070506@carestream.com> (sfid-20130724_155641_720827_38128A42)
Date: Wed, 24 Jul 2013 09:56:35 -0400
From: "greg.huber" <greg.huber@carestream.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	daniel.wagner@oss.bmw-carit.de, Dan Williams <dcbw@redhat.com>
Subject: Re: Wake-On-Wireless and Deauthentication
References: <51E6DE4D.50902@carestream.com> <CAB=NE6UPz=6NuCMvy5FEM9QBg9rhwFTw0mG2YVTX3r3dLG=1cQ@mail.gmail.com>
In-Reply-To: <CAB=NE6UPz=6NuCMvy5FEM9QBg9rhwFTw0mG2YVTX3r3dLG=1cQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I moved over to an ARM embedded proto board and was able to get further.
When suspended, the wireless card appears to stay awake and I can see the
WoW magic-packets as well as other traffic to that NIC. First problem is that
this is kernel 3.0.35 which I read does not yet support wake-on-wireless.

The second question that perhaps one of you can answer is whether or not
the external WAKE_EN# interrupt signal (pin 1 on a mPCIe card) is used to
resume the system, or is the PCIe interrupt expected to resume the system.
I scoped the WAKE_EN# signal but do not see any activity. I also looked at
later drivers,  I don't see this signal activated as an interrupt source, but
I'm still looking.

Thank You.

Greg

On 07/18/2013 09:38 PM, Luis R. Rodriguez wrote:
> On Wed, Jul 17, 2013 at 11:11 AM, greg.huber <greg.huber@carestream.com> wrote:
>> I'm trying to get Wake-on-wireless working with an Atheros AR9462.
>> The problem I seem to be having is that there is a Deauth requested
>> when the system is suspended. Does anyone know how to keep the
>> association while suspended?? I'm using kernel 3.9.9.
>>
>> The log after waking (from keyboard)
>>
>> [  320.117062] wlp3s0: deauthenticating from 00:24:01:12:de:7a by local choice
>> (reason=3)
> Typical managers for networking will disassociate you (and therefore
> deauth first) prior to kicking the system to suspend. To test WoW you
> need to run the supplicant manually because as far as I can tell the
> GUI managers don't consider if WoW was enabled or not. In such a case
> that WoW was enabled the GUI managers should not send the
> deauth/disassoc.
>
>   Luis
>

