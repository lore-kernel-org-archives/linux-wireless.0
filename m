Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47374 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdINUIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 16:08:53 -0400
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Denis Kenzior <denkenz@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
 <1505389462.31630.6.camel@sipsolutions.net>
 <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
 <1505416658.31630.15.camel@sipsolutions.net>
 <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
 <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com>
 <c2a820c4-f169-6a4d-13f3-3df323f1556a@gmail.com>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5436d106-0b4a-9158-58bf-ff84b231cd19@candelatech.com> (sfid-20170914_220857_288012_FFCC7E3D)
Date: Thu, 14 Sep 2017 13:08:53 -0700
MIME-Version: 1.0
In-Reply-To: <c2a820c4-f169-6a4d-13f3-3df323f1556a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2017 01:05 PM, Denis Kenzior wrote:
> Hi Ben,
>>
>> There are different meanings for 'roam'.  Are you just talking about
>> fast-transition roaming?
>>
>
> I'm using 'roam' as any transition between BSSes in the same SSID/Security type.  So regular re-association, pre-authenticated association, fast transition.
>
>> I would think that the decision to restart DHCP (at least ipv4) should
>> be in user-space.  I'm less sure about how IPv6 should deal with this.
>>
>> I have tested roaming using FT and normal-ish wpa_supplicant without
>> doing DHCP, and it works fine.  Of course, it also works if you
>> choose to re-do DHCP.
>>
>
> Our thinking on this was to assume that DHCP parameters are still valid after a roam, but re-confirm them just in case.  If the confirmation fails, then we can
> fall back to requesting a new DHCP lease.

How do you re-confirm them?  There are definitely cases where SSID/Security is the same but each
AP has its own DHCP server and roaming between them will require getting a new DHCP address (on
the same (NAT'd) subnet and with same gateway, likely as not).

Thanks,
Ben

>
> Regards,
> -Denis
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
