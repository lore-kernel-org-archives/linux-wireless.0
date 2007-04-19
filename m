Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:1506 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766831AbXDSPv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 11:51:27 -0400
Message-ID: <46278FEB.50203@canonical.com>
Date: Thu, 19 Apr 2007 09:51:07 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Fix NetworkManager/wpa_supplicant race condition
References: <462649E3.4000208@canonical.com>	 <1176916954.20244.14.camel@localhost.localdomain>	 <46266EF9.3050001@canonical.com> <1176951852.3207.1.camel@localhost.localdomain>
In-Reply-To: <1176951852.3207.1.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:

snip, snip

> 
> When I say "reassociate", I mean a new association cycle to the _same_
> BSSID/SSID using the settings that are current at that point in time.  I
> guess I should have made that clear.
> 
> Dan
> 
>> A quick look at ieee80211_ioctl_siwessid() shows that it always forces
>> an authentication cycle.
>>
>> I'll experiment a little to see how the Softmac can be driven through an
>> authentication/association cycle on calls to SIOCSIWESSID or SIOCSIWAP.
>>
>> rtg

Dan,

I agree that driving the SoftMAC protocol through an auth/assoc cycle
when changing ESSID or BSSID is architecturally the right thing to do.
However, the required changes are a bit too extensive for me to add to a
recently released kernel (Feisty).  I'll have to get back to this when I
have more freedom to whack and slash.

In the meantime, I still think emitting an ASSOC event is a good interim
fix. I'll be testing it over the next few days within the Ubuntu community.

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com
