Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbeCNWgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 18:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <20180314185347.GA15837@kroah.com>
References: <20180310141501.2214-1-mcgrof@kernel.org> <20180310141501.2214-6-mcgrof@kernel.org>
 <20180314185347.GA15837@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Wed, 14 Mar 2018 15:36:32 -0700
Message-ID: <CAB=NE6Ur+hHN6HHBzafJXQ_G9AJggHPKd-jvrPmB79k98aTMDw@mail.gmail.com> (sfid-20180314_233709_672270_C5F914E9)
Subject: Re: [PATCH v3 05/20] firmware: simplify CONFIG_FW_LOADER_USER_HELPER_FALLBACK
 further
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

On Wed, Mar 14, 2018 at 11:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Mar 10, 2018 at 06:14:46AM -0800, Luis R. Rodriguez wrote:
>> All CONFIG_FW_LOADER_USER_HELPER_FALLBACK really is, is just a bool,
>> initailized at build time. Define it as such. This simplifies the
>> logic even further, removing now all explicit #ifdefs around the code.
>>
>> Acked-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
>> ---
>>  drivers/base/firmware_loader.c | 25 ++++++++++++++++++-------
>>  1 file changed, 18 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
>> index 7dd36ace6152..59dba794ce1a 100644
>> --- a/drivers/base/firmware_loader.c
>> +++ b/drivers/base/firmware_loader.c
>> @@ -266,6 +266,22 @@ static inline bool fw_state_is_aborted(struct fw_priv *fw_priv)
>>
>>  #ifdef CONFIG_FW_LOADER_USER_HELPER
>>
>> +/**
>> + * struct firmware_fallback_config - firmware fallback configuratioon settings
>> + *
>> + * Helps describe and fine tune the fallback mechanism.
>> + *
>> + * @force_sysfs_fallback: force the sysfs fallback mechanism to be used
>> + *   as if one had enabled CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y.
>> + */
>> +struct firmware_fallback_config {
>> +     bool force_sysfs_fallback;
>> +};
>
> This is C, why are you messing around with a structure and "getters and
> setters" for a set of simple values?
>
>> +static const struct firmware_fallback_config fw_fallback_config = {
>> +     .force_sysfs_fallback = IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK),
>> +};
>
> static bool force_sysfs_fallback = IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK);

For this case yes, but I later expand on this structure for all
fallback configuration items. So we have to start it somewhere.

> Then just read/write the foolish thing, don't make this more complex
> than is needed please.

Please read the final results and let me know what you think.

> There is a "getter and setters are evil" rant somewhere out there
> online, if you really need me to dig up the old tired arguments :)

I don't use them for sport, I use them given the fallback stuff *is*
not something the direct core firmware code should use openly, it will
really depend on if the fallback interface was enabled. As such we
provide wrapper for access into them.

  Luis
