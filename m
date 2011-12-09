Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43259 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1LISRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 13:17:06 -0500
Received: by yenm11 with SMTP id m11so2296061yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 10:17:05 -0800 (PST)
Message-ID: <4EE2509D.6020501@lwfinger.net> (sfid-20111209_191711_436719_3937EE1C)
Date: Fri, 09 Dec 2011 12:17:01 -0600
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

Arend,

I got a little further. The error message was modified as below:

         /* scan for cores */
         if (socitype == SOCI_AI) {
                 SI_MSG("Found chip type AI (0x%08x)\n", w);
                 /* pass chipc address instead of original core base */
                 ai_scan(&sii->pub, pbus);
         } else {
                 /* Found chip of unknown type */
                 pr_err("Found chip of type %d, chipid is 0x%x\n", socitype, w);
                 return NULL;
         }

This one logs "brcmsmac: Found chip of type 4, chipid is 0x4bf80001". That is a 
very strange chip ID.

Larry


