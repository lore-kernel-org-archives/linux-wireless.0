Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70B431A570;
	Tue, 23 Jun 2026 20:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782245016; cv=none; b=WI3hH5iocllqSmH5hM/YiG1CH4l/xgbupL5jgO01irSdhfU4C/VK4inegV4iHuqAm6zkOl7lXXb60vyShsqBwbuJ+iXB5mFVsVLxoSe7ZiAXN3LVPkYCCVCmlQi0qIB7JDOnLhDCgLHkUaPdIJP2Jkx14daq5OpTdmOQTHM+D0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782245016; c=relaxed/simple;
	bh=raejfHvRtyuaWsDY/iLf61uT42BKgvn0NbXLzzZ5cZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfB542I2ymKcWFUoKiUpkbTGr+KyAJtTB0RFVKk9ygCq5+KylDAUcoZ49eZ05xRNEx4IQzrebYIfsndRJbv4awBYR45nkl4rgxs68RX4N27u7atdu2hEz1Dvi4vDNqRdof7kd6CrKMtSJ1Gxx08Jh92lOG+dCTnRO+WJ1rNYpxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hdfumXSE; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hdfumXSE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782245016; x=1813781016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=raejfHvRtyuaWsDY/iLf61uT42BKgvn0NbXLzzZ5cZs=;
  b=hdfumXSEi88P98fAk+RWTeAVmuqkyhbeQKqO/e8/GNfGE8bpdCT0Jetx
   96UKQqr7mxIxzAZ5pmSu9Mt227/dalqrkKk6B0zT4q6ClLZ2NiPknmpdy
   16W+yDaNn5MIuH4ctqGRcQc0Wkuh2OeKMV8I+dtFKj5duTsxE7fc4YTw8
   PJ3UXLSqck/CRsrg9Xlco9vhjo/R/4alJ1jl+gy7b1Xf73DLfbsY3bbmd
   5QTgwSxv/V9hd7uSLglHFs4s9RyqXFDlEUGKhaNPURkuQ2DZVqVaThryc
   oBuNTbo2TTIdGdevc2WpSQzmuklgAgGvlSn5dlb0B5p3KzZAH1p71rN8N
   Q==;
X-CSE-ConnectionGUID: wq7hu0X4RNigeApJm8OtrQ==
X-CSE-MsgGUID: cLBuiSkcSA2bMxlirVXKtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11826"; a="83000062"
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="83000062"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 13:03:35 -0700
X-CSE-ConnectionGUID: QF0AOM7TSKiWZXfLnuLo0g==
X-CSE-MsgGUID: U+AHMSvfQiCI8evS/Le8Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,221,1774335600"; 
   d="scan'208";a="273305905"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 13:03:32 -0700
Date: Tue, 23 Jun 2026 23:03:30 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v1 1/2] overflow: Allow to sum a few arguments at once
Message-ID: <ajrmkvkytdQZe83U@ashevche-desk.local>
References: <20260617112250.2791461-1-andriy.shevchenko@linux.intel.com>
 <20260617112250.2791461-2-andriy.shevchenko@linux.intel.com>
 <202606182046.AE5F6A241@keescook>
 <ajTlfuOFHXlA7xdu@ashevche-desk.local>
 <202606192025.CF68F2E@keescook>
 <ajY5hg0f34C-iV3R@ashevche-desk.local>
 <54974e4298efd26a52c9c0e9ada88d57e8695a09.camel@sipsolutions.net>
 <ajqTpJAMFFV3H5Im@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajqTpJAMFFV3H5Im@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jun 23, 2026 at 05:09:44PM +0300, Andy Shevchenko wrote:
> On Mon, Jun 22, 2026 at 01:16:29PM +0200, Johannes Berg wrote:
> > On Sat, 2026-06-20 at 09:56 +0300, Andy Shevchenko wrote:
> > > Johannes, are you okay to take a new version (I assume the wish is to have
> > > the balanced additions)? If so, I will prepare one.
> > 
> > Sure, I can take the patches, sounds good to me.
> 
> Will send soon, for the record the *.i file is 61 character less with the patch.

After looking closer at the potential users, I see less benefit of this change
than before. The other case in one of wireless driver can actually benefit from
separate size_add() calls and temporary variables which will be reused later in
the code. The similar approach even can be used for nl80211.c case. So for
now I abandon this until more users come. (Of course it might be that I'm missing
something and if somebody knows what, I would like to learn.)

-- 
With Best Regards,
Andy Shevchenko


