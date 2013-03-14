Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f169.google.com ([209.85.160.169]:65488 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3CNAWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 20:22:20 -0400
Received: by mail-gh0-f169.google.com with SMTP id r18so301765ghr.14
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2013 17:22:20 -0700 (PDT)
Message-ID: <51411838.6070402@lwfinger.net> (sfid-20130314_012224_934111_27D6DB4E)
Date: Wed, 13 Mar 2013 19:22:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: isedev@gmail.com
CC: b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM4312 / b43 DMA transmission sequence errors
References: <1695808.c7XUjJpf0R@wks001.ise.net>
In-Reply-To: <1695808.c7XUjJpf0R@wks001.ise.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2013 05:31 PM, ISE Development wrote:
> Hi,
>
> The wireless connection keeps failing shortly after being established. Up to now, I've tracked it down to a DMA transmission sequence error in ring 3. Beyond that, I cannot say...
>
> Happy to provide further information and to test any potential fixes.

Have you applied the patch that increases the number of RX ring slots? It is 
commit ccae0e50c16a7f and was committed on Feb 17, 2013. That fixed a lot of 
problems on the BCM4312. It seems that the firmware fails to check for overflow 
of the RX ring and blindly corrupts things.

Larry


