Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1658 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2ATIar (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 03:30:47 -0500
Message-ID: <4F19262B.4000102@broadcom.com> (sfid-20120120_093057_190695_43E66858)
Date: Fri, 20 Jan 2012 09:30:35 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "Alwin Beukers" <alwin@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Julian Calaby" <julian.calaby@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: brcmsmac broken with 3.2
References: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
 <CAC9WiBh5-vS6UmCYCs911WAudmWDtsgDPmHim71LtvaC81HsWQ@mail.gmail.com>
In-Reply-To: <CAC9WiBh5-vS6UmCYCs911WAudmWDtsgDPmHim71LtvaC81HsWQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2012 10:19 PM, Francis Moreau wrote:
> Hi all,
> 
> I'm wondering now why the brmsmac driver had been removed from the
> staging driver tree if no one cares.
> 
> Bye.

Sorry for the delay in getting back to you. Still care about our
brcmsmac driver, but I can only work one issue at a time.

> 
> On Thu, Jan 12, 2012 at 8:32 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello,
>>
>> I'm facing a new issue after upgrading from 3.1 to 3.2.
>>
>> It happens when switching on/off my wireless card (BCM4313 [14e4:4727]).
>>
>> Here's the oops I'm getting:
>>
>> [36370.370768] WARNING: at net/mac80211/rx.c:2979

Did this problem occur with plain 3.2 kernel. I checked out the v3.2
mainline tag and looked at line 2979:ieee80211_rx():
2975:        /*
2976:         * The same happens when we're not even started,
2977:         * but that's worth a warning.
2978:         */
2979:        if (WARN_ON(!local->started))
2980:                goto drop;

>> ieee80211_rx+0x91b/0x9e0 [mac80211]()
>> [36370.370775] Hardware name: Vostro 3500
>> [36370.370870] Pid: 0, comm: swapper/0 Tainted: G        WC O 3.2.0 

I guess brcmsmac is sending up a received wireless packet to mac80211
and it is dropped, because mac80211 did not yet call the start callback.
It is just a warning so if you are having problems connecting to an AP
you may have other issues. As the comment states it is worth a warning
so I will look further into this.

Gr. AvS

