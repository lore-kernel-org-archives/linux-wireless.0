Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54570 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0LTMm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 07:42:29 -0500
Received: by wyb28 with SMTP id 28so2797926wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 04:42:28 -0800 (PST)
Date: Mon, 20 Dec 2010 15:42:17 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arend Van Spriel <arend@broadcom.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: smatch stuff: potential read past the end of the buffer
Message-ID: <20101220124217.GU1936@bicker>
References: <20101220083041.GQ1936@bicker>
 <400C43189542CE41BC0A5B252FC90136952F0594D7@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F0594D7@SJEXCHCCR02.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 02:16:56AM -0800, Arend Van Spriel wrote:
> Hi Dan,
> 
> Why not use min() function?
>     index = min(COMP_HDR_LEN + osize, 2046);
>     mchecksum = word[index] |
>                     (word[index + 1] << 8);
> 
> Or would smatch miss this in its analysis?

That would silence the warning, but is it the right fix?  I thought
maybe we should make word a larger buffer?

regards,
dan carpenter


