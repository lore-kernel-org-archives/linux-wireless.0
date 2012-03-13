Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3979 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab2CMPe1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 11:34:27 -0400
Message-ID: <4F5F6759.3030005@broadcom.com> (sfid-20120313_163431_796904_84F94361)
Date: Tue, 13 Mar 2012 16:27:21 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: oops upon driver unload
References: <4F5F4300.6090103@broadcom.com>
 <20120313143916.GA2396@redhat.com>
In-Reply-To: <20120313143916.GA2396@redhat.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2012 03:39 PM, Stanislaw Gruszka wrote:
> On Tue, Mar 13, 2012 at 01:52:16PM +0100, Arend van Spriel wrote:
>> During testing I got an OOPS with the brcmsmac (see attachment). I
>> suspect mac80211 is using a driver callback after the module is
>> removed (could be wrong here). The connection with the AP is
>> dropped, and after 1 sec. the driver is unloaded using rmmod, which
>> causes the driver to unregister from mac80211.
>>
>> Any clues?
> [snip]
>
>> Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002] Call Trace:
>> Mar 12 02:52:36 lb-bun-09 kernel: [575889.112002]  [<c103f0ea>] ? run_timer_softirq+0x11a/0x2d0
> Those options are useful to debug such problems:
>
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
>
> Stanislaw
>

Thanks,

I will go and try that.

Gr. AvS

