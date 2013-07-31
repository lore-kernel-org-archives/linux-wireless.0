Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4912 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233Ab3GaIkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:40:39 -0400
Message-ID: <51F8CD45.6060108@broadcom.com> (sfid-20130731_104044_731316_3235E567)
Date: Wed, 31 Jul 2013 10:39:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Felix Fietkau" <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@redhat.com>,
	"John Greene" <jogreene@redhat.com>
Subject: Fwd: [Bug 989269] Connecting to WLAN causes kernel panic
References: <bug-989269-351310-C5h8dsuOxB@bugzilla.redhat.com>
In-Reply-To: <bug-989269-351310-C5h8dsuOxB@bugzilla.redhat.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

How are things in OpenWRT. I wanted to ask you something regarding a 
defect I am looking at. Since kernel 3.9 several reports have been made 
about a kernel panic in brcmsmac, ie. a divide-by-zero error.

Debugging the issue shows we end up with a rate with MCS index 110, 
which is, well, impossible. As brcmsmac gets the rate info from 
minstrel_ht I was wondering if we have an intergration issue here. I saw 
around April patches about new API which may have been in the 3.9 time 
frame and something subtly changed things for brcmsmac.

Regards,
Arend

-------- Original Message --------
Subject: [Bug 989269] Connecting to WLAN causes kernel panic
Date: Wed, 31 Jul 2013 08:11:41 +0000
From: <bugzilla@redhat.com>
To: <fedora-kernel-wireless-brcm80211@fedoraproject.org>

https://bugzilla.redhat.com/show_bug.cgi?id=989269



--- Comment #13 from Arend van Spriel <arend@broadcom.com> ---
(In reply to Chris from comment #12)
> Created attachment 780839 [details]
> dmesg | grep brcms when connecting to WLAN after patch 2
>
> During gathering this data I connected to the internet, was sitting for a
> while and then walked through a corridor in my university, so that the
> computer was connecting to different routers. Sat down there for
> significantly longer time. At the end I reconnected and disconnected.
> It seems to work stable, without any problems, but I haven't tried to use
> the connection for something heavier.

Thanks for the data. I observed two values that are invalid. ratespec 
value 0
is invalid and the driver selects 1Mbps rate to do the calculation. The 
other
value 134217838 is what triggers the divide-by-zero. The ratespec value is:
ratespec: 0x800006E
   RATE           110      (rate value [unit: 500Kbps or MCS index])
   MIMORATE       1        (RATE field represents MIMO MCS index)

This does not make sense, because MCS index can only go up to 32. I suspect
this should not be a mimo rate, but 54Mbps. Looking further how we end up in
this situation.

-- 
You are receiving this mail because:
You are the assignee for the bug.




