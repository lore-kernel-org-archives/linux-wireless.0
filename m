Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdHCFXM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 01:23:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Wagner <wagi@monom.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, yi1.li@linux.intel.com,
        atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>,
        pmladek@suse.com, Johannes Berg <johannes.berg@intel.com>,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        luto@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        David Howells <dhowells@redhat.com>, pjones@redhat.com,
        Hans de Goede <hdegoede@redhat.com>, alan@linux.intel.com,
        tytso@mit.edu, lkml <linux-kernel@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?=
        <rafal@milecki.pl>
Subject: Re: [PATCH V5 1/2] firmware: add more flexible request_firmware_async function
References: <20170731150945.8925-1-zajec5@gmail.com>
        <20170802213010.GM18884@wotan.suse.de>
Date: Thu, 03 Aug 2017 08:23:00 +0300
In-Reply-To: <20170802213010.GM18884@wotan.suse.de> (Luis R. Rodriguez's
        message of "Wed, 2 Aug 2017 23:30:10 +0200")
Message-ID: <878tj1ql6z.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_072327_915135_A80D3AD3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@kernel.org> writes:

>> +int request_firmware_nowait(struct module *module, bool uevent,
>> +			    const char *name, struct device *device, gfp_t gfp,
>> +			    void *context,
>> +			    void (*cont)(const struct firmware *fw, void *context))
>> +{
>> +	unsigned int opt_flags = FW_OPT_FALLBACK |
>> +		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
>> +
>> +	return __request_firmware_nowait(module, opt_flags, name, device, gfp,
>> +					 context, cont);
>> +}
>>  EXPORT_SYMBOL(request_firmware_nowait);
>>  
>> +int __request_firmware_async(struct module *module, const char *name,
>> +			     struct firmware_opts *fw_opts, struct device *dev,
>> +			     void *context,
>> +			     void (*cont)(const struct firmware *fw, void *context))
>> +{
>> +	unsigned int opt_flags = FW_OPT_UEVENT;
>
> This exposes a long issue. Think -- why do we want this enabled by default? Its
> actually because even though the fallback stuff is optional and can be, the uevent
> internal flag *also* provides caching support as a side consequence only. We
> don't want to add a new API without first cleaning up that mess.
>
> This is a slipery slope and best to clean that up before adding any new API.
>
> That and also Greg recently stated he would like to see at least 3 users of
> a feature before adding it. Although I think that's pretty arbitrary, and
> considering that request_firmware_into_buf() only has *one* user -- its what
> he wishes.

ath10k at least needs a way to silence the warning for missing firmware
and I think iwlwifi also.

-- 
Kalle Valo
