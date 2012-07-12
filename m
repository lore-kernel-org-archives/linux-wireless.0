Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48709 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab2GLTzS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 15:55:18 -0400
Received: by eekb15 with SMTP id b15so758728eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2012 12:55:16 -0700 (PDT)
Message-ID: <4FFF2B15.5070502@codigosur.org> (sfid-20120712_215616_116351_766348CA)
Date: Thu, 12 Jul 2012 16:52:53 -0300
From: =?ISO-8859-1?Q?Nicol=E1s_Ech=E1niz?= <nicoechaniz@codigosur.org>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: Guido Iribarren <guidoiribarren@buenosaireslibre.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc 1mbps in IBSS mode
References: <4FD56DCA.1080200@codigosur.org> <CAJ-VmomzoXV8YBdiS_2nkzVagBupX3Be-Dmboxotwy9s3h3r7w@mail.gmail.com> <CAHD-aqKWdUBGyadCnVoSbkf4BysoSuvBBHrupXx-JbowqqNZPQ@mail.gmail.com> <CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com> <20474.20627.928963.262924@gargle.gargle.HOWL>
In-Reply-To: <20474.20627.928963.262924@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 12:31 AM, Sujith Manoharan wrote:
> Guido Iribarren wrote:
>> I know nothing about the internal workings of the driver, but i get
>> the feeling that nodes are somehow not acknowledging supported speeds
>> of newly joined nodes, but instead only check other hosts speeds when
>> they join the IBSS cloud for the first time, and so it's limited to
>> nodes already present at the moment of the join.
> 
> It looks like commit 6d810f10 changed the behavior.
> 
> The station addition notification is now passed to the driver before the
> supported rates are updated for the peer (which happens via ieee80211_rx_bss_info()).
> Drivers which offload rate control to the firmware but depend on mac80211 for
> station management would be affected, I think.


Sujith, does this mean that the problem is outside the scope of the
ath9k_htc driver itself or could it be fixed?

we are doing some heavy use of hardware based on this driver for many
projects; any further debugging work you might need, we are more than
willing to help.


Cheers,
NicoEchániz
