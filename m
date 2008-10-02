Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42854 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYJBHxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 03:53:44 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KlJ0I-0003f1-U5
	for linux-wireless@vger.kernel.org; Thu, 02 Oct 2008 07:53:42 +0000
Received: from pd9e85fd9.dip.t-dialin.net ([217.232.95.217])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 07:53:42 +0000
Received: from eo by pd9e85fd9.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 07:53:42 +0000
To: linux-wireless@vger.kernel.org
From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Date: Thu, 02 Oct 2008 09:53:27 +0200
Message-ID: <87od23mo08.fsf@denkblock.local> (sfid-20081002_095349_565298_98E6BA33)
References: <200808101401.03339.toralf.foerster@gmx.de>
	<b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	<200810012055.58085.toralf.foerster@gmx.de>
	<87ej30m376.fsf@denkblock.local>
	<b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
	<87ljx8ndw1.fsf@denkblock.local>
	<b6c5339f0810011904h1208aa1dr197580780896197d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ath5k-devel@lists.ath5k.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> wrote:
> On Wed, Oct 1, 2008 at 6:34 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
>> "Bob Copeland" <me@bobcopeland.com> wrote:
>
>>> On Wed, Oct 1, 2008 at 5:10 PM, Elias Oltmanns <eo@nebensachen.de> wrote:
>> Oh, but it is cleaned up by ath5k_stop_hw(). The issue is a different
>> one here:
>>
>> ath5k_init() == ->start()
>> ath5k_stop_hw() == ->stop()
>>
>> Since the mac80211 layer never opened a device, it won't close it
>> either. Thus, ath5k_stop_hw() does not get called on module unload. By
>> calling ath5k_init() on resume, the driver has effectively started the
>> device when it was not supposed to do so and this event is not being
>> tracked by the higher layers.
>
> Ah, yes, good analysis... and ath5k_init is scheduling the timer.  I
> doubt ieee80211_opened would fly; probably the better thing to do is
> ensure that the cleanup gets called regardless of whether ath5k_stop
> gets called (it shouldn't matter since the irqs all get created in
> _attach).

Not sure I agree there. Why should calibration take place regularly even
though the interface appears to be shut down from user-space's point of
view? It simply doesn't make sense  to start the interface if nobody
intends to use it. Not that I know anything about it, but I imagine that
periodic recalibration might even be a waste of power, something most
laptop users will care about.

So, if higher layers won't provide any information about what interface
is considered opened, then ath5k has to track this sort of state
information itself if it intends to resume to the exact same state of
affairs as observed at the time of going into suspend. For all I know,
other drivers will have similar issues and track the open state which is
why I suggested ieee80211_opened, but you will know much more about
these things than I do. Just as an aside, at least on my system the
following doesn't work anyway:

1. # modprobe ath5k
2. # ifup ath5k
3. # ping <ap>
4. s2ram
5. resume
6. # ping <ap>

The last ping fails with network/host unreachable -- this is with a WPA
configuration and I haven't tested anything else. So, at least I always
have to make sure that I shut down all interfaces before suspending
anyway.

Regards,

Elias

