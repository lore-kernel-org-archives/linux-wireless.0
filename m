Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3109 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1LIUVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 15:21:34 -0500
Message-ID: <4EE269CF.2000608@broadcom.com> (sfid-20111209_212140_246588_09E9DEFB)
Date: Fri, 9 Dec 2011 21:04:31 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Francesco Gringoli" <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net>
 <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net>
 <4EE24615.9020003@broadcom.com> <4EE2509D.6020501@lwfinger.net>
In-Reply-To: <4EE2509D.6020501@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 07:17 PM, Larry Finger wrote:
> Arend,
> 
> I got a little further. The error message was modified as below:
> 
>          /* scan for cores */
>          if (socitype == SOCI_AI) {
>                  SI_MSG("Found chip type AI (0x%08x)\n", w);
>                  /* pass chipc address instead of original core base */
>                  ai_scan(&sii->pub, pbus);
>          } else {
>                  /* Found chip of unknown type */
>                  pr_err("Found chip of type %d, chipid is 0x%x\n", socitype, w);
>                  return NULL;
>          }
> 
> This one logs "brcmsmac: Found chip of type 4, chipid is 0x4bf80001". That is a 
> very strange chip ID.
> 
> Larry
> 

Indeed. What is more strange is that this looks like value from
enumeration rom. 0x4bf is BCMA_MANUF_BCM, 0x800 is BCMA_CORE_CHIPCOMMON.
It seems the BAR window is wrong. Can you read PCI_BAR window in the
ai_doattach() before reading the chip id.

Gr. AvS

