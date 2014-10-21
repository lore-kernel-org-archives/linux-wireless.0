Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:54814 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaJUICW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 04:02:22 -0400
Received: by mail-oi0-f50.google.com with SMTP id i138so513617oig.23
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 01:02:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413876484.3481910.181413525.516B5A23@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
	<1413510814.22769.6.camel@dcbw.local>
	<1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
	<CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
	<1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
	<CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
	<CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
	<1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
	<CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
	<1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
	<CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
	<CANUX_P06VvZ0uugayOvhZK0iM-NetftN5rZA27TtkYku66cGXA@mail.gmail.com>
	<1413876484.3481910.181413525.516B5A23@webmail.messagingengine.com>
Date: Tue, 21 Oct 2014 11:02:22 +0300
Message-ID: <CANUX_P0dmtC5BVgYv23m6y8_GUDu+hXc+z8PNoS1yPWFUpaMtQ@mail.gmail.com> (sfid-20141021_100232_588611_FB919F94)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Lauren=C8=9Biu_Nicola?= <lnicola@dend.ro>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2014 at 10:28 AM, Laurențiu Nicola <lnicola@dend.ro> wrote:
> I have 3.17.1, which includes the patch you mention. I also verified
> that iwconfig reports that power management is disabled.
>
> I don't know how easy it is to recompile the DD-WRT kernel. One thing I
> could do is try another firmware instead of DD-WRT to see if the issue
> still occurs.
>

I guess you can try to use the vendor's firmware and see what happens.
Another option is try to tweak DD-WRT not to kick client out after 1 minute :)

> Laurentiu
>
> On Tue, Oct 21, 2014, at 08:31, Emmanuel Grumbach wrote:
>> On Tue, Oct 21, 2014 at 8:02 AM, Emmanuel Grumbach <egrumbach@gmail.com>
>> wrote:
>> > On Mon, Oct 20, 2014 at 10:29 PM, Laurențiu Nicola <lnicola@dend.ro> wrote:
>> >> No, nothing in the DD-WRT syslog. The IP seems to be the one cached by
>> >> my DHCP client. I also tried various suggestions found on the internet,
>> >> but nothing helped.
>> >>
>> >
>> > Can you please try to have another device in monitor mode to sniff the
>> > traffic going on?
>> > Felix, can you please tell me when DD-WRT can send a deauth with reason code 7?
>> >
>> > thanks.
>>
>> Can you please disable power save?
>> For this, please make sure you have
>> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=f8dfc607b2b460e8e8adfdfb3c5f5bba3a4ad01b
>> or at least have the module parameter.
>> I am wondering if the firmware is not sending frames because of power
>> save toggling.
>>
>> I you could get more extensive logs from the AP it'd be great.
>> Running tracing on the AP would let us know why it thinks we are not
>> associated.
>>
>>
>> >
>> >> Laurentiu
>> >>
>> >> On Mon, Oct 20, 2014, at 11:23, Emmanuel Grumbach wrote:
>> >>> On Mon, Oct 20, 2014 at 10:22 AM, Laurențiu Nicola <lnicola@dend.ro>
>> >>> wrote:
>> >>> > One thing that might be relevant is that, although there is a static
>> >>> > DHCP lease configured (which works on Windows), the router/AP is giving
>> >>> > the laptop a different IP address. The reported MACs are the same, of
>> >>> > course. I don't know whether wpa_supplicant remembers and requests the
>> >>> > last IP it had, but the lease was already present when I configured it.
>> >>> >
>> >>> > The router runs DD-WRT and I don't have problems on Windows or Android.
>> >>> >
>> >>>
>> >>> I guess you can try to get some logs from the DD-WRT - but if the AP
>> >>> doesn't
>> >>> give the same address to Linux as in Windows - there is something
>> >>> fishy...
>> >>>
>> >>> > Laurentiu
>> >>> >
>> >>> > On Mon, Oct 20, 2014, at 10:12, Emmanuel Grumbach wrote:
>> >>> >> On Mon, Oct 20, 2014 at 10:06 AM, Emmanuel Grumbach <egrumbach@gmail.com>
>> >>> >> wrote:
>> >>> >> > On Mon, Oct 20, 2014 at 8:30 AM, Laurențiu Nicola <lnicola@dend.ro> wrote:
>> >>> >> >> Here: https://bpaste.net/show/bf6dc1847ce3
>> >>> >> >>
>> >>> >> >
>> >>> >> > Are you sure you had MAC80211_MLME_DEBUG?
>> >>> >> >
>> >>> >> >>
>> >>> >> Ok - You probably had it - sorry. But apparently the AP is really kicking
>> >>> >> us...
>> >>> >> What AP do you have?
>> >>> >> --
>> >>> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> >>> >> in
>> >>> >> the body of a message to majordomo@vger.kernel.org
>> >>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>> --
>> >>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> >>> in
>> >>> the body of a message to majordomo@vger.kernel.org
>> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
