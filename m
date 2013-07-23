Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtava1.carestreamhealth.com ([205.173.211.14]:33314 "EHLO
	ashop0009.corp.carestreamhealth.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933204Ab3GWSXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 14:23:37 -0400
Message-ID: <51EECA26.90500@carestream.com> (sfid-20130723_202341_092739_4538E473)
Date: Tue, 23 Jul 2013 14:23:34 -0400
From: "greg.huber" <greg.huber@carestream.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	daniel.wagner@oss.bmw-carit.de, Dan Williams <dcbw@redhat.com>
Subject: Re: Wake-On-Wireless and Deauthentication
References: <51E6DE4D.50902@carestream.com> <CAB=NE6UPz=6NuCMvy5FEM9QBg9rhwFTw0mG2YVTX3r3dLG=1cQ@mail.gmail.com> <51E9800C.8040007@carestream.com> <51EABFCA.4060307@broadcom.com>
In-Reply-To: <51EABFCA.4060307@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not working yet, here's an update

I'm running wireshark wireless and can decode the packets between the test laptop
and the AP. Once authenticated I can see the WoW magic-packet on the air.

On the laptop, I disabled the NetworkManager and wpa_supplicant in systemd and
run wpa_supplicant manually with an appropriate conf file. I see the association
and authentication on wireshark.

Again I can also see WoW magic-packets on the air.

I now put the laptop in suspend to ram. Neither wireshark nor the AP log record
any disconnect, but I no longer see the WoW magic-packets on the air.

After resuming from the keyboard I see a 4-way authentication cycle, a deauth
and  another 4-way. I can see the WoW magic-packets again on wireshark.

Can anyone suggest what I might be doing wrong, or something else to try?
Also, if it's system normal to deauth on suspend, can WoW ever work??

I'll pull down the latest RC kernel and give it a try.

Thank You again for your assistance.

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

