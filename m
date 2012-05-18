Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46069 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759247Ab2ERTNF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 15:13:05 -0400
Message-ID: <4FB69F25.3040707@hauke-m.de> (sfid-20120518_211311_161428_664A3CC6)
Date: Fri, 18 May 2012 21:12:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac: use sprom from bcma
References: <20120517191339.GA17018@elgon.mountain>
In-Reply-To: <20120517191339.GA17018@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/17/2012 09:13 PM, Dan Carpenter wrote:
> Hello Hauke, Arend,
> 
> The patch 898d3c3b2462: "brcmsmac: use sprom from bcma" from Apr 29, 
> 2012, leads to the following warning:
> drivers/net/wireless/brcm80211/brcmsmac/channel.c:645 
> brcms_c_country_valid()
> 	 error: buffer overflow 'ccode' 2 <= 2
> 
> -       if (ccode && brcms_c_country_valid(ccode))
> -               strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
> +       if (sprom->alpha2 && brcms_c_country_valid(sprom->alpha2))
>                                                    ^^^^^^^^^^^^^
> This is a two character array.  It's not NULL terminated.
> 
> +               strncpy(wlc->pub->srom_ccode, sprom->alpha2, sizeof(sprom->alpha2));
> 
> But in brcms_c_country_valid() we check for the NULL terminator.
> 
>    637  static bool brcms_c_country_valid(const char *ccode)
>    638  {
>    639          /*
>    640           * only allow ascii alpha uppercase for the first 2
>    641           * chars.
>    642           */
>    643          if (!((0x80 & ccode[0]) == 0 && ccode[0] >= 0x41 && ccode[0] <= 0x5A &&
>    644                (0x80 & ccode[1]) == 0 && ccode[1] >= 0x41 && ccode[1] <= 0x5A &&
>    645                ccode[2] == '\0'))
>                       ^^^^^^^^^^^^^^^^
> Here.
> 
>    646                  return false;
> 
> My guess is that this works because -> leddc_on_time is mostly zero.
> 
> regards,
> dan carpenter
> 
Hi Dan,

your guess is probably right, but I do not know want is the best
solution to fix this. I set this to 2 byte as there are just two bytes
memory for this in the sprom. In the nvram of some SoC I also found a 3
letter code ccode=US2 and an other wrong two letter code ccode=Q2. What
is the way we should handle this?

1. just read the first 2 bytes and ignore the rest -> change
brcms_c_country_valid() and some SoC parsing code.

2. read the first 2 bytes and reject longer codes as completely invalid
(probably just found in nvram on SoCs) -> change brcms_c_country_valid()

3. read 4 (or more) bytes and let brcmsmac decide what is a valid code
-> change sprom struct and some more code

I would vote for number 2.

@Arend by the way how should the code EU or 0 be handled? It is used on
all my recent SoCs.

Hauke
