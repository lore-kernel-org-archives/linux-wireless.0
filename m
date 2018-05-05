Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from inx.pm.waw.pl ([91.202.125.194]:53364 "EHLO inx.pm.waw.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751860AbeEEU0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 May 2018 16:26:51 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        keescook@chromium.org, josh@joshtriplett.org, teg@jklm.no,
        wagi@monom.org, hdegoede@redhat.com, andresx7@gmail.com,
        zohar@linux.vnet.ibm.com, kubakici@wp.pl, shuah@kernel.org,
        mfuzzey@parkeon.com, dhowells@redhat.com, pali.rohar@gmail.com,
        tiwai@suse.de, kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, cantabile.desu@gmail.com, ast@fb.com,
        hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        davem@davemloft.net, maco@android.com, arve@android.com,
        tkjos@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 0/6] firmware_loader: cleanups for v4.18
References: <20180504174356.13227-1-mcgrof@kernel.org>
        <m3lgczcjt7.fsf@pm.waw.pl> <20180504195835.GU27853@wotan.suse.de>
Date: Sat, 05 May 2018 22:26:46 +0200
In-Reply-To: <20180504195835.GU27853@wotan.suse.de> (Luis R. Rodriguez's
        message of "Fri, 4 May 2018 19:58:35 +0000")
Message-ID: <m3a7td6e7t.fsf@pm.waw.pl> (sfid-20180505_222716_377414_326CF195)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

> So we can nuke CONFIG_WANXL_BUILD_FIRMWARE now?

I'm uncertain I understand why do you want it, or maybe what are you
trying to do at all.

And what use would wanxlfw.S (the assembly source) have if the option is
removed?

>> It's more about delivering the .S source for the firmware, I guess.
>> Nobody is expected to build it. The fw is about 2.5 KB and is directly
>> linked with the driver.
>
> :P Future work I guess would be to just use the firmware API and stuff
> it into linux-firmware?

Who's going to make it happen?
The last time I checked (several years ago), wanXL worked. Who's going
to test it after the change?

I assume linux-firmware could include fw source and there would be means
to build the binary.

Just to be sure: the wanXL firmware has exactly nothing to do with FW
loader, nothing depends on it (nor the other way around), it's just
(with the rest of the wanXL code) an old piece of a driver for an old
card.

The question is, what do we gain by messing with it?
-- 
Krzysztof Halasa
