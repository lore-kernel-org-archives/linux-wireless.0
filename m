Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758920AbcHYPNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:13:46 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Lobachevskii Vitalii <silverunicorn2011@yandex.ru>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce
References: <321381b3-5dea-f16a-56cb-11120d4a38ef@yandex.ru>
        <72b958e1-0200-cd6f-2012-e04ff6fb74cb@yandex.ru>
        <wrfjmvk1asxp.fsf@redhat.com>
        <6f06ce56-6289-6931-973f-1c52886e2b45@lwfinger.net>
Date: Thu, 25 Aug 2016 11:13:45 -0400
In-Reply-To: <6f06ce56-6289-6931-973f-1c52886e2b45@lwfinger.net> (Larry
        Finger's message of "Thu, 25 Aug 2016 09:59:30 -0500")
Message-ID: <wrfjpoow9906.fsf@redhat.com> (sfid-20160825_171710_534863_A49F522A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 08/25/2016 08:17 AM, Jes Sorensen wrote:
>> Lobachevskii Vitalii <silverunicorn2011@yandex.ru> writes:
>> The realtek devices all require firmwere to operate correctly,
>> including the 8192c series. There are a bunch of commands flying back
>> and forth between the driver and the firmware.
>>
>> If your device happens to work without loading the firmware then you
>> have an old firmware blob loaded.
>>
>> At least this is the case for the USB version of the device, and I find
>> it highly unlikely the PCIe version is any different.
>>
>> Trying to remove the firmware loading error is just plain silly.
>
> I have not bothered my Realtek contacts with such a question, but I
> have a plausible explanation. If an RTL8192CE functions without
> loading external firmware, it is because the device has minimal
> function built in the default firmware. Mostly this rudimentary
> firmware is used to boot the device and to download the firmware for
> complex wireless communication. Rudimentary wifi functions would be
> needed for wake-on-lan operations. The fact that Realtek has never
> implemented WOL for the 8192C chips is highly suggestive that they do
> not function very well in that capacity.
>
> If the RTL8192CE actually runs without loading external firmware, then
> I am quite sure that it will be restricted to 802.11g at the most, and
> more likely 802.11b. If it handles any 802.11n capabilities, then that
> firmware will certainly not have any of the bug fixes applied to the
> firmware since the earliest release.
>
> You are certainly allowed to configure your system any way you want,
> but please do not send any such "fixes" to the kernel sources. They
> will NEVER be accepted!
>
> Configuring a kernel without firmware loading capacity is indeed silly.

Makes perfect sense, but as you also correctly point out, it means the
device actually is running some firmware, but we have no idea what state
or version it is. Trying to run a device with this level of firmware is
both risky and makes it hard to rely on correct operation.

Of course it also makes this whole ostrich process even more pointless,
since the device is in fact running firmware - pretending it isn't is
just silly.

One more thing, yes you can apply this patch to your own degraded
kernel, but if you ship it, kindle remove ALL email addresses of any
driver authors in it. None of us wants to waste our time on bug reports
because of this.

If you truly want to run your system without firmware, I hear there are
great bargains for NE2000 and 3c501 cards on ebay :)

Jes
