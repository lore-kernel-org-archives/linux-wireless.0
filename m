Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirapoint7.brutele.be ([212.68.199.151]:14945 "EHLO
	mirapoint7.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1B0VhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 16:37:19 -0500
Message-ID: <4D6AC2A5.5070408@tvcablenet.be>
Date: Sun, 27 Feb 2011 22:31:17 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Mathieu Malaterre <mathieu.malaterre@gmail.com>,
	Larry.Finger@lwfinger.net
Subject: Re: Realtek RTL8192SE support ? (aka r8192se_pci)
References: <AANLkTinoU0Dxy2iAHEsprTbakrbs8a8vPARFW0odz4g9@mail.gmail.com> <4D628D75.1070907@lwfinger.net> <AANLkTim-=h6N5a=4gaA+42xoWHk3PY1jM8FU9fkJ3CJp@mail.gmail.com> <4D62963D.9020806@lwfinger.net>
In-Reply-To: <4D62963D.9020806@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 21/02/11 17:43, Larry Finger a écrit :
> On 02/21/2011 10:12 AM, Mathieu Malaterre wrote:
>> On Mon, Feb 21, 2011 at 5:06 PM, Larry
>> Finger<Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@public.gmane.org>  wrote:
>>> On 02/21/2011 03:35 AM, Mathieu Malaterre wrote:
>>>>
>>>> Dear all,
>>>>
>>>>    As far as I know driver for rtl8192su will be added to kernel
>>>> 2.6.38. By any chance does anyone knows if rtl8192se will make it into
>>>> this release ?
>>>
>>> As part of our collaborative effort, Realtek has sent me a
>>> mac80211-based
>>> driver for the RTL8192SE. It will be submitted to the wireless
>>> mailing list
>>> for review once the driver for the RTL8192CU is accepted. The
>>> earliest this
>>> would happen is 2.6.39, but I think 2.6.40 is more realistic. I also
>>> have a
>>> driver for the RTL8192DE that will follow the RTL8192SE.
>>
>> Dear Larry,
>>
>>    Thank you very much for taking the time to answer my question.
>>    Would it be possible to be part of some kind of testing group for
>> this 'new' driver. I have been using r8192se_pci (*) for a couple of
>> days, but I have the feeling this driver keeps filling in my
>> computer's memory. I have to reboot to clean the memory (I have not
>> found any other way).
>>
>> Using linux 2.6.37 from debian unstable
> 
> It will take me a few days, but I should be able to send you patches to
> incorporate the rtl8192se driver.
> 
> Larry
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
I also volunteer to test this new driver. I often have problems with the
current driver provided by Realtek. It seems the connexion is quite
unstable and I often get kernel panic like this one:

rtl8192se_rx_normal+0x143/0x400
scheduler-tick+0xe1/0x2f0
tasklet-action+0xa8/0x60
_do_softirq+0xa5/0x130
ack_apic_level+0x6d/0x210
call_softirq+0x1c/0x30
do_softirq+0x4d/0x80
irq_exit+0x8d/0x90
do_irq+0x6b/0x0
ret_from_intr+0x0/0x	
[<EOI>]

acpi_idle_enter_c1+0xad/0xc7 [processor]
ack-idle-enter-c1+0x8d/0xc7 [processor]
cpuidle-idle-call+0x8c/0xf0
cpu-idle+0x58/0xb
skb-put+0x88/0x90

kernel panic not syncing fatal exception in interrupt PID: 0, comm:
kworker/0;1 Tainted G D 2.6.36

call trace:
panic+0xa1/0x1a3
oops_end+0xaf/0xe0
do_invalid_op+0x84/0xa0
skb_put+0x88/0x90
invalid_op+0x15/0x20
skb_put+0x88/0x90

I already asked realtek support about this but I didn't get a lot of
help from them. So, I would be interested to see if the new driver you
talked about perfoms better.

Thanks in advance,

François Valenduc
