Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:42536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbdBFQnb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 11:43:31 -0500
Date: Mon, 06 Feb 2017 11:43:29 -0500 (EST)
Message-Id: <20170206.114329.1196570425826508517.davem@davemloft.net> (sfid-20170206_174435_705493_CA3DC7B0)
To: linus.luessing@c0d3.blue
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, monis@voltaire.com,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Fix IPv6 packet loss in scenarios involving
 roaming + snooping switches
From: David Miller <davem@davemloft.net>
In-Reply-To: <20170203071103.25976-1-linus.luessing@c0d3.blue>
References: <20170203071103.25976-1-linus.luessing@c0d3.blue>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Lüssing <linus.luessing@c0d3.blue>
Date: Fri,  3 Feb 2017 08:11:03 +0100

> When for instance a mobile Linux device roams from one access point to
> another with both APs sharing the same broadcast domain and a
> multicast snooping switch in between:
> 
> 1)    (c) <~~~> (AP1) <--[SSW]--> (AP2)
> 
> 2)              (AP1) <--[SSW]--> (AP2) <~~~> (c)
> 
> Then currently IPv6 multicast packets will get lost for (c) until an
> MLD Querier sends its next query message. The packet loss occurs
> because upon roaming the Linux host so far stayed silent regarding
> MLD and the snooping switch will therefore be unaware of the
> multicast topology change for a while.
> 
> This patch fixes this by always resending MLD reports when an interface
> change happens, for instance from NO-CARRIER to CARRIER state.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>

Looks good to me, applied, thanks.
