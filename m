Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:42008 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993103AbXCIKSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 05:18:53 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1266906uga
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2007 02:18:52 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 4/4] rt2x00: Fix power of 2 check
Date: Fri, 9 Mar 2007 11:18:39 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <200703082214.52864.IvDoorn@gmail.com>
In-Reply-To: <200703082214.52864.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703091118.39371.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 March 2007 22:14, Ivo van Doorn wrote:
> Cleanup code, make gcc happy, make sparse happy. What a happy patch ;)
> This cleans up the code used to check the validity of the register fields,
> this will also reduce the required memory usage while working with sparse.
> This patch was inspired on the codesuggestions from Linus.

Please cancel this 4th patch, the previous 3 were correct but this one is terribly wrong.

> +#define is_power_of_two(x)	( !((x) & ((x)-1)) )
> +#define low_bit_mask(x)		( ((x)-1) & ~(x) )
> +#define is_valid_mask(x)	is_power_of_two(1 + (x) + low_bit_mask(x))
> +
> +#define FIELD16(__mask)					\
> +({							\
> +	BUILD_BUG_ON(!__mask || !is_valid_mask(__mask));\
> +	(struct rt2x00_field16) {			\
> +		(__scanbit((__mask), 16) - 1), (__mask) \
> +	};						\
> +})
> +
> +#define FIELD32(__mask)					\
> +({							\
> +	BUILD_BUG_ON(!__mask || !is_valid_mask(__mask));\
> +	(struct rt2x00_field32) {			\
> +		(__scanbit((__mask), 32) - 1), (__mask) \
> +	};						\
> +})

The problem is here, I have used __scanbit to determine the first bit
that is set. __scanbit was used since this doesn't require a pointer to the value
while the other functions do require the pointer (and the macro receives the direct
value hence the reason for the __scanbit choice).
Unfortunately I did not check if __scanbit was available on all arches, and this one
seems to only excist for x86_64.. :S
I'll try to fix this asap and come with a new patch.

Ivo
