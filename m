Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:51058 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161Ab2ECH0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:26:35 -0400
Received: by lbjn8 with SMTP id n8so1100160lbj.28
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 00:26:32 -0700 (PDT)
Message-ID: <1336029991.12189.19.camel@cumari.coelho.fi> (sfid-20120503_092639_633510_EBD7A1C4)
Subject: Re: linux-3.4-rc2 bug report
From: Luciano Coelho <coelho@ti.com>
To: David Binderman <dcb314@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 10:26:31 +0300
In-Reply-To: <BLU154-W620B58EC903387AA3C07D69C390@phx.gbl>
References: <BLU154-W620B58EC903387AA3C07D69C390@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Sun, 2012-04-15 at 12:27 +0000, David Binderman wrote:
> Hello there,
> 
> I recently tried out the static analysis tool cppcheck-1.54
> on the linux-3.4-rc2 source code.
> 
> It said
> 
> 1.
> 
> [drivers/net/wireless/wl12xx/cmd.c:1252]: (warning) Using size of
> pointer tmpl instead of size of its data.
> 
> The source code is
> 
>     memset(tmpl, 0, sizeof(tmpl));
> 
> It might be the case that
> 
>     memset(tmpl, 0, sizeof(*tmpl));
> 
> is better code.
> 
> 2.
> 
> [drivers/net/wireless/wl12xx/cmd.c:1301]: (warning) Using size of
> pointer hdr instead of size of its data.
> 
> Duplicate.

Thank you very much for the report.  This was indeed wrong.  I have
fixed it and queued it for integration.

-- 
Cheers,
Luca.

