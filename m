Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751459AbeCNWdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 18:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <20180314185634.GC15837@kroah.com>
References: <20180310141501.2214-1-mcgrof@kernel.org> <20180310141501.2214-8-mcgrof@kernel.org>
 <20180314185634.GC15837@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Wed, 14 Mar 2018 15:33:23 -0700
Message-ID: <CAB=NE6V378RCJ+sYvtfRe01HMyjVOwJOmjYWU8qnec9B_s4+9Q@mail.gmail.com> (sfid-20180314_233401_673906_A96D6A69)
Subject: Re: [PATCH v3 07/20] firmware: move loading timeout under struct firmware_fallback_config
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        cantabile.desu@gmail.com, kubakici@wp.pl,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, shuah@kernel.org,
        Martin Fuzzey <mfuzzey@parkeon.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Nicolas Broeking <nbroeking@me.com>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abhay Salunke <Abhay_Salunke@dell.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        jewalt@lgsinnovations.com, oneukum@suse.com,
        Alexei Starovoitov <ast@fb.com>,
        Andres Rodriguez <andresx7@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2018 at 11:56 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Mar 10, 2018 at 06:14:48AM -0800, Luis R. Rodriguez wrote:
>> The timeout is a fallback construct, so we can just stuff the
>> timeout configuration under struct firmware_fallback_config.
>
> Why?  What does it matter?

Because we want to remove direct access to things which the direct
firmware loader should not care about, and instead have proper
wrappers so that the fallback code implements it when needed. Part of
the motivation for this then was to move all fallback code into its
own file therefore compartmentalizing it.

>> While at it, add a few helpers which vets the use of getting or
>> setting the timeout as an int. The main use of the timeout is
>> to set a timeout for completion, and that is used as an unsigned
>> long. There a few cases however where it makes sense to get or
>> set the timeout as an int, the helpers annotate these use cases
>> have been properly vetted for.
>
> This feels really odd to me.  Why would you want to use it as an int,
> just keep it the same "size" everywhere and it should be simpler and
> easier to keep working correctly over time.

One is the input/output we provide for it uses ints all over so its
much easier to handle this as an int consistently in most places and
only deal with the long where needed. See above uses of
simple_strtol(), add_uevent_var(). Otherwise the inverse has to be
done. This was easier to deal with and vet for.

 Luis
