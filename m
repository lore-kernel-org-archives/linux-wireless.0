Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:38004 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZIMA42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 20:56:28 -0400
Received: by iwn8 with SMTP id 8so918889iwn.4
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2009 17:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AAB8B9E.1030508@gmail.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
	<40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
	<4AA9F22C.3090007@gmail.com> <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
	<4AAB8B9E.1030508@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 12 Sep 2009 17:56:11 -0700
Message-ID: <43e72e890909121756m550c41d0pe399f0994a050b50@mail.gmail.com>
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

On Sat, Sep 12, 2009 at 4:53 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/11/2009 09:23 AM, Luis R. Rodriguez wrote:
>> On Thu, Sep 10, 2009 at 11:46 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> I definitely agree with Nick here. Althought whole ath_ops will be hot
>>> cache after the first operation, there is no need to prolong hot paths
>>> by computing the op address and a call. Ok, read/write on PCI is pretty
>>> slow, but still...
>>
>> That is the way I had it originally before submission, and I
>> completely agree its reasonable to not incur additional cost at the
>> expense of having two separate read/write paths, and perhaps we should
>> only incur the extra cost on routines shared between
>> ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
>> penalty?
>
> Hardly there is a measurable one. As I wrote earlier one will wait ages
> for PCI in comparison to few load+call cycles.

Alright, this helps.

>> This is why I asked if someone can test and give measurable
>> differences over this. If there really isn't then that's not strong
>> point against it.
>
> Well, honestly I see no strong point for it. It rather looks like an
> obfuscation, not improvement.

It may be and for ath5k this is not a requirement, for ath9k however
we do need a way to share hw code and therefore we cannot keep
read/write ops as part of hw.c but more importantly we need something
to map READ_READ/REG_WRITE macros on hw.h which will work for both
ath9k and ath9k_htc.

>> Granted you can argue these new interfaces between
>> ath5k/ath9k/ath9k_htc would make things a little more complex, but I
>> would expect sharing the code will help in the end. And if these
>> interfaces are not acceptable I'm completely open to better suggested
>> alternatives.
>
> Ok, I think nothing more than this is needed:
> +static u32 ath5k_ioread32(void *hw_priv, u32 reg_offset)
> +{
> +       return ath5k_hw_reg_read(hw_priv, reg_offset)
> +}
> +
> +static void ath5k_iowrite32(void *hw_priv, u32 reg_offset, u32 val)
> +{
> +       ath5k_hw_reg_write(hw_priv, val, reg_offset);
> +}
> +
> +static struct ath_ops ath5k_common_ops = {
> +       .read = ath5k_ioread32,
> +       .write = ath5k_iowrite32,
> +};

That's fine for ath5k.

> What I wonder is why ath_ops has reg+val parameters in the opposite
> manner than the rest of kernel? It is error-prone.

Heh, yeah, that's just how the Atheros hw code was written, so I'll
change the common ops to match standard practice but don't want to
change the all the REG_READ/REG_WRITE macros, so ath9k stuff will just
do the flip.

  Luis
