Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44514 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbeITU3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 16:29:21 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1b3e46335094bda8dfef48c74adf2d027e9417ca.camel@intel.com>
References: <CA+icZUXxcxZvyo7ge33E_1PSnjUs7Lq=BdcX2rbB6pYka1S=cA@mail.gmail.com>
 <1b3e46335094bda8dfef48c74adf2d027e9417ca.camel@intel.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Thu, 20 Sep 2018 16:45:30 +0200
Message-ID: <CA+icZUVUkLZxqqNocBg27_Q=xvtDbfuW7z1ZcDx+WNO0uDwuOA@mail.gmail.com> (sfid-20180920_164536_511222_532BBFD0)
Subject: Re: acpi/iwlwifi: thermal thermal_zone3: failed to read out thermal
 zone (-61)
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2018 at 4:34 PM, Luciano Coelho
<luciano.coelho@intel.com> wrote:
> On Thu, 2018-09-20 at 15:42 +0200, Sedat Dilek wrote:
>> Hi,
>
> Hi,
>
>
>> I am seeing this with Linux v4.18.y and v4.19-rc4.
>>
>> Investigating thermal_zone3...
>>
>> # cat /sys/devices/virtual/thermal/thermal_zone3/type
>> iwlwifi
>>
>> I have the following iwlwifi device and firmware installed...
>>
>> [   10.476589] iwlwifi 0000:04:00.0: loaded firmware version
>> 36.e91976c0.0 op_mode iwlmvm
>> [   10.519441] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
>> Wireless AC 8265, REV=0x230
>>
>> What informations do you need and how can I help?
>
> This is normal, though annoying, and was discussed before.  The thermal
> framework is trying to read the temperature as soon as the zone is
> registered and this causes that warning.  Our device only provides the
> temperature when the device goes up, so reading before that will always
> fail.
>

OK, I understand.
Thanks.

- Sedat -
