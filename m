Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45593 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbZHWPEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 11:04:00 -0400
Received: by bwz19 with SMTP id 19so1105216bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2009 08:04:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b637ec0b0908230740j284734f7t7ea0536c1fee406f@mail.gmail.com>
References: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com>
	 <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com>
	 <b6c5339f0908210719o2323d590w4a9f6a01d5ecb2d6@mail.gmail.com>
	 <20090822124709.GA6762@hash.localnet>
	 <b637ec0b0908220602v3b9c2a35ob1e44d70f131890c@mail.gmail.com>
	 <20090822134044.GC6762@hash.localnet>
	 <b637ec0b0908221229k5a738f8dgc0aa9e58337c743e@mail.gmail.com>
	 <20090823001218.GE6762@hash.localnet>
	 <b637ec0b0908230740j284734f7t7ea0536c1fee406f@mail.gmail.com>
Date: Sun, 23 Aug 2009 17:03:59 +0200
Message-ID: <b637ec0b0908230803x4ba1ed0pf3345ebb7c4691d@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, some more info.
After the warning the system is usable but wireless doesn't work. The
hang happens when I activate the rfkill swich.

This happens even after a fresh boot. After activating the rfkill
switch the console fills with:

   unregister_netdevice: waiting for device wlan0 to become free

with a line every 5 seconds or so. At this time the system is
completely unresponsive.

Regards,
Fabio





On Sun, Aug 23, 2009 at 4:40 PM, Fabio Comolli<fabio.comolli@gmail.com> wrote:
> Hi.
>
> On Sun, Aug 23, 2009 at 2:12 AM, Bob Copeland<me@bobcopeland.com> wrote:
>> On Sat, Aug 22, 2009 at 09:29:39PM +0200, Fabio Comolli wrote:
>>> Hi Bob.
>>> Unfortunately the patch doesn't apply at all with compat-wireless,
>>> there's no "flush_workqueue" before "local->suspended" there....
>>
>> Ah yes, it got moved into ieee80211_stop_device().  Can you put
>> local->suspended and the barrier() ahead of that?
>>
>
> Well, this crashed my system. Backtrace copied by hand:
>
> warning at net/wireless/core.c    wdev_cleanup_work [cfg80211]
>
> warn_slowpat_common
> warn_slowpath_null
> wdev_cleanup_work [cfg80211]
> worker_thread
> wdev_cleanup_work [cfg80211]
> autoresolve_wake_function
> worker_thread
> kthread
> kthread
> kernel_thread_helper
>
>
>> Thanks!
>
> Regards,
> Fabio
>
>
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
>>
>>
>
