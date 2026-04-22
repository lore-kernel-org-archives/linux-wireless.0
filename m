Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B320F3B27DB;
	Wed, 22 Apr 2026 10:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.14.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776855373; cv=none; b=jhGu9jLzbRce/fObtOlgiGbnuB36uYkTsPKBfQ+Jhtp6kmU5hIC0aibXsSwa5M5ZZkTTcLuhW3oVN4imVV0j29qR37GoeGQkwK/WEbJVIiMJivtqKi9kvcjnUGWr6rVKQTyVn37xTGQ8tkQdkVuUXCJTqIB7EZeE0P7c+hJbWeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776855373; c=relaxed/simple;
	bh=70XgvPBVx0u4wkOHVoFPRVXOawrkL92AcYrhC61+KsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxRyqVaVKx3tbfS30DnpzQY3IndS2O0oNvtY3Y3nr3S0noY3pIOiSwFjqgFqrIogn1tVPTN5z4IJpMp7FYo7gZVKlkx4LPqeg2Q/2EZ9J268h9cEEC09tcIsJPVJRTNpV+MIkqCQoHJcHEfdcM9ag23cd9bkx7DbYfdQXWiDnNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de; spf=pass smtp.mailfrom=c--e.de; arc=none smtp.client-ip=217.10.14.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=c--e.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=c--e.de
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id 2E38D14012C; Wed, 22 Apr 2026 12:56:01 +0200 (CEST)
Date: Wed, 22 Apr 2026 12:56:01 +0200
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	linux-mmc@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-mediatek@lists.infradead.org,
	Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Subject: Re: [PATCH v1 1/6] sdio: Add syntactic sugar to store a pointer in
 sdio_driver_id
Message-ID: <aeipQfCYKjl006uM@cae.in-ulm.de>
References: <cover.1776429984.git.u.kleine-koenig@baylibre.com>
 <c830049dcfcd99f005e2ff6742aace9341c61f13.1776429984.git.u.kleine-koenig@baylibre.com>
 <aeaMkfk_1t98e7SU@monoceros>
 <CABBYNZJzbEmYzTk2m+Y8SoHVouTMA6Gje_55iJsQ6cYtDLftbQ@mail.gmail.com>
 <aecu1ixyHP2hQvgE@monoceros>
 <aehwG2Egt93-sPVB@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aehwG2Egt93-sPVB@ashevche-desk.local>


Hi,

On Wed, Apr 22, 2026 at 09:52:11AM +0300, Andy Shevchenko wrote:
> > To be honest, with the involved void* this isn't really type-safe
> > either, but at least the data keeps being a pointer which is really
> > helpful on CHERI. FTR: The alternative would be to use uintptr_t instead
> > of unsigned long, which also has proponents in the CHERI community and
> > which is used in the current vendor patch stack.
> 
> FWIW, Linus categorically told that it has to be no uintptr_t in the
> Linux kernel.

This is probably not the correct context to discuss this but
I will point out that if/when CHERI support is added to the
kernel we will need a way to distinguish between
* A (fat) pointer converted to an integer type (in order to do
  integer arithmetic on the address) that might be converted back
  to a pointer in the future and
* A plain address "extracted" from a fat pointer.
Using `uintptr_t` for the former and `unsigned long` for the
latter seems like a reasonable choice but there are certainly
other options.

Sorting out the difference between the two is a very large
part of the diff required to port Linux (or in fact any piece
of low-level software) to a CHERI system.

Best regards,
Christian


