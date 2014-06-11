Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53125 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaFKOby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:31:54 -0400
Message-ID: <53986859.4040805@candelatech.com> (sfid-20140611_163157_973441_B10EDE50)
Date: Wed, 11 Jun 2014 07:31:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: More confusion with regulatory issues.
References: <53979E9A.5010308@candelatech.com> <CAB=NE6VDr8C=2XZZhnyFKeowDMA-K05_ySw=jDS5gz4+7xs3NA@mail.gmail.com> <CALhHN=oeiDOR=yaX4Eibs69QmbEVeJU065xamdrmatW_gXBnEA@mail.gmail.com>
In-Reply-To: <CALhHN=oeiDOR=yaX4Eibs69QmbEVeJU065xamdrmatW_gXBnEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2014 03:34 AM, Janusz Dziedzic wrote:

> This could be the same issue like fixed in:
> cfg80211: reg: setup correct alpha2 after intersection (Ben could you
> try with this patch?)
> 
> Orginal scenario I descibe:
> - insmod cfg80211.ko
> - iw reg set FR (1)
> - modprobe ath10k_pci (US hint)
> - intersection and country set as "98"
> - no way to setup new country using iw reg set   (here hostapd startup
> will failed)
> 
> But I can imagine also that we have two cards, both using cfg80211.ko
> So, first card driver loaded set regulatory eg. FR
> Next we load ath10k --> intersection "98"
> Next run hostapd - and fail because no way to change regulatory and
> get correct DFS region
> 
> BTW:
> There is no problem (no intersection) when move "iw reg set" after
> modprobe ath10k - seems strange logic issue here ...

With your patch, I no longer see the '98' regdomain, but
I still see DFS-UNSET.  Is that expected?  How do I get DFS
to work (and, should it actually be enabled in this case?)

[root@ath10k-2220 ~]# iw reg get
country US: DFS-UNSET
	(2402 - 2472 @ 40), (N/A, 30)
	(5170 - 5250 @ 80), (N/A, 17)
	(5250 - 5330 @ 80), (N/A, 23), DFS
	(5735 - 5835 @ 80), (N/A, 30)
	(57240 - 63720 @ 2160), (N/A, 40)
[root@ath10k-2220 ~]#

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

