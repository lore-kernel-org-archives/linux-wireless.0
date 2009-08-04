Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56337 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483AbZHDWXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:23:24 -0400
Received: by bwz19 with SMTP id 19so3359190bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 15:23:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908050006.02754.mb@bu3sch.de>
References: <83a869cd0907271349h248204at74cc1603419fc83b@mail.gmail.com>
	 <200908042358.15966.mb@bu3sch.de>
	 <83a869cd0908041503i74a7bd11uf85706aeaf95b611@mail.gmail.com>
	 <200908050006.02754.mb@bu3sch.de>
Date: Wed, 5 Aug 2009 00:23:23 +0200
Message-ID: <83a869cd0908041523m7b2be0c9t4ae21dc2e22c537@mail.gmail.com>
Subject: Re: [RESEND] [PATCHv2] b43 add harware tkip
From: gregor kowski <gregor.kowski@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/5/09, Michael Buesch <mb@bu3sch.de> wrote:
> On Wednesday 05 August 2009 00:03:11 gregor kowski wrote:
>> On 8/4/09, Michael Buesch <mb@bu3sch.de> wrote:
>> > On Tuesday 04 August 2009 23:54:42 gregor kowski wrote:
>> >
>> > You always talk about "bugs". What are these "bugs"? Is it just the
>> > wrong
>> > max_nr_keys assignment? That's trivial to fix.
>> >
>> So [1] is ok ?
>
> Could you answer my question?
That's [1]. But may be my description wasn't good.
I will try a new one.
we can have up to 50 pairwise keys (due to RCMTA and tkip stuff).

In the case of new API :
- max_nr_keys is set to 58
- in b43_key_clear we call do_key_write for index in [0 ... 58]
- in do_key_write we call keymac_write for index in [4 ... 58]
- in keymac_write write to RCMTA index [0 ... 54]
We write too much pairwise keys.

- max_nr_keys is set to 58
- b43_key_write generate pairwise keys in [sta_keys_start ...
max_nr_keys] = [0 ... 58] and call do_key_write
- in do_key_write we call keymac_write for index in [4 ... 58]
- in keymac_write write to RCMTA index [0 ... 54]
We write too much pairwise keys.

So max_nr_keys seems wrong in case of new API.

Gregor.
[1]
> if  b43_new_kidx_api is true :
> - we set max_nr_keys to 58
> - we program B43_MMIO_RCMTA_COUNT to 50
> - in b43_key_write we can allocate key up to index 58 (4 for default,
> 54 for sta)
>
> But there is only 50 entries for TKIPTSCTTAK, and a comment on bcm-v4
> suggest there is 50 entries for RCMTA. So if there more than 50
> station we will overflow RCMTA and TKIPTSCTTAK.
