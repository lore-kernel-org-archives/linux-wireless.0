Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:35318 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbbJVNWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 09:22:21 -0400
Subject: Re: [PATCH] rtl8xxxu: Enable data frame reception in rtl8xxxu_start
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1445462932-23679-1-git-send-email-br1@einfach.org>
 <wrfjoafrrf1s.fsf@redhat.com> <56289543.1070008@thinktube.com>
 <wrfjtwpjoxqj.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Bruno Randolf <br1@einfach.org>
Message-ID: <5628E309.6020203@einfach.org> (sfid-20151022_152228_062461_EB60ACDE)
Date: Thu, 22 Oct 2015 14:22:17 +0100
MIME-Version: 1.0
In-Reply-To: <wrfjtwpjoxqj.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2015 02:10 PM, Jes Sorensen wrote:
>>> Thanks - I am not 100% convinced about this one. I don't think we should
>>> tell the firmware to pass up data frames before we have negotiated the
>>> connection.
>>>
>>> It's true that for monitor mode, we need to enable it if all packets
>>> are requested. Looking at iw there is an option where it only requests
>>> control packets, and one for all, etc. However for non monitor mode, we
>>> shouldn't pass all data packets up to the stack, resulting and have
>>> mac80211 parse them all.
>>
>> But mac80211 requests us to do so - please see include/net/mac80211.h
>> line 2576 or
>> https://www.kernel.org/doc/htmldocs/80211/API-struct-ieee80211-ops.html
>>
>> I know you are focusing on STA mode at the moment, but
>> enabling/disabling data reception on association is not correct for most
>> other modes.
>>
>> Also don't be afraid of too many frames being passed. In the initial
>> setting (without a monitor interface) the RCR RCR_ACCEPT_AP bit is not
>> set and the RCR_CHECK_BSSID_* bits are set as well.
> 
> I realize the different modes require different behavior, and we
> obviously need to deal with this. However we shouldn't downgrade STA
> mode in order to be able to handle other modes. Passing too many frames
> unncessarily is bad, it adds unnecessary load to the USB bus as well as
> the stack.
> 
> Remember that mac80211 is designed to handle completely dumb devices
> too, where it needs to process everything.
> 
> So I am not against making changes, I just want them done right.

Well, I'd say that for a mac80211 driver the right thing to do is to
follow the documented specifications of mac80211. Also I don't see how
this would downgrade STA mode, and I explained to you above how in STA
mode that does not pass more data frames to mac80211 than before.

BTW that also fixes the "endless scanning" problem I reported to you
before, and makes the driver work with the slightly older mac80211
version of OpenWRT 15.05. Care to explain what's not right with this?

But maybe a more credible mac80211 developer can can comment?

bruno

