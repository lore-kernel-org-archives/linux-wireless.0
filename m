Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751587AbeB1BUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 20:20:14 -0500
Date: Wed, 28 Feb 2018 01:20:12 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, cantabile.desu@gmail.com,
        Jakub Kicinski <kubakici@wp.pl>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Martin Fuzzey <mfuzzey@parkeon.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, pali.rohar@gmail.com,
        Takashi Iwai <tiwai@suse.de>, arend.vanspriel@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        nbroeking@me.com, Vikram Mulukutla <markivx@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abhay_Salunke@dell.com, bjorn.andersson@linaro.org,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFT 3/7] firmware: make fw_add_devm_name() return 0 if cache
 present
Message-ID: <20180228012012.GE14069@wotan.suse.de> (sfid-20180228_022029_022382_0D551290)
References: <20180227232101.20786-1-mcgrof@kernel.org>
 <20180227232101.20786-4-mcgrof@kernel.org>
 <CAGXu5jL1mrZ6LqV0WKBY=w_kZzzcSrUD6Z5YqToSS2qmNaS4Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jL1mrZ6LqV0WKBY=w_kZzzcSrUD6Z5YqToSS2qmNaS4Fw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 03:31:11PM -0800, Kees Cook wrote:
> On Tue, Feb 27, 2018 at 3:20 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > Currently fw_add_devm_name() returns 1 if the firmware cache
> > was already set. This makes it complicated for us to check for
> > correctness. It is actually non-fatal if the firmware cache
> > is already setup, so just return 0, and simplify the checkers.
> >
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> 
> That'll teach me to read all the patches first. ;)
> 
> Honestly, I'd just fold this into the prior patch: there's only one
> caller and it's exactly about checking the return value.

Sounds good.

  Luis
