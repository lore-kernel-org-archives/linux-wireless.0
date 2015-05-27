Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35646 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbbE0A1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 20:27:16 -0400
Received: by lbbuc2 with SMTP id uc2so81927481lbb.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 17:27:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55650565.6020303@gmail.com>
References: <55605637.1080503@gmail.com>
	<CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com>
	<55650565.6020303@gmail.com>
Date: Wed, 27 May 2015 03:27:15 +0300
Message-ID: <CANUX_P3xRgUdNx_1h-pisaYcTiFGiPZjyvkdhnFQj05oMHSQVA@mail.gmail.com> (sfid-20150527_022720_922967_1B0D8336)
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nick Dimov <dimovnike@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2015 at 2:44 AM, Nick Dimov <dimovnike@gmail.com> wrote:
> Hello,
> thank you for your response. I attach the full syslog since the last
> boot which contains some disconnects. I enabled debug mode for
> wpa_supplicant with -dd option (let me know if you need anything else).
>
> I also tried connecting directly, i.e. without NetworkManager but
> manually with wpa_supplicant and I still get disconnects, howvever
> wpa_supplicant gives different logs with different drivers. Please, see
> the file wifi.log (you can see there the driver i used in
> wpa_supplicant, that log doesn't have the debug activated but let me
> know if you need that too)

Please record tracing
(https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging#tracing)
and the syslog from the *same run*. Someone is disconnecting you and I
can't see who and why. Are you sure you have only one instance of the
supplicant running?

>
> Thank you again,
> Nick.
>
> On 25.05.2015 14:33, Emmanuel Grumbach wrote:
>> On Sat, May 23, 2015 at 1:28 PM, Nick Dimov <dimovnike@gmail.com> wrote:
>>> Hello,
>>> I recently bought the Intel 7260 AC wifi card (below is the PCI info)
>>> and the card works perfectly in windows with the latest intel driver but
>>> in linux I get deauthenticating and disconnects (reason -3) every minute
>>> or so. When these disconnects happen I get packet loss. In the attached
>>> file iwlwifi_dmesg.txt you can see the log that is produced each time a
>>> disconnect happens. I also tried connecting on 2.4Ghz but I get the same
>>> packet loss. I also put the last firmware from
>>> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
>>> but it did not help.
>> Please increase the debug level of the supplicant. And attach the full syslog.
>>
>>> There is also another problem: In windows i can see it connecting on
>>> 860mbps, but on linux it never goes higher than 600mbps (i check this
>>> with iwconfig) and it stays somewhere on 500mbps.
>>>
>>> Can you please help me solve this?
>>> Thank you.
>>>
>>> uname -a
>>> Linux nick-laptop 3.19.0-18-generic #18-Ubuntu SMP Tue May 19 18:31:35
>>> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> lspci info:
>>> 03:00.0 Network controller: Intel Corporation Wireless 7260 (rev bb)
>>>         Subsystem: Intel Corporation Dual Band Wireless-AC 7260
>>>         Flags: bus master, fast devsel, latency 0, IRQ 29
>>>         Memory at f7200000 (64-bit, non-prefetchable) [size=8K]
>>>         Capabilities: [c8] Power Management version 3
>>>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>>         Capabilities: [40] Express Endpoint, MSI 00
>>>         Capabilities: [100] Advanced Error Reporting
>>>         Capabilities: [140] Device Serial Number d8-fc-93-ff-ff-e4-70-d7
>>>         Capabilities: [14c] Latency Tolerance Reporting
>>>         Capabilities: [154] Vendor Specific Information: ID=cafe Rev=1
>>> Len=014 <?>
>>>         Kernel driver in use: iwlwifi
>>>
>
