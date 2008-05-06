Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:37838 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761559AbYEFMfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 08:35:47 -0400
Date: Tue, 6 May 2008 14:35:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, kaszak@gmail.com,
	lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und: fixed nasty stack overflow, I can actually ssh over
	this
Message-ID: <20080506123536.GM32591@elte.hu> (sfid-20080506_143525_126406_1A5D8FFF)
References: <20080505205617.GD7273@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080505205617.GD7273@elf.ucw.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Pavel Machek <pavel@suse.cz> wrote:

> Removed nasty stack overflow, and got transmit of big packets to work. 
> I can now actually do ssh over softmac-based driver.
> 
> Unindent code to make it more readable.

> --- a/arch/x86/kernel/traps_32.c
> +++ b/arch/x86/kernel/traps_32.c
> @@ -146,11 +146,16 @@ static inline unsigned long print_contex
>  				unsigned long *stack, unsigned long bp,
>  				const struct stacktrace_ops *ops, void *data)
>  {
> +	int max = 5;
>  	struct stack_frame *frame = (struct stack_frame *)bp;
>  
>  	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
>  		unsigned long addr;
>  
> +		if (!max)
> +			return;
> +		max--;
> +

hm, you got into an infinite loop here, right? Could you please send 
this bit as a separate patch - and i guess it should use 
kstack_depth_to_print instead of '5'?

	Ingo
