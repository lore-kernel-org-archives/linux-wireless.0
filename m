Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3HAHf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 03:35:58 -0400
Message-ID: <1375342554.8608.4.camel@jlt4.sipsolutions.net> (sfid-20130801_093600_965516_9E203B0F)
Subject: Re: [PATCH v2] mac80211: report some VHT radiotap infos for tx
 status
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Thu, 01 Aug 2013 09:35:54 +0200
In-Reply-To: <1374918424-1305-1-git-send-email-karl.beldan@gmail.com> (sfid-20130727_114728_154202_BD456F83)
References: <1374918424-1305-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130727_114728_154202_BD456F83)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-07-27 at 11:47 +0200, Karl Beldan wrote:

> +		/* required alignment from rthdr */
> +		pos = (u8 *)rthdr + ALIGN(pos - (u8 *)rthdr, 2);

This is bad, it potentially leaks a byte of kernel data, please
explicitly clear the padding, like

if ((pos - (u8 *)rthdr) & 1)
  *pos++ = 0;

or so.

johannes

