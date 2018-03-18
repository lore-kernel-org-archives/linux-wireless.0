Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752711AbeCRUUv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 16:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <20180314190039.GD15837@kroah.com>
References: <20180310141501.2214-1-mcgrof@kernel.org> <20180310141501.2214-12-mcgrof@kernel.org>
 <20180314190039.GD15837@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Sun, 18 Mar 2018 13:20:29 -0700
Message-ID: <CAB=NE6UWSdEUVzDo_stzkb2C8_FRZo9sS5d6oq9QJRME+JrGOw@mail.gmail.com> (sfid-20180318_212055_702422_AA4405EB)
Subject: Re: [PATCH v3 11/20] firmware: enable to force disable the fallback
 mechanism at run time
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Bitterblue of Monsea <cantabile.desu@gmail.com>,
        kubakici@wp.pl, linux-wireless <linux-wireless@vger.kernel.org>,
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

On Wed, Mar 14, 2018 at 12:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Mar 10, 2018 at 06:14:52AM -0800, Luis R. Rodriguez wrote:
>> You currently need four different kernel builds to test the firmware
>> API fully. By adding a proc knob to force disable the fallback mechanism
>> completely we are able to reduce the amount of kernels you need built
>> to test the firmware API down to two.
>>
>> Acked-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
>> ---
>>  drivers/base/firmware_loader/fallback.c       | 5 +++++
>>  drivers/base/firmware_loader/fallback.h       | 4 ++++
>>  drivers/base/firmware_loader/fallback_table.c | 9 +++++++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
>> index 45cc40933a47..d6838e7ec00c 100644
>> --- a/drivers/base/firmware_loader/fallback.c
>> +++ b/drivers/base/firmware_loader/fallback.c
>> @@ -643,6 +643,11 @@ static bool fw_force_sysfs_fallback(unsigned int opt_flags)
>>
>>  static bool fw_run_sysfs_fallback(unsigned int opt_flags)
>>  {
>> +     if (fw_fallback_config.ignore_sysfs_fallback) {
>> +             pr_info_once("Ignoring firmware sysfs fallback due to debugfs knob\n");
>
> s/debugfs/sysctl/ right?

Indeed. Will respin with the other space fix. As for the other changes
let me know if you have further feedback or if I should just keep them
as-is.

  Luis
