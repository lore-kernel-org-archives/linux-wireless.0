Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45857 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab2CEKmc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 5 Mar 2012 05:42:32 -0500
Received: by bkcik5 with SMTP id ik5so2975256bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 02:42:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<CAD2nsn2GLAo=8xhe+-Xm0igSmQ+tr1F+Q6scuFaeaQWMYrQbwg@mail.gmail.com>
	<CALx5=V9LwpWVG0UGLgyNyJVrSYj826xXwbEcFQVYM5BxAxnEJQ@mail.gmail.com>
Date: Mon, 5 Mar 2012 18:42:20 +0800
Message-ID: <CALx5=V9HK8F_Y08jq2bu1iii+JdbqFsN67xZQM6ZaFScPOQQtw@mail.gmail.com> (sfid-20120305_114235_597800_E19190E4)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Matt Chen <machen@suse.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

2012/3/5 Matt Chen <machen@suse.com>:
> Hi,
>
> 2012/3/1 Mohammed Shafi <shafi.wireless@gmail.com>:
>> On Wed, Feb 29, 2012 at 4:33 PM, Matt Chen <machen@suse.com> wrote:
>>> Hi list,
>>>
>>> I am working on verifying the ath9k_rfkill_poll_state() function. It
>>> would execute the ath_is_rfkill_set() the read the GPIO and change the
>>> LED. I found the POLL_INTERVAL would take 5 secs according the
>>> definition in net/rfkill/core.c
>>> #define POLL_INTERVAL (5 * HZ)
>>> So it would detect the GPIO status in every 5 seconds. But the ath9k I
>>> run in different platform, with the same modules, it works different
>>> way. The LED for one is working very fast, in another one is working
>>> so slow.
>>>
>>> I would like to clarify it is driver or BIOS issues. The way I come
>>> out is manually to change the GPIO status, see how the driver work.
>>> But so far I only found the devmen2 to access the specific address of
>>> GPIO. Any other good ways recommended ?
>>> And another question is the address defined in reg.h correct to access
>>> ? Such as
>>> #define AR_GPIO_IN    (AR_SERV_9340(ah)) ? 0x402c : 0x404c)
>>> can I access the value of 0x404c directly?
>>
>> yes you can, one idea i have is to enable ath9k debug
>> http://linuxwireless.org/en/users/Drivers/ath9k/debug
>> and echo 0x404c in the regidx field in debug and keep looking for regval,
>> in which the corresponding rfkill related bit may toggle,  when the
>> rfkill is enabled
> echo 0x404c to which file in /sys/kernel/debug/ath9k ?
I think I got it.
Thanks
> Thanks
>>>
>>> Thank you for your patience. :)
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> thanks,
>> shafi
>>
