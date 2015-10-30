Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758941AbbJ3Tci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 15:32:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
References: <1445462932-23679-1-git-send-email-br1@einfach.org>
	<wrfjoafrrf1s.fsf@redhat.com> <56289543.1070008@thinktube.com>
	<wrfjtwpjoxqj.fsf@redhat.com> <5628E309.6020203@einfach.org>
	<wrfjk2qfow8r.fsf@redhat.com> <5628E9AB.1060907@einfach.org>
	<wrfj611xba2p.fsf@redhat.com> <562A608A.9060706@lwfinger.net>
Date: Fri, 30 Oct 2015 15:32:36 -0400
In-Reply-To: <562A608A.9060706@lwfinger.net> (Larry Finger's message of "Fri,
	23 Oct 2015 11:30:02 -0500")
Message-ID: <wrfja8r0kv8r.fsf@carbonite.lan.trained-monkey.org> (sfid-20151030_203241_441959_E74ABC26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 10/23/2015 03:31 PM, Jes Sorensen wrote:
>> Bruno Randolf <br1@einfach.org> writes:
>>> On 10/22/2015 02:42 PM, Jes Sorensen wrote:
>>>> Making things work against random kernel versions of OpenWRT is not
>>>> particularly "credible". If the driver needs hacks to work with older
>>>> kernels, then they should be applied for the older kernels. Linux does
>>>> not have a history of carrying hacks in current drivers to accommodate
>>>> older kernels.
>>>
>>> Well forget OpenWRT. The point is that this is not a hack - it's the
>>> behavior that mac80211 expects and documents and moreover it does NOT
>>> pass more data frames than before.
>>>
>>> It does not pass more data frames before association because the RCR
>>> RCR_ACCEPT_AP bit is not set and the RCR_CHECK_BSSID_* bits are set.
>>
>> I have gone back and looked more at the vendor drivers over this issue.
>> Most versions of the vendor driver consistently mess with both FLTMAP*
>> and RCR, and disable packets when they go into a non-assoc state, but
>> non-assoc to the vendor driver also means non-AP, non-monitor, etc.
>>
>> I really would like to know more about the difference between RCR and
>> FLTMAP registers - Larry is there a chance you could try and ping your
>> Realtek contacts about this?
>
> I will try, but please be aware that the USB group generally tends to
> ignore me. Perhaps the PCI group can help.

Larry,

Much appreciated - I believe the FLTMAP* and RCR registers are the same
on the PCI and USB chips, so any answer should be useful.

Cheers,
Jes
