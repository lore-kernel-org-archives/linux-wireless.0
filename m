Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:32981 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbdATNEf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 08:04:35 -0500
Received: by mail-yb0-f169.google.com with SMTP id w194so52624421ybe.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 05:04:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6e5d0596c4af46668c02356ba17a4e5f@euamsexm01a.eu.qualcomm.com>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com> <6e5d0596c4af46668c02356ba17a4e5f@euamsexm01a.eu.qualcomm.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 20 Jan 2017 13:56:09 +0100
Message-ID: <CA+BoTQkutepRAGwE0xLiaGVqg5mXKFdjS26jDdxajkAsQRPuLA@mail.gmail.com> (sfid-20170120_140438_481445_9CC9D2CB)
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2017 at 13:51, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> wrote:
>> Firmware files are versioned to prevent older
>> driver instances to load unsupported firmware
>> blobs. This is reflected with a fallback logic
>> which attempts to load several firmware files.
>>
>> This however produced a lot of unnecessary
>> warnings sometimes confusing users and leading
>> them to rename firmware files making things even
>> more confusing.
>>
>> Hence use request_firmware_direct() which does not
>> produce extra warnings. This shouldn't really
>> break anything because most modern systems don't
>> rely on udev/hotplug helpers to load firmware
>> files anymore.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This ended into a rather long discussion, see the full thread from the pa=
tchwork link
> below, but I'll try to summarise it here:
>
> * Nobody stepped up and mentioned that they need/use the user fallback he=
lper with ath10k.
>
> * Felix confirmed that LEDE creates the calibration file before loading a=
th10k
>   so this should not break LEDE.
>
> * This also fixes a 60 second delay per _each_ unexistent firmware/calibr=
ation
>   file with distros which have CONFIG_FW_LOADER_USER_HELPER_FALLBACK enab=
led,
>   RHEL being a notable example. Using ath10k with firmware-2.bin this mig=
ht
>   end up into a five minute delay in boot.
>
> * Luis is working on new drvdata interface for kernel, but that's not mer=
ged yet.
>
> Based on this I think the right approach is to apply this patch. Any conc=
erns?
>
> While writing this I started to suspect is it just by accident that
> request_firmware_direct() does not print any error messages and
> request_firmware() again does print those? Let's hope nobody decides to c=
hange
> that.  And at least Luis' drvdata interface has a documented 'optional' f=
lag,
> so we can always switch to using that (once it's merged):
>
> * struct drvdata_req_params - driver data request parameters
> * @optional: if true it is not a hard requirement by the caller that this
> *       file be present. An error will not be recorded if the file is not
> *       found.
>
> Michal, do you mind if I'll add more info to the commit log and submit th=
is RFC
> as a proper patch? It still seems to apply and work just fine.

I don't mind :)


Micha=C5=82
