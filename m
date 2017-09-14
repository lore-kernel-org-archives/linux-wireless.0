Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:50834 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbdINUFT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 16:05:19 -0400
Received: by mail-io0-f182.google.com with SMTP id w94so3396992ioi.7
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 13:05:19 -0700 (PDT)
Subject: Re: ROAM/CONNECT event with PORT_AUTHORIZED
To: Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1505378361.31630.2.camel@sipsolutions.net>
 <e4a3ab99-f49a-0849-56d7-71ce19b1f323@broadcom.com>
 <1505389462.31630.6.camel@sipsolutions.net>
 <e418234f-00a0-dd44-7352-d279f49f83e5@gmail.com>
 <1505416658.31630.15.camel@sipsolutions.net>
 <9219316a-5556-6acf-30de-e9aa65a05706@gmail.com>
 <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <c2a820c4-f169-6a4d-13f3-3df323f1556a@gmail.com> (sfid-20170914_220523_377189_29946CB9)
Date: Thu, 14 Sep 2017 15:05:15 -0500
MIME-Version: 1.0
In-Reply-To: <6d0ad07b-ca89-19a1-d3c2-ad94915b942a@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,
>
> There are different meanings for 'roam'.  Are you just talking about
> fast-transition roaming?
> 

I'm using 'roam' as any transition between BSSes in the same 
SSID/Security type.  So regular re-association, pre-authenticated 
association, fast transition.

> I would think that the decision to restart DHCP (at least ipv4) should
> be in user-space.  I'm less sure about how IPv6 should deal with this.
> 
> I have tested roaming using FT and normal-ish wpa_supplicant without
> doing DHCP, and it works fine.  Of course, it also works if you
> choose to re-do DHCP.
> 

Our thinking on this was to assume that DHCP parameters are still valid 
after a roam, but re-confirm them just in case.  If the confirmation 
fails, then we can fall back to requesting a new DHCP lease.

Regards,
-Denis
