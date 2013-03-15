Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45045 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3COAJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 20:09:23 -0400
Received: by mail-ee0-f51.google.com with SMTP id d17so1310244eek.38
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 17:09:22 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Reply-To: isedev@gmail.com
Cc: Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Date: Fri, 15 Mar 2013 01:09:19 +0100
Message-ID: <2065763.l9B10YbWFg@wks001.ise.net> (sfid-20130315_010927_160551_9A077A53)
In-Reply-To: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 14 Mar 2013 13:46:19 Larry Finger wrote:
> +                       if (unlikely(!skip))
> +                               txstat = status;
> +                       else
> +                               txstat = &fake;

The logic should probably be reversed. It's more unlikely to skip than not to 
do so (hopefully!)... 

-- 
-- isedev
