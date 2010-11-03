Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:47267 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0KCVnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 17:43:51 -0400
Subject: Re: [PATCH] ssb: workarounds: be verbose about hacking SPROM
 revision, don't duplicate code
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1288818386-25073-1-git-send-email-zajec5@gmail.com> (sfid-20101103_220727_407923_69716152)
References: <1288818386-25073-1-git-send-email-zajec5@gmail.com>
	 (sfid-20101103_220727_407923_69716152)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 22:43:45 +0100
Message-ID: <1288820625.7368.117.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-03 at 22:06 +0100, Rafał Miłecki wrote: 
> +	default:
> +		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
> +			   "  revision %d detected. Will extract"
> +			   " v1\n", out->revision);
> +		out->revision = 1;
> +		sprom_extract_r123(out, in);

I think we should change this to throw a hard error if the sprom is
unknown. Extracting r123 is unlikely to do any good these days.
This workaround was only useful back in the days where 95% of the
cards out there were r123. But today that's not the case.

> 	}
>  
>  	if (out->boardflags_lo == 0xFFFF)


-- 
Greetings Michael.

