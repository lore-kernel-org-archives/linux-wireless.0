Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5178B45D5E7;
	Wed, 16 Sep 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789589757; cv=none; b=RBSfvf3qgbAtSFmEP23ISAQprZ9+zV3Uf9jGATur1dsYKQD3wySrzIDeviqgVc6kO58lCZKvCp9edlLIkdskv3QXeWfwiOTd0YKMUnRoF+mOnXx6la8/e67e3rKAfsm0R6MGxgLhU6b5rLwbMx+mnSJcGgWU9ZzIHsu3QWySQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789589757; c=relaxed/simple;
	bh=OT0ZGTsw1y/EZywe4ZIiJhrdwFfv/X+7RgADw5icO94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Um9mxH9eox3kJAo3jwiA1NIwYURJYYv+1E5y959kWXfVbeyCCbBZY0cbuPDBKZeOyVfY6GVFNPCG1OGfMpSrfL9OxGDB+nKeIxv7IEZdQCV6p6No/uO8rVXXzLejZGd0l/YvGMBZYnWqHVfIrXqSC7kO2KdO1Z21NcAI5Sh3IvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1x6vVn-0001n6-00; Wed, 16 Sep 2026 21:41:43 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id D2B74C021A; Wed, 16 Sep 2026 20:50:01 +0200 (CEST)
Date: Wed, 16 Sep 2026 20:50:01 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Kent Gibson <warthog618@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-gpio@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH 2/2 v7] gpiolib: remove linux/gpio.h
Message-ID: <aqrk2Tq4ioZ-bEFf@alpha.franken.de>
References: <20260907090956.2825703-1-arnd@kernel.org>
 <20260907090956.2825703-3-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907090956.2825703-3-arnd@kernel.org>

On Mon, Sep 07, 2026 at 11:09:56AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> After all other drivers have converted to linux/gpio/consumer.h
> or linux/gpio/legacy.h, remove the final leftover bits here.
> 
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  MAINTAINERS                                  |  1 -
>  arch/mips/txx9/rbtx4927/setup.c              |  2 +-

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

>  arch/sh/boards/mach-rsk/devices-rsk7203.c    |  2 +-
>  drivers/gpio/TODO                            |  4 +---
>  drivers/gpio/gpiolib-cdev.c                  |  2 +-
>  drivers/gpio/gpiolib-legacy.c                |  3 +--
>  drivers/gpio/gpiolib.c                       |  2 +-
>  drivers/net/wireless/morsemicro/mm81x/hw.c   |  1 -
>  drivers/net/wireless/morsemicro/mm81x/yaps.c |  1 -
>  include/linux/gpio.h                         | 22 --------------------
>  10 files changed, 6 insertions(+), 34 deletions(-)
>  delete mode 100644 include/linux/gpio.h

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
