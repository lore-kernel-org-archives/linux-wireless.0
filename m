Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2543 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2CMPdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 11:33:55 -0400
Message-ID: <4F5F6744.2040707@broadcom.com> (sfid-20120313_163359_586272_7FF28B97)
Date: Tue, 13 Mar 2012 16:27:00 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: oops upon driver unload
References: <4F5F4300.6090103@broadcom.com> (
 sfid-20120313_135234_397539_8DF6367C)
 <1331643618.3329.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331643618.3329.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2012 02:00 PM, Johannes Berg wrote:
> On Tue, 2012-03-13 at 13:52 +0100, Arend van Spriel wrote:
>> During testing I got an OOPS with the brcmsmac (see attachment). I
>> suspect mac80211 is using a driver callback after the module is removed
>> (could be wrong here). The connection with the AP is dropped, and after
>> 1 sec. the driver is unloaded using rmmod, which causes the driver to
>> unregister from mac80211.
>
> What's the kernel version? I can't find your commit ("0e65d9a")
>
> johannes
>
>

That's from our internal repository, but it is based on a 3.3-rc4 
wireless-testing tree.

I am using nmcli for setting up connection with the AP and found that 
the connection is setup to be automatic. That is reason why the log 
shows auth attempt during module unload. It does not happen on each test 
run.

I will use debug suggestions from Stanislaw and try to get more information.

Gr. AvS

