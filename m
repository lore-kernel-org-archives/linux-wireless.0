Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:41456 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZIKHXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 03:23:50 -0400
Received: by iwn8 with SMTP id 8so371664iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 00:23:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA9F22C.3090007@gmail.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
	<40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
	<4AA9F22C.3090007@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 11 Sep 2009 00:23:33 -0700
Message-ID: <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 11:46 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/11/2009 08:16 AM, Nick Kossifidis wrote:
>>>  static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
>>>  {
>>> -       return ioread32(ah->ah_iobase + reg);
>>> +       return ath5k_hw_common(ah)->ops->read(ah, reg);
>>>  }
>>>
>>> -/*
>>> - * Write to a register
>>> - */
>>>  static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
>>>  {
>>> -       iowrite32(val, ah->ah_iobase + reg);
>>> +       ath5k_hw_common(ah)->ops->write(ah, reg, val);
> ...
>> Since each driver will use it's own reg read/write functions (ath5k hw
>> code still uses ath5k_hw_reg_read/write), why do we need to have
>> common reg read/write functions like that used in the driver code ?
>> This makes the code more complex that it needs to be and i don't see a
>> reason why we need it. I understand why we need a way to handle
>> read/write functions from common ath code but i don't see a reason to
>> use these functions on ath5k, we can just fill ath_ops struct so that
>> common code can use them and leave ath5k_hw_read/write untouched.
>
> I definitely agree with Nick here. Althought whole ath_ops will be hot
> cache after the first operation, there is no need to prolong hot paths
> by computing the op address and a call. Ok, read/write on PCI is pretty
> slow, but still...

That is the way I had it originally before submission, and I
completely agree its reasonable to not incur additional cost at the
expense of having two separate read/write paths, and perhaps we should
only incur the extra cost on routines shared between
ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
penalty?

This is why I asked if someone can test and give measurable
differences over this. If there really isn't then that's not strong
point against it.

For example, long ago I had argued over the cost incurred over the
unnecessary branching on ioread()/iowrite() when you know you have
MMIO devices [1] -- the defense then, and IMHO reasonable now, was
that the benefits of allowing cleaner drivers through the new
interfaces outweigh the theoretical penalties imposed by them.

Granted you can argue these new interfaces between
ath5k/ath9k/ath9k_htc would make things a little more complex, but I
would expect sharing the code will help in the end. And if these
interfaces are not acceptable I'm completely open to better suggested
alternatives.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0709.2/1068.html

  Luis
