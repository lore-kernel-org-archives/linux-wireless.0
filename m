Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47685 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0GXCa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 22:30:58 -0400
Received: by wwj40 with SMTP id 40so5255806wwj.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 19:30:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279936945.27462.2.camel@mj>
References: <AANLkTil3u8uFbH7WyPuvqu0wee4KsojqPUsAH2kupZhJ@mail.gmail.com>
	<1279936945.27462.2.camel@mj>
Date: Fri, 23 Jul 2010 22:30:56 -0400
Message-ID: <AANLkTimnFGidxLvnR+=WXykQyf4NNAJBkxuqZ3HWRdeh@mail.gmail.com>
Subject: Re: ath9k - D-link DWA-552
From: Andy Pyles <andy.pyles@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

Incidentally this is the output after adding that id to pci.c:

[ 1211.423855] Backport based on linux-next.git next-20100720
[ 1211.437076] cfg80211: World regulatory domain updated:
[ 1211.437080]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1211.437084]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1211.437087]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1211.437089]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 1211.437092]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1211.437095]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 1211.447705] ath9k 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[ 1211.447794] ath9k 0000:05:02.0: Failed to initialize device
[ 1211.447830] ath9k 0000:05:02.0: PCI INT A disabled
[ 1211.447859] ath9k: probe of 0000:05:02.0 failed with error -95



On Fri, Jul 23, 2010 at 10:02 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2010-07-21 at 14:58 -0400, Andy Pyles wrote:
>> I have recently purchased two of these cards. ( the markings on the
>> outside indicate they have are same hardware revision). I am noticing
>> some strange behavior on one of them:
> ...
>> $lspci -n output:
>> 05:05.0 0200: 168c:ff1d (rev 01)
>
> This looks like some experimental version that was not meant to be sold.
>
>> Has anyone else seen this behavior with Card Two? I tried swapping to
>> a different PCI slot, even to a different PC.
>> Same symptom. I also tried modifying pci.c in ath9k driver to no effect.
>
> If you add the PCI ID to the driver, something should change.  The
> driver would try to initialize the card.  If it fails, you should get
> some message in the kernel log, which can be seen by running dmesg.
>
> --
> Regards,
> Pavel Roskin
>
