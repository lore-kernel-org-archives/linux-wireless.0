Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charon.antacs.com ([150.101.188.194]:45616 "EHLO
	mail.antacs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZGHKLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 06:11:25 -0400
Received: from [127.0.0.1] (charon-int.antacs.com [172.30.236.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.antacs.com (Postfix) with ESMTP id 74E7926CFC4
	for <linux-wireless@vger.kernel.org>; Wed,  8 Jul 2009 20:11:24 +1000 (EST)
Message-ID: <4A546FA2.1070202@antacs.com>
Date: Wed, 08 Jul 2009 20:06:26 +1000
From: David Ross <dave@antacs.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 and broadcast frames
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com> 	<4A4B056B.9000602@mrs.ro> <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com> 	<4A530131.9050207@mrs.ro> <4A532D3C.5060601@antacs.com> <20090707144851.GA2768@tuxdriver.com> <43e72e890907070915y5fd131b7l6aa845a0785f8c76@mail.gmail.com> <4A544B15.8030106@mrs.ro>
In-Reply-To: <4A544B15.8030106@mrs.ro>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Valentin Manea wrote:
>   I've found the code in ath9k and you are right, it always chooses 
> the lowest rate.
>   So, basically to transmit multicast frames at a better bitrate I 
> have to hack the rate control algorithm, right?
>
> Thanks,
> Valentin
If you want to still be an 802.11 device then you may only use one of 
the basic rates, no extended rates, viz:
"All frames with multicast and broadcast in the Address 1 field that 
have a UP of zero shall be transmitted at one of the rates included in 
the BSSBasicRateSet parameter, regardless of their type or subtype." 
(from the 2007 edition of the standard).

- David Ross.

