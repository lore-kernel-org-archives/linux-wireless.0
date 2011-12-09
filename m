Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3996 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab1LITsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 14:48:54 -0500
Message-ID: <4EE26227.8040900@broadcom.com> (sfid-20111209_204858_148833_D6127C8C)
Date: Fri, 9 Dec 2011 20:31:51 +0100
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
 <4EE24615.9020003@broadcom.com> <4EE24C22.4000204@lwfinger.net>
In-Reply-To: <4EE24C22.4000204@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 06:57 PM, Larry Finger wrote:
> On 12/09/2011 11:32 AM, Arend van Spriel wrote:
> 
>> With the submitted patches brcmsmac claims any revision of 802.11 cores.
>> Not sure what b43 claims. I have a patch internally to claim only
>> revisions 23 and 24, which are used in bcm43224, bcm43225, and bcm4313.
> 
> The problem is that ai_doattach() is returning NULL. I added pr_err() statements 
> to each of the places that this could happen and found that the error in in this 
> fragment:
> 
>          /* scan for cores */
>          if (socitype == SOCI_AI) {
>                  SI_MSG("Found chip type AI (0x%08x)\n", w);
>                  /* pass chipc address instead of original core base */
>                  ai_scan(&sii->pub, pbus);
>          } else {
>                  /* Found chip of unknown type */
>                  pr_err("Found chip of type %d\n", socitype);
>                  return NULL;
>          }
> 
> This one logs "brcmsmac: Found chip of type 4". As SOC_AI is the only SOCI_XX 
> that is defined, I am not sure that I will be able to get further.
> 
> Larry
> 

That is an unexpected code path especially as brcmsmac is probed from
bcma so SoC interface type should be AI (aka. AMBA AXI). Checked with
the proprietary driver and there is no type 4.

Can you provide the bcma_device_id information that bcma has collected
and the bcma_chipinfo for your device?

Gr. AvS

