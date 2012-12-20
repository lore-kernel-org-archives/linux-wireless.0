Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:62060 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2LTK7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 05:59:41 -0500
Received: by mail-vc0-f181.google.com with SMTP id gb30so3508359vcb.40
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2012 02:59:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20121220T112036-707@post.gmane.org>
References: <loom.20121219T172801-213@post.gmane.org> <loom.20121220T112036-707@post.gmane.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 20 Dec 2012 11:28:15 +0100
Message-ID: <CA+XFjir7D5eCMrS+4FTDJdon3RZh4UXRmgzJY7NmRS3Z6RZetg@mail.gmail.com> (sfid-20121220_115950_602072_B95DC720)
Subject: Re: Incoherency in iw (or mac80211 or drivers) behavior -- possible
 BUG in iwl4965
To: Danilo <dantard@unizar.es>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 20, 2012 at 11:25 AM, Danilo <dantard@unizar.es> wrote:
> Danilo <dantard@...> writes:
>
>>
>> Hello,
>> I figured out that the command:
>>
>> iw dev wlan0 set bitrates legacy-5 24
>>
>> has different behaviors in different devices.
>>
>> With iwl3945 wireless cards, it fixes the rate at 24Mbps ALSO for multicast
>> frames while in iwl4965 cards, it doesn't.
>>
>> In both cases I tried with ubuntu linux 12.04 and kernel-3.2.0-32-generic
> using
>> iwl4965/iwl_legacy driver for 4965 and iwl3945/iwl_legacy driver for 3945.
>>
>> I've also tried with compat-wireless-3.6, same result.
>>
>> What's the expected behavior?
>>
>> Thanks in advance,
>>  D. Tardioli
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@...
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
> Hello,
> I answer myself:
> I've tried with ath5k-compatible card and it behaves like iwl3945.
> It means that when fixed the bitrates with a single value, the card always use
> that bitrate ALSO for broadcast frames.
>
> The iwl4965 doesn't behave this way.
> Any suggestion on how to solve the problem?

IIRC iwl4965 uses its own rate control algorithm (a while ago, it was
called "iwl-agn-rs", before the iwlegacy split). I think you should
look for the problem there.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
