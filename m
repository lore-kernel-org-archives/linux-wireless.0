Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35001 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1CXQvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 12:51:55 -0400
Received: by qyk7 with SMTP id 7so5443489qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 09:51:54 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D86B222.4070708@lockie.ca>
References: <4D866BD1.9060904@lockie.ca>
	<4D86B222.4070708@lockie.ca>
Date: Thu, 24 Mar 2011 17:51:54 +0100
Message-ID: <AANLkTik+AjhMBwRy9ESaidnuW+1YCSZiEzeWdFnmZnqS@mail.gmail.com>
Subject: Re: kernel-2.6.36.2 works, later doesn't
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 3:04 AM, James <bjlockie@lockie.ca> wrote:
> On 03/20/11 17:04, James wrote:
>> $ dmesg | grep phy
>> BIOS-provided physical RAM map:
>> modified physical RAM map:
>> phy0: Selected rate control algorithm 'ath9k_rate_control'
>> Registered led device: ath9k-phy0::radio
>> Registered led device: ath9k-phy0::assoc
>> Registered led device: ath9k-phy0::tx
>> Registered led device: ath9k-phy0::rx
>> phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
>> mem=0xffffc90001900000, irq=17
>>
>> This is kernel-2.6.36.2.
>> The wireless doesn't work on any later kernel that I have tried.
>> It is very interesting the IRQ is 17 on this kernel but 18 on 2.6.37.3.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> I tried
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/compat-wireless-2.6.36-4.tar.bz2
> but it doesn't work in the 2.6.36.2 kernel or the 2.6.38 kernel.
>
> Where can I get the compat-wireless that is the exact code that is in
> the 2.6.36.2 kernel and then I can try it in the 2.6.38 kernel?
>

The idea of compat-wireless is to make new wifi drivers & features
accessible for older host-kernel, not the other way around.
It also makes no sense to have same versions of host kernel and c-w
version (both 2.6.36 for example, it is the same codebase).

Did you try one of the bleeding-edge compat-wireless [1] tarball (it
is updated daily, but can be broken)?
Furthermore, [2] has informations about stable releases and detailed
build instructions.

Please provide full dmesg and lspci/lsusb output - not truncated one.
Which user-space do you use? Network-Manager, wpasupplicant, etc.?

- Sedat -

[1] http://wireless.kernel.org/en/users/Download/#Where_to_download_bleeding_edge
[2] http://wireless.kernel.org/en/users/Download/stable/
