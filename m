Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59607 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3BSFSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 00:18:15 -0500
Message-ID: <51230B14.1010008@candelatech.com> (sfid-20130219_061918_289866_7CA6A0F1)
Date: Mon, 18 Feb 2013 21:18:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL> <511BC243.8010409@candelatech.com> <20770.57339.20017.225929@gargle.gargle.HOWL> <20770.58671.383019.745225@gargle.gargle.HOWL>
In-Reply-To: <20770.58671.383019.745225@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 06:36 PM, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
>> xmit.c would be a good place. Can you also post the kernel log with some
>> debugging information ? debug=0x8f49 would be good.
>
> We came across an issue where slowly reducing attenuation would eventually
> cause transmission to fail. This was seen only with the ath9k rate control module
> and was fixed by the commit: "ath9k: Fix TX filter usage". With minstrel_ht,
> things were smooth. Can you also try changing the RC and see if the issue is still seen ?

That tx-filter patch is already in my kernel.  I believe this test was using ath9k
RC, so will try changing to minstrel_ht and see if that fixes anything.

My first concern is fixing the kernel crash related to removing
interfaces, so might be a day or two before I can get back to this
particular issue...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

