Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C224281503;
	Mon, 20 Apr 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776684016; cv=none; b=Io9/inFfWziGx7QdBFHI61z8vsc0KeMjDrxa85YcnWoWp1X7TpKYITtTAgKvurzEh7coHEhJiSMi8dDQYEmVKm0P56lwA+0uZ1IbFJPy828fy2Bcwea1TsA7FDzKpDp3JYejWWYziZGzWG/njBAvbg+j3SECGXDkA7d2OSwMoYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776684016; c=relaxed/simple;
	bh=tAGssuwp+KPHsp3ijI1IC1FdjIpKYKPjCR3P7O5migA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQB4WseIuV3qpxEBG2lSQzXXo9egTI5Xqg7R5C1cufgCPNrQRUv0JK4WWAksNEK20j52aX86ae2QTqPeKhe2YG0V8NdhVnFMXh3GfDMHBHtpprMm+ZQECrKOjkuAMqeUPABcWxP1D8o3amVH+2/UE02sZNyztI42UzUfDpsc0pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iF1utQPx; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iF1utQPx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wEphAaQytTvkJ4Y8tBG6de3VhB79fwybJlTf49/OcGg=; b=iF1utQPxKPIAEUkTvYhGTfZ1gw
	C/Fsi/Gx1q0cK971U1T7N9wBu8aesqpPFXbPZclgQSuc8qfU7P34caTdsHWdjuSWy3y1M7H7t9hcF
	YDyWiTNnEvo0eh6vDYND9Ltd7GNr0APVrnt1FMVOXnccjwmZjfBmDy+ntHwtEqauo+7Mmf/XfLpfN
	9ScTEZYp5lPVP601y+0DfVb3UxvGQdnkufqAeNkSyQ51bq6v+F+7+nl6xaX8rgjKZOBJezFuYZyos
	ZBK8VJBR1QglIncUNSoIZY/rtsFVX1iiZ0f/V6qNHGb3jS8LjLqhxIuE85igguQXHadk5E7WyfzeE
	0fLtIY5w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEmfF-00000007omh-40xL;
	Mon, 20 Apr 2026 11:19:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3C237301BDE; Mon, 20 Apr 2026 13:19:40 +0200 (CEST)
Date: Mon, 20 Apr 2026 13:19:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	David Lechner <dlechner@baylibre.com>,
	Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy@kernel.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hans de Goede <hansg@kernel.org>, Linus Walleij <linusw@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Salah Triki <salah.triki@gmail.com>,
	Achim Gratz <Achim.Gratz@stromeko.de>,
	Ben Collins <bcollins@watter.com>, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-rtc@vger.kernel.org
Subject: Re: [PATCH 1/9] bitfield: add FIELD_GET_SIGNED()
Message-ID: <20260420111940.GE3102624@noisy.programming.kicks-ass.net>
References: <20260417173621.368914-1-ynorov@nvidia.com>
 <20260417173621.368914-2-ynorov@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417173621.368914-2-ynorov@nvidia.com>

On Fri, Apr 17, 2026 at 01:36:12PM -0400, Yury Norov wrote:
> The bitfields are designed in assumption that fields contain unsigned
> integer values, thus extracting the values from the field implies
> zero-extending.
> 
> Some drivers need to sign-extend their fields, and currently do it like:
> 
> 	dc_re += sign_extend32(FIELD_GET(0xfff000, tmp), 11);
> 	dc_im += sign_extend32(FIELD_GET(0xfff, tmp), 11);
> 
> It's error-prone because it relies on user to provide the correct
> index of the most significant bit and proper 32 vs 64 function flavor.
> 
> Thus, introduce a FIELD_GET_SIGNED() macro, which is the more
> convenient and compiles (on x86_64) to just a couple instructions:
> shl and sar.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>  include/linux/bitfield.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 54aeeef1f0ec..35ef63972810 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -178,6 +178,22 @@
>  		__FIELD_GET(_mask, _reg, "FIELD_GET: ");		\
>  	})
>  
> +/**
> + * FIELD_GET_SIGNED() - extract a signed bitfield element
> + * @mask: shifted mask defining the field's length and position
> + * @reg:  value of entire bitfield
> + *
> + * Returns the sign-extended field specified by @_mask from the
> + * bitfield passed in as @_reg by masking and shifting it down.
> + */
> +#define FIELD_GET_SIGNED(mask, reg)					\
> +	({								\
> +		__BF_FIELD_CHECK(mask, reg, 0U, "FIELD_GET_SIGNED: ");	\
> +		 ((__signed_scalar_typeof(mask))((long long)(reg) <<	\
> +		 __builtin_clzll(mask) >> (__builtin_clzll(mask) +	\
> +						__builtin_ctzll(mask))));\
> +	})

IIRC clz is count-leading-zeros and ctz is count-trailing-zeros. Most of
the other FIELD things use __bf_shf() which is defined in terms of ffs -
1 (which is another way of writing ctz).

So how about you start by redefining __bf_shf() in ctz, and then add
another helper for the clz and write the thing something like:

	((long long)(reg) << __bf_clz(mask)) >> (__bf_clz(mask) + __bf_shf(mask));

Also, since the order of the shifts is rather important, I think it
makes sense to add this extra pair of (), even when not strictly needed,
just to make it easier to read.
