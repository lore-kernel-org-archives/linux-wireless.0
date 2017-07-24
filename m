Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54247 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752513AbdGXPyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 11:54:43 -0400
Date: Mon, 24 Jul 2017 17:54:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v1 5/6] uuid: Kill uapi/uuid.h
Message-ID: <20170724155441.GC17917@lst.de> (sfid-20170724_175454_806813_3677DE5A)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-6-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170719182857.73693-6-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 29d6699d5a06..1c68709123aa 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -36,7 +36,7 @@ typedef uint16_t	__u16;
>  typedef unsigned char	__u8;
>  typedef struct {
>  	__u8 b[16];
> -} uuid_le;
> +} guid_t;
>  
>  /* Big exception to the "don't include kernel headers into userspace, which
>   * even potentially has different endianness and word sizes, since
> @@ -134,7 +134,7 @@ static inline void add_wildcard(char *str)
>  		strcat(str + len, "*");
>  }
>  
> -static inline void add_uuid(char *str, uuid_le uuid)
> +static inline void add_uuid(char *str, guid_t uuid)
>  {
>  	int len = strlen(str);

This should probably be split into a separate patch.
