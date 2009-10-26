Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:45600 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZJZN15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:27:57 -0400
Message-ID: <4AE5A3DC.1090804@wpkg.org>
Date: Mon, 26 Oct 2009 14:27:56 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: "Reserved instruction in kernel code" on ath9k insertion
References: <4AE35A9E.8000507@wpkg.org> <43e72e890910260617n6efbd260gcafbf5d1d2c84e23@mail.gmail.com>
In-Reply-To: <43e72e890910260617n6efbd260gcafbf5d1d2c84e23@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Sat, Oct 24, 2009 at 12:50 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> When I do "modprobe ath9k" on ASUS-WL-500gP (MIPS) with _ath5k_ card (so, no
>> ath9k hardware), it says "Reserved instruction in kernel code" - is it
>> expected?
> 
> No.
> 
>> The kernel is 2.6.31.1.
>>
>>
>> # modprobe ath9k
>> [  165.440000] Reserved instruction in kernel code[#1]:
>> [  165.440000] Cpu 0
>> [  165.440000] $ 0   : 00000000 1000dc00 00000000 00000000
>> [  165.440000] $ 4   : c1135b20 00000001 c044e69c ffffffff
>> [  165.440000] $ 8   : 0000000a 8101f6d8 ffffffe0 0000002b
>> [  165.440000] $12   : 00000e44 00000006 80333ae8 5f657361
>> [  165.440000] $16   : 00000001 c1135ca4 80370000 81418000
>> [  165.440000] $20   : 00000000 00000000 00000000 004fe008
>> [  165.440000] $24   : 00000010 c1115118
>> [  165.440000] $28   : 81da6000 81da7ea8 7febead8 81418014
>> [  165.440000] Hi    : 00000000
>> [  165.440000] Lo    : 00000000
>> [  165.440000] epc   : c044e694 0xc044e694
>> [  165.440000]     Not tainted
> 
> This says not tainted.

(...)

>> [  165.440000] Disabling lock debugging due to kernel taint
> 
> But this says kernel taint.

Yep, I saw this as well.

About every oops or panic on this hardware says "Disabling lock 
debugging due to kernel taint", no idea why.



-- 
Tomasz Chmielewski
http://wpkg.org
