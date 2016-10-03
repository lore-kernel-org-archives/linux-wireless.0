Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:48745 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbcJCKxD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 06:53:03 -0400
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on AP
 interfaces
To: Johannes Berg <johannes@sipsolutions.net>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
 <1475229714.17481.18.camel@sipsolutions.net>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
From: Michael Braun <michael.braun@fem.tu-ilmenau.de>
Message-ID: <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de> (sfid-20161003_125307_207097_AD61F5A3)
Date: Mon, 3 Oct 2016 12:44:48 +0200
MIME-Version: 1.0
In-Reply-To: <1475229714.17481.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 30.09.2016 um 12:01 schrieb Johannes Berg:
> A few more things:
> 
> First of all - there's nothing specific to "AP interfaces", which you
> say in the subject, as far as I can tell? That should be removed?

>> if (unlikely(ta &&
>>+			     (iftype == NL80211_IFTYPE_AP ||
>>+			      iftype == NL80211_IFTYPE_AP_VLAN) &&
>>+			     !ether_addr_equal(ta, eth.h_source)
>>+		   ))
>>+			goto purge;

So the A-MSDU packets are only dropped if received by an interface in AP
or AP_VLAN mode, not on client side, as my original issue was about
arp/ip filters being circumvented on AP side.

>> IEEE 802.11-2012 mandates that the outer source mac address should
>> match the inner source address (section 8.3.2.2). For the
>> destination mac address, matching is not required (section 10.23.15).
> 
> I think this is wrong. As we do not support DMS (yet), we should adhere
> to 8.3.2.2 and only accept matching TA/SA and DA/RA.

IEEE 802.11-2012 8.3.2.2 contains the note "NOTE—It is possible to have
different DA and SA parameter values in A-MSDU subframe headers of the
same A-MSDU as long as they all map to the same Address 1 and Address 2
parameter values."

I conclude that embedding multicast in unicast A-MSDU frames is
generally allowed, because "mapping" does not mean "be identical".

Regards,
M. Braun
