Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1963 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab0LTRRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 12:17:00 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Dan Carpenter" <error27@gmail.com>
cc: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Date: Mon, 20 Dec 2010 09:13:23 -0800
Subject: RE: smatch stuff: potential read past the end of the buffer
Message-ID: <400C43189542CE41BC0A5B252FC90136952F0594D8@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20101220083041.GQ1936@bicker>
 <400C43189542CE41BC0A5B252FC90136952F0594D7@SJEXCHCCR02.corp.ad.broadcom.com>,<20101220124217.GU1936@bicker>
In-Reply-To: <20101220124217.GU1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Agreed. But maybe there is no usage scenario in which the boundary is actually crossed. Have to wait for ath9k developers to answer that.

Gr. AvS
________________________________________
From: Dan Carpenter [error27@gmail.com]
Sent: Monday, December 20, 2010 1:42 PM
To: Arend Van Spriel
Cc: Vasanthakumar Thiagarajan; linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org
Subject: Re: smatch stuff: potential read past the end of the buffer

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




