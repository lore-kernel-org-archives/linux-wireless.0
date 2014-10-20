Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:49787 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaJTEwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 00:52:38 -0400
Received: by mail-oi0-f54.google.com with SMTP id v63so3147104oia.27
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2014 21:52:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
	<1413510814.22769.6.camel@dcbw.local>
	<1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
Date: Mon, 20 Oct 2014 07:52:37 +0300
Message-ID: <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com> (sfid-20141020_070305_809867_96B4CBEB)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2014 at 11:48 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> Hello,
>
> Sorry for the late reply. I was using just wpa_supplicant. I also tried
> wicd, but it seems to hang when connecting to a network, but my
> understanding is that it's just a wpa_supplicant manager. I got this
> while installing Gentoo, but I also reproduced it on the Fedora 20 Live
> CD. See https://bpaste.net/show/7d5ad99260a7 for logs, but it doesn't
> seem to say much more than my original extract.
>
> What I found out in the meanwhile, however, is that active traffic will
> prevent the issue from occurring. This happened with the Fedora Live CD,
> but pinging the AP is also sufficient. I noticed iwconfig reports that
> the power saving mode is off.
>
> For what it's worth, I compiled my kernel and iwlwifi module with
> tracing on, so tell me if I should try that.

Please recompile with MAC80211_MLME_DEBUG, MAC80211_STA_DEBUG and
reproduce - thanks.

>
> Laurentiu
>
>
> On Fri, Oct 17, 2014, at 04:53, Dan Williams wrote:
>> On Thu, 2014-10-16 at 15:48 +0300, Laurențiu Nicola wrote:
>> > Hello,
>> >
>> > I'm using iwlwifi for a Centrino Ultimate-N 6300 on 3.14.4 and 3.17.1.
>> > Connect to my wireless network works, but I get disconnected every 60
>> > seconds or so. The dmesg output looks like
>> > https://bpaste.net/show/1623a8ae5dc6 .
>> >
>> > I had the same issue on the three latest firmware versions:
>> > iwlwifi-6000-ucode-9.176.4.1
>> > iwlwifi-6000-ucode-9.193.4.1
>> > iwlwifi-6000-ucode-9.221.4.1
>> >
>> > The dmesg log actually shows the driver loading the different versions
>> > above.
>> >
>> > It's the first time I try to use wireless on Linux, so I might have made
>> > a dumb mistake.
>>
>> Can you try to get debug output from wpa_supplicant, which is the
>> process that controls WiFi on Linux?  What distro and version do you
>> use, and do you know what WiFi management service is being used?
>> (NetworkManager, conman, plain wpa_supplicant, wicd, something else?)
>>
>> Dan
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
