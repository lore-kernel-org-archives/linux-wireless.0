Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155C033A702;
	Thu, 18 Jun 2026 06:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781764783; cv=none; b=nPBwC06asrDZztA/znC0Qgb2CdNUCGAp8lgFydxF58ULCPbFk3VawtH2J8RoR2L0q4S2fL5dIdcOO9e41MRCpzewLtyMvPU6E3tbr3z1MhhOukZFxzpXpIYGGIhfwfxka189ZiNxmvTceCP5sfyji3y1qWZAwyN/1/a+h2mALrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781764783; c=relaxed/simple;
	bh=WVKYPs6mwbbo0IIgXseFHrnvYSBlOvJSny2gfO4hewk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTv9YB0QQ6o7hmLCFiBeM5SlHmaADwyHFuE5csAqt3WH20qpSoCbh3XXLfNh5gJEnYHi0i01hZWcnr+MXSH+pDzGrr5+cxWg8gFCKl3GSMMEf23yAUQYlqojiTzLqlzcgF5zpZx4DbEHQKoR7dSpadJNXgp15omamXbDWi7PkLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DAEmYcMo; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DAEmYcMo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781764782; x=1813300782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WVKYPs6mwbbo0IIgXseFHrnvYSBlOvJSny2gfO4hewk=;
  b=DAEmYcMoDAERW+hdnlzPQUHDZEn+31PGwWcd6KrG50NR8gwnfAhD5kpt
   WBq7XUUmcVFYyv/tp7ZgCzqbXmTo6CB1+OJLj5zl7K+vzseZHxvJmyDsu
   S0GVTVbXQruHW/MZUP/nacZX8OW82Y6ddu+UPOydJh3I7aQ+Agu2ZQc2L
   N8v9sc2ZXHtU2qxE16AYf1TQVJdvt7NASPWw2zfg3gkyE5DSHV3m9cz15
   mqHWGwFts1xkCvcGIYzAUaOxmB1JJp33NmOqYfPcrBSn1vwNY5QTXMml+
   mu4QnX6xuJzGLW32ItQ+eLqxf8TTaF1Rl1nSaijpu5xz9joHD7eL9k66D
   g==;
X-CSE-ConnectionGUID: stJe1aY7RgepXJzN9Tgfwg==
X-CSE-MsgGUID: 59GatvCnQ1mSHXj26JQvWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11820"; a="93242643"
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="93242643"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 23:39:41 -0700
X-CSE-ConnectionGUID: YKG+zQSfS1uCRgDbLkOXtg==
X-CSE-MsgGUID: sWsJuKwiQ6iXuUUEtMgDGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="271975355"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.10])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2026 23:39:39 -0700
Date: Thu, 18 Jun 2026 09:39:37 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v1 1/2] overflow: Allow to sum a few arguments at once
Message-ID: <ajOSqWpYUhFTVqP-@ashevche-desk.local>
References: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
 <20260617112250.2791461-2-andriy.shevchenko@linux.intel.com>
 <1e656f5798a9f2f36daa00aba60d2196b2456335.camel@sipsolutions.net>
 <20260617223056.754bfcb8@pumpkin>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617223056.754bfcb8@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Jun 17, 2026 at 10:30:56PM +0100, David Laight wrote:
> On Wed, 17 Jun 2026 14:56:09 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2026-06-17 at 13:12 +0200, Andy Shevchenko wrote:
> > > Convert size_add() to take variadic argument, so we can simplify users
> > > with using a macro only once.  
> > 
> > > +#define __size_add3(addend1, addend2, addend3, addend4, ...)			\
> > > +	__size_add(__size_add2(addend1,  addend2, addend3), addend4)
> > > +#define __size_add4(addend1, addend2, addend3, addend4, addend5, ...)		\
> > > +	__size_add(__size_add3(addend1,  addend2, addend3, addend4), addend5)  
> > 
> > I guess it's not going to really matter, but it would generate fewer
> > calls to have something more like
> > 
> > #define __size_add3(a1, a2, a3, a4) \
> > 	size_add(size_add(a1, a2), size_add(a3, a4))
> > #define __size_add4(a1, a2, a3, a4, a5) \
> > 	size_add(size_add(a1, a2), size_add(a3, a4, a5))
> > 
> > as a binary tree, rather than only cutting one off every time. Not sure
> > that results in hugely different code though - maybe fewer overflow
> > checks?

Good question. I'm also thinking that one-by-one may expand in too much of
preprocessor code (haven't checked myself).

> The binary tree stands a chance of executing less slowly because the leaf
> adds can be executed in parallel.
> Excluding the saturation checks (wtf is it called size_add() not
> saturating_add() ?) (a + b) + (c + d) will usually execute faster than
> ((a + b) + c) + d because the (a + b) and (c + d) can execute at the
> same time; unfortunately gcc will always generate the latter.

I'm confused. "unfortunately... the latter"? You meant "the former"?

> > Although your version make it really completely equivalent to the
> > nl80211.c code, clearly it doesn't matter if all the values are "good",
> > and I believe the overflow behaviour means it doesn't matter for the
> > overflow case either?

Indeed. Whenever the value is saturated, the rest is just matter of sequential
unlikely branches taken.

-- 
With Best Regards,
Andy Shevchenko


