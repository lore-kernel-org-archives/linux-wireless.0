Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752601AbeB1Spd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 13:45:33 -0500
Date: Wed, 28 Feb 2018 18:45:31 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile <cantabile.desu@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, kubakici@wp.pl,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-wireless@vger.kernel.org, keescook@chromium.org,
        shuah@kernel.org, mfuzzey@parkeon.com, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, pali.rohar@gmail.com, tiwai@suse.de,
        arend.vanspriel@broadcom.com, zajec5@gmail.com, nbroeking@me.com,
        markivx@codeaurora.org, stephen.boyd@linaro.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFT 0/7] firmware: enable caching of firmware for reboot
 optimization
Message-ID: <20180228184531.GK14069@wotan.suse.de> (sfid-20180228_194551_586552_C6C9F5FE)
References: <20180227232101.20786-1-mcgrof@kernel.org>
 <49e9d9c3-1352-e204-ff95-5cf10f14bd35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49e9d9c3-1352-e204-ff95-5cf10f14bd35@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2018 at 08:03:26PM +0200, cantabile wrote:
> On 28/02/18 01:20, Luis R. Rodriguez wrote:
> > Cantabile, please give these patches a spin and let me know if it fixes
> > your reported issue. They depend on other pending patches I have in line
> > waiting to be merged so the easiest I thing I think is for you to test my
> > 20180227-firmware-cache branch [0], based on Linus' tree. To get that
> > tree, cd into your Linus git tree and do:
> > 
> > git remote add mcgrof https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git
> > git checkout -b 20180227-firmware-cache mcgrof/20180227-firmware-cache
> > 
> > Please let me know if this resolves your issue and thanks for your report.
> > 
> 
> I confirmed that request_firmware_cache is called, and the firmware is
> loaded from the cache when resuming from hibernation. The bug is fixed.

Great, thanks for testing.

Curious, is it also called if you suspend to RAM instead of just using hibernation?

  Luis
> Thank you.
> 

-- 
Luis Rodriguez, SUSE LINUX GmbH
Maxfeldstrasse 5; D-90409 Nuernberg
