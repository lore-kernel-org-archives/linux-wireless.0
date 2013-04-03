Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-4.exch022.serverdata.net ([64.78.56.56]:23213 "EHLO
	HUB022-ca-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762055Ab3DCIhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 04:37:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Date: Wed, 3 Apr 2013 01:37:30 -0700
From: <vivekanandah@posedge.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: question on SMPS for AP
In-Reply-To: <CAGXE3d_Up9BwfR3gC4uDh_4PNfAaMCME7dVeRnNrpmvc70ZALQ@mail.gmail.com>
References: <fbef7a2278fe739a398430949087c950@posedge.com>
 <1364976319.8351.2.camel@jlt4.sipsolutions.net>
 <CAGXE3d_Up9BwfR3gC4uDh_4PNfAaMCME7dVeRnNrpmvc70ZALQ@mail.gmail.com>
Message-ID: <8a7f0b7f3bc246cc8bacb37f4717b254@posedge.com> (sfid-20130403_103735_427240_5C833C3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi helmut,

thanks for the response.

thanks and regards
Vivek


On Wed, 3 Apr 2013 10:09:51 +0200, Helmut Schaa wrote:
> Hi Vivek,
>
> On Wed, Apr 3, 2013 at 10:05 AM, Johannes Berg  wrote:
>
>> The driver or rate control algorithm has to
>> take this into account, I'm not certain that all drivers and
>> algorithms
>> do this correctly (yet).
>
> Just as an example, in rt2x00  we just have to set one bit in the tx
> descriptor to
> force the hw to send out a 1-stream RTS to wake up the peer, from
> rt2x00queue.c:
>
>                 /*
>                  * MIMO PS should be set to 1 for
> STA's using dynamic SM PS
>                  * when using more then one tx stream
> (>MCS7).
>                  */
>                 if (sta && txdesc->u.ht.mcs > 7 &&
>                      sta->smps_mode ==
> IEEE80211_SMPS_DYNAMIC)
>                        
> __set_bit(ENTRY_TXD_HT_MIMO_PS, &txdesc->flags);
>
> HTH,
> Helmut
>
>
> Links:
> ------
> [1] mailto:johannes@sipsolutions.net

