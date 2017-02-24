Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:39465 "EHLO
        3.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751218AbdBXNse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 08:48:34 -0500
Received: from player746.ha.ovh.net (b6.ovh.net [213.186.33.56])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 1A63C4ABA1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 14:47:47 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 24 Feb 2017 14:47:38 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 4.12] brcmfmac: put chip into passive mode (when
 attaching) just once
In-Reply-To: <cbcb8722-15bb-bf6e-f329-972797b02028@broadcom.com>
References: <20170224131027.29880-1-zajec5@gmail.com>
 <cbcb8722-15bb-bf6e-f329-972797b02028@broadcom.com>
Message-ID: <64dc2b7028259129cb891a0b795d8c60@milecki.pl> (sfid-20170224_144838_139711_39E8991C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-24 14:31, Arend Van Spriel wrote:
> On 24-2-2017 14:10, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> It avoids some unnecessary work. Most likely there wasn't much sense 
>> in
>> doing this before bus reset anyway, as reset is supposed to put chip
>> into default state. In PCIe code (only bus implementing reset) we e.g.
>> use watchdog to perform a chip "reboot".
> 
> Sorry, but removing the fisrt passive call will cause chip lockups for
> sure on certain systems. We learned the hard way :-p

OK, acknowledged! ;) I just tested it on my BCM43602 doing warm reboots 
(they
were causing problems earlier) and it worked fine.

It also seems I don't use SDK recent enough as my reference :)

Kalle please drop this patch.
