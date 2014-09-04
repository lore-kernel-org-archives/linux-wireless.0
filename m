Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47968 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaIDSLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 14:11:07 -0400
Received: by mail-lb0-f182.google.com with SMTP id u10so12174295lbd.27
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 11:11:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1409040956540.25615@admin.chi.technicality.org>
References: <CANUX_P1udm36NoF-dbOARa671VthuYfrEEz2ODSmkCgDzcRe8g@mail.gmail.com>
	<alpine.DEB.2.02.1409031720280.17274@admin.chi.technicality.org>
	<CANUX_P2ZqEo4pcVxcB1GHzaG8Fc3NqgBdr3Se8aGq+DXZPMLqQ@mail.gmail.com>
	<alpine.DEB.2.02.1409040956540.25615@admin.chi.technicality.org>
Date: Thu, 4 Sep 2014 21:11:05 +0300
Message-ID: <CANUX_P2wi3UKVopn2KpYTqBv_6SWuu4V+YH59Q_qerm_9Q2KRw@mail.gmail.com> (sfid-20140904_201114_943039_18E9AB8D)
Subject: Re: [ANN] new experimental firmware for 7260 / 3160 / 7265 - Core7
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nate Carlson <linux-wireless@natecarlson.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 4, 2014 at 6:02 PM, Nate Carlson
<linux-wireless@natecarlson.com> wrote:
> [responding to both messages at once here]
>
>
> On Thu, 4 Sep 2014, Emmanuel Grumbach wrote:
>>
>> If you want, you can apply this:
>
> <..>
>
>> You'll need the firmware attached, and load the driver with fw_monitor=1.
>> Then, when the error you mentioned will occur, it will crash the firmware on
>> purpose so that we can get the logs. You'll see lots of junk in dmesg.
>>
>> Once this happened, you can take the data from
>> /sys/kernel/debug/iwlwifi/0000\:01\:00.0/iwlmvm/fw_error_dump. This will
>> weigh around 4MB depending on the available memory in your system, this is
>> the data I need to give to the firmware team.
>
>
> I will give this a try later on -- I'm testing this on my real laptop, and
> am in the middle of a project, so can't reboot at the moment (I love Linux -
> if a driver pukes, just reload it and reconnect, no need to reboot!)
>
>
>> I just saw something weird...
>>
>> The Q 16 is still working while we flush:
>
> <...>
>
>> can you please re-run with trace-cmd -e iwlwifi -iwlwifi_msg -e
>> mac80211 and send the trace.dat output.
>
>
> Sure! I'm new to this; did a bit of RTFM'ing, and I'm guessing that the
> command should actually be:
>
> trace-cmd record -e iwlwifi -e iwlwifi_msg -e mac80211
>

yeah - you're right obviously :)

> ..and that I should wait until the issue occurs again with this running, and
> then hit ctrl-c, gpg-encrypt the trace.dat and send it to you?  (Or should I
> open a bugzilla and attach the encrypted file there?)
>
> If any of that's incorrect, let me know.
>
> The issue did already happen again today - unfortunately I hadn't gotten to
> firing up the trace-cmd yet.. so hopefully it'll happen again.  :)
>
> Thanks!
>
> -Nate
