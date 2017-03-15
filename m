Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35764 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdCOIyH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 04:54:07 -0400
Received: by mail-qk0-f180.google.com with SMTP id v127so7530888qkb.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Mar 2017 01:54:06 -0700 (PDT)
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network
 namespace
To: Johannes Berg <johannes@sipsolutions.net>,
        Mark Asselstine <mark.asselstine@windriver.com>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com>
 <1489529967.10872.16.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <647430d4-425f-baa9-5cb7-05c7916ca1a6@broadcom.com> (sfid-20170315_095412_841213_6C7D8EBE)
Date: Wed, 15 Mar 2017 09:54:03 +0100
MIME-Version: 1.0
In-Reply-To: <1489529967.10872.16.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-3-2017 23:19, Johannes Berg wrote:
> On Tue, 2017-03-14 at 21:51 +0000, Arend van Spriel wrote:
>> To support network namespace the driver must assure all created
>> network interfaces are in the same namespace as the wiphy instance.
> 
> FWIW, looks fine to me.

Thanks. Any feedback is worth something ;-)

>>  	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
>> +	wiphy = cfg_to_wiphy(drvr->config);
>> +	dev_net_set(ndev, wiphy_net(wiphy));
> 
> You (almost?) don't need the wiphy variable :)

Yeah. I could wrap that into wiphy_net() call as it is the only place I
need it. Will do that if I stay clear from column #80.

Regards,
Arend
