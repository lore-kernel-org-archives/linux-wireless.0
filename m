Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51790 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751700AbeCNRoG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 13:44:06 -0400
Date: Wed, 14 Mar 2018 17:44:03 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Bitterblue of Monsea <cantabile.desu@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Martin Fuzzey <mfuzzey@parkeon.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, pali.rohar@gmail.com,
        Takashi Iwai <tiwai@suse.de>, arend.vanspriel@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Nicolas Broeking <nbroeking@me.com>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com, ast@fb.com,
        andresx7@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 00/20] firmware: development for v4.17
Message-ID: <20180314174403.GJ4449@wotan.suse.de> (sfid-20180314_184427_378582_C05BBBA9)
References: <20180310141501.2214-1-mcgrof@kernel.org>
 <CAGXu5jJqzahD=iwv8_ipvebi8kQ=UVPiMrHOtQL5iLyviFm6jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jJqzahD=iwv8_ipvebi8kQ=UVPiMrHOtQL5iLyviFm6jQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2018 at 09:16:36AM -0800, Kees Cook wrote:
> On Sat, Mar 10, 2018 at 6:14 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > Greg,
> >
> > Here's a respin of what I have queued up for v4.17 for the firmware API. It
> > combines the cleanup I've been working on and the addition of the new API call
> > request_firmware_cache() for fixing a corner case suspend issue on some type of
> > cards with an optimization in place where the firmware is *not* needed on
> > reboot.
> >
> > The cleanup work allows us to test the firmware API with one kernel
> > configuration. I've addressed Kees' feedback on this respin and
> > combined the code into drivers/base/firmware_class/.
> >
> > I've made one new test_firmware change in consideration for one firmware
> > change, the patch "firmware: ensure the firmware cache is not used on
> > incompatible calls" requires us to modify our tests scripts to use
> > the APIs sanely as well.
> >
> > I've put up these changes on my git tree, refer to the branch
> > "20180307-firmware-dev-for-v4.17" based on linux-next [0] and
> > the same name based on Linus' tree [1].
> >
> > Questions, feedback, and specially rants are always welcomed.
> 
> This all looks good to me! Thanks for respinning. :)

Greg,

I'd like to get these baked a bit through linux-next. Let me know if its
easier for you if I go through Andrew for the firmware API changes.

  Luis
