Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3985 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1CUSwK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 14:52:10 -0400
To: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Logs spammed by brcm80211
References: <4D878FBC.5010204@lwfinger.net>
Date: Mon, 21 Mar 2011 19:51:57 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vspg80mq3ri7v4@arend-laptop>
In-Reply-To: <4D878FBC.5010204@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Mar 2011 18:49:48 +0100, Larry Finger  
<Larry.Finger@lwfinger.net> wrote:

> With both BCM4313 and BCM943224 cards, brcm80211 spams my logs with  
> messages:
>
> wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 159/256 dur  
> 1778/1504
> wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 137/256 dur  
> 1602/1504
> wl0: wlc_d11hdrs_mac80211: AC_BE txop exceeded phylen 382/256 dur  
> 3562/1504

This actually means that mac80211 is giving us transmit packets which  
violate the txop duration. I am not sure whether this is actually true or  
we did not honour the conf_tx callback. I think we should put this one on  
our todo list.

> Thanks,
>
> Larry
>

Thanks
AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

