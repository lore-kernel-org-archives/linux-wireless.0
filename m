Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56153 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1LIR56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 12:57:58 -0500
Received: by ghbz2 with SMTP id z2so2725389ghb.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 09:57:58 -0800 (PST)
Message-ID: <4EE24C22.4000204@lwfinger.net> (sfid-20111209_185802_426205_984AE3DE)
Date: Fri, 09 Dec 2011 11:57:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Performance of BCM43224 (14e4:4353)
References: <4EE15A4E.1090500@lwfinger.net> <4EE1E2AC.8030002@broadcom.com> <4EE23AF5.8000400@lwfinger.net> <4EE24615.9020003@broadcom.com>
In-Reply-To: <4EE24615.9020003@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 11:32 AM, Arend van Spriel wrote:

> With the submitted patches brcmsmac claims any revision of 802.11 cores.
> Not sure what b43 claims. I have a patch internally to claim only
> revisions 23 and 24, which are used in bcm43224, bcm43225, and bcm4313.

The problem is that ai_doattach() is returning NULL. I added pr_err() statements 
to each of the places that this could happen and found that the error in in this 
fragment:

         /* scan for cores */
         if (socitype == SOCI_AI) {
                 SI_MSG("Found chip type AI (0x%08x)\n", w);
                 /* pass chipc address instead of original core base */
                 ai_scan(&sii->pub, pbus);
         } else {
                 /* Found chip of unknown type */
                 pr_err("Found chip of type %d\n", socitype);
                 return NULL;
         }

This one logs "brcmsmac: Found chip of type 4". As SOC_AI is the only SOCI_XX 
that is defined, I am not sure that I will be able to get further.

Larry


