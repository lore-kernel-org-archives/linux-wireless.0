Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988AbbJVNKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 09:10:14 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bruno Randolf <br1@thinktube.com>
Cc: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
References: <1445462932-23679-1-git-send-email-br1@einfach.org>
	<wrfjoafrrf1s.fsf@redhat.com> <56289543.1070008@thinktube.com>
Date: Thu, 22 Oct 2015 09:10:12 -0400
In-Reply-To: <56289543.1070008@thinktube.com> (Bruno Randolf's message of
	"Thu, 22 Oct 2015 08:50:27 +0100")
Message-ID: <wrfjtwpjoxqj.fsf@redhat.com> (sfid-20151022_151019_829506_9EA67BCF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Randolf <br1@thinktube.com> writes:
> On 10/22/2015 12:13 AM, Jes Sorensen wrote:
>> Bruno Randolf <br1@einfach.org> writes:
>>> mac80211 documentation says, the ieee80211_ops.start callback "must turn on
>>> frame reception (for possibly enabled monitor interfaces.)". If not a single
>>> monitor interface does not receive data frames.
>>>
>>> Similarly we should not change the data reception based on the association
>>> state.
>>>
>>> Signed-off-by: Bruno Randolf <br1@einfach.org>
>>> ---
>>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 12 ++----------
>>>  1 file changed, 2 insertions(+), 10 deletions(-)
>> 
>> Bruno,
>> 
>> Thanks - I am not 100% convinced about this one. I don't think we should
>> tell the firmware to pass up data frames before we have negotiated the
>> connection.
>> 
>> It's true that for monitor mode, we need to enable it if all packets
>> are requested. Looking at iw there is an option where it only requests
>> control packets, and one for all, etc. However for non monitor mode, we
>> shouldn't pass all data packets up to the stack, resulting and have
>> mac80211 parse them all.
>
> But mac80211 requests us to do so - please see include/net/mac80211.h
> line 2576 or
> https://www.kernel.org/doc/htmldocs/80211/API-struct-ieee80211-ops.html
>
> I know you are focusing on STA mode at the moment, but
> enabling/disabling data reception on association is not correct for most
> other modes.
>
> Also don't be afraid of too many frames being passed. In the initial
> setting (without a monitor interface) the RCR RCR_ACCEPT_AP bit is not
> set and the RCR_CHECK_BSSID_* bits are set as well.

I realize the different modes require different behavior, and we
obviously need to deal with this. However we shouldn't downgrade STA
mode in order to be able to handle other modes. Passing too many frames
unncessarily is bad, it adds unnecessary load to the USB bus as well as
the stack.

Remember that mac80211 is designed to handle completely dumb devices
too, where it needs to process everything.

So I am not against making changes, I just want them done right.

Cheers,
Jes
