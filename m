Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:7690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZILLwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 07:52:54 -0400
Received: by fg-out-1718.google.com with SMTP id 22so159885fge.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2009 04:52:57 -0700 (PDT)
Message-ID: <4AAB8B9E.1030508@gmail.com>
Date: Sat, 12 Sep 2009 13:53:02 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com> 	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com> 	<40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com> 	<4AA9F22C.3090007@gmail.com> <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
In-Reply-To: <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2009 09:23 AM, Luis R. Rodriguez wrote:
> On Thu, Sep 10, 2009 at 11:46 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> I definitely agree with Nick here. Althought whole ath_ops will be hot
>> cache after the first operation, there is no need to prolong hot paths
>> by computing the op address and a call. Ok, read/write on PCI is pretty
>> slow, but still...
> 
> That is the way I had it originally before submission, and I
> completely agree its reasonable to not incur additional cost at the
> expense of having two separate read/write paths, and perhaps we should
> only incur the extra cost on routines shared between
> ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
> penalty?

Hardly there is a measurable one. As I wrote earlier one will wait ages
for PCI in comparison to few load+call cycles.

> This is why I asked if someone can test and give measurable
> differences over this. If there really isn't then that's not strong
> point against it.

Well, honestly I see no strong point for it. It rather looks like an
obfuscation, not improvement.

> For example, long ago I had argued over the cost incurred over the
> unnecessary branching on ioread()/iowrite() when you know you have
> MMIO devices [1] -- the defense then, and IMHO reasonable now, was
> that the benefits of allowing cleaner drivers through the new
> interfaces outweigh the theoretical penalties imposed by them.

Ok, that one has benefits. You just needn't care about what is behind
that mapping. It will choose a PIO or MMIO op on its own.

When it's always MMIO I personally prefer simple ioremap though. (I
didn't at the time of merging the driver.)

> Granted you can argue these new interfaces between
> ath5k/ath9k/ath9k_htc would make things a little more complex, but I
> would expect sharing the code will help in the end. And if these
> interfaces are not acceptable I'm completely open to better suggested
> alternatives.

Ok, I think nothing more than this is needed:
+static u32 ath5k_ioread32(void *hw_priv, u32 reg_offset)
+{
+	return ath5k_hw_reg_read(hw_priv, reg_offset)
+}
+
+static void ath5k_iowrite32(void *hw_priv, u32 reg_offset, u32 val)
+{
+	ath5k_hw_reg_write(hw_priv, val, reg_offset);
+}
+
+static struct ath_ops ath5k_common_ops = {
+	.read = ath5k_ioread32,
+	.write = ath5k_iowrite32,
+};

What I wonder is why ath_ops has reg+val parameters in the opposite
manner than the rest of kernel? It is error-prone.
