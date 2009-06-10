Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51539 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625AbZFJPXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 11:23:17 -0400
Received: by fxm9 with SMTP id 9so857897fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 08:23:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	<f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	<3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	<69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	<3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	<1244619027.18481.55.camel@johannes.local> <3ace41890906100639gb800904td06d86efef90e656@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 10 Jun 2009 17:22:58 +0200
Message-ID: <69e28c910906100822q6eae8b29p2381220b23b4f4b1@mail.gmail.com>
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 3:39 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Wed, Jun 10, 2009 at 8:30 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Wed, 2009-06-10 at 04:18 +0100, Hin-Tak Leung wrote:
>>
>>> But I have been using vendor driver 3.0 for a few weeks in AP mode and
>>> I am as happy with it as I could be, I think; I have
>>> suspended//resumed clients.  It works adequately.
>>
>> We're not concerned about suspend/hibernate, we're concerned about
>> 802.11 power saving, where the AP is required to buffer frames until the
>> clients wake up again. This will work adequately, but not perfectly, for
>> unicast frames, but we have not found a way of making zd1211 send
>> buffered multicast frames after the DTIM beacon as required.
>>
>> This means that your sleeping clients will not be receiving multicast,
>> and as such be invisible to the network once they fall off the ARP/NDP
>> caches. This is the reason we have said that it will not be possible to
>> support AP mode with this card. I'm curious how, if at all, the vendor
>> driver handles that.
>
> I was talking about the client suspending/resuming (i.e. the client
> disappearing).
>
> This is what appears in the AP machine's dmesg during the client's sleep:
> ---------------------------------------------------------
> *****Age one*****
> aid:1
> now:264313809
> ttl:264163665
> idleTime:150144
> zd1205_notify_disjoin_event
> Send Deasoc Req to 00:16:44:8f:71:93 RSN=4
> STA_DISASSOCIATED:00:16:44:8f:71:93
> Reject Auth Due to ar2524drv/src/zdpsmon.c,568. staSte=4
> Update BCN @ 286757537
> Re_Asoc: 00:16:44:8f:71:93, aid=1
> ------------------------------------------------------------
>
> It seems that the vendor driver on the AP machine simply diassociates
> a sleeping cliient for inactivity after 10 minutes during the sleep
> and let the client does reassociating when it wakes again. I just grep
> for 'idleTime' in the 3.0 source and 10 minutes is exactly what it
> does.
>

But again, that is not the problem that prevents proper AP mode; it's
802.11 dynamic power saving of the card, unrelated to
suspend/resume/powersave mode of the host.

(Note that I'm also for allowing such "buggy" AP mode on devices
without a HW multicast buffer, perhaps with hostapd spitting out a
big, fat warning on startup; but Johannes has the final say in
mac80211-related questions.)

(To Johannes: exactly why is it required for the multicast buffer to
be in hardware?)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
