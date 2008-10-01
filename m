Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45545 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYJAWet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 18:34:49 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KlAHL-0001Z7-GL
	for linux-wireless@vger.kernel.org; Wed, 01 Oct 2008 22:34:43 +0000
Received: from pd9e87db2.dip.t-dialin.net ([217.232.125.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 22:34:43 +0000
Received: from eo by pd9e87db2.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 22:34:43 +0000
To: linux-wireless@vger.kernel.org
From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Date: Thu, 02 Oct 2008 00:34:22 +0200
Message-ID: <87ljx8ndw1.fsf@denkblock.local> (sfid-20081002_003452_822691_939E8FEB)
References: <200808101401.03339.toralf.foerster@gmx.de>
	<b6c5339f0808101124x6f9359dct9ad828db1e6d1b2c@mail.gmail.com>
	<200810012055.58085.toralf.foerster@gmx.de>
	<87ej30m376.fsf@denkblock.local>
	<b6c5339f0810011515n770fa89bs3d09c16411121c79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: ath5k-devel@lists.ath5k.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Bob Copeland" <me@bobcopeland.com> wrote:
> On Wed, Oct 1, 2008 at 5:10 PM, Elias Oltmanns <eo@nebensachen.de> wr=
ote:
>> Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
>
>>> Hello,
>>>
>>> the issue (initially reported in August 2008) still remains in the =
current
>>> kernel at my ThinkPad T41, a screen shot is attached. The steps to =
reproduce
>>> are :
>>>
>>> 1. modprobe it
>>> 2. suspend the system to ram
>>> 3. wake it up
>>> 4. rmmod the driver
>>
>> Yes, I have run into this problem too. The patch below (applies to
>> 2.6.27-rc8) fixes the problem, but since I'm not a wireless hacker,
>> developers might prefer a different approach. Please let me know if =
I
>> should change anything. Perhaps I should split this into two separat=
e
>> patches?
>
> Thanks for the patch.  I do think a different approach is probably
> warranted, though. ath5k_init() is supposed to be able to be called f=
rom
> resume.  Do you have a better idea of why calib_tim isn't cleaned up
> properly by ath5k_stop_hw?

Oh, but it is cleaned up by ath5k_stop_hw(). The issue is a different
one here:

ath5k_init() =3D=3D ->start()
ath5k_stop_hw() =3D=3D ->stop()

Since the mac80211 layer never opened a device, it won't close it
either. Thus, ath5k_stop_hw() does not get called on module unload. By
calling ath5k_init() on resume, the driver has effectively started the
device when it was not supposed to do so and this event is not being
tracked by the higher layers.

>
> I'm not near my laptop to test -- does the issue ever happen if you d=
o
> NOT suspend?

If you don't do a suspend / resume cycle but simply load and unload the
module, this is not an issue because ath5k_init() never gets called
unless the mac80211 layer tells the driver to do so.

Regards,

Elias

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
