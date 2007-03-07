Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:4017 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXCGPm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 10:42:59 -0500
Message-ID: <45EEDD81.4080301@rtr.ca>
Date: Wed, 07 Mar 2007 10:42:57 -0500
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] prism54usb: Fix hail of warnings on 64bit platforms
References: <20070307164020.16944e32@lxorguk.ukuu.org.uk>
In-Reply-To: <20070307164020.16944e32@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Cox wrote:
> If you want to cast a pointer to a small value then start by turning it
> into an unsigned long so the compiler knows what is going on.
> 
> Personally I find the whole approach used by this driver for types of
> registers (which are really USB register numbers) utterly perverse...
...
>
>	err = p54u_write(priv, buf, type,\
> -				 cpu_to_le32((u32)addr), data);\
> +				 cpu_to_le32((u32)(unsigned long)addr), data);\
...

What exactly are those "addr" parameters -- memory addresses ?

-ml
