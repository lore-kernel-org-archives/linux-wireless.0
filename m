Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36320 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753493AbeGEK5G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 06:57:06 -0400
Date: Thu, 5 Jul 2018 14:49:48 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH] staging: wilc1000: fix static checker warning to unlock
 mutex in wilc_deinit()
Message-ID: <20180705144948.3d4b4e62@ajaysk-VirtualBox> (sfid-20180705_125709_906233_1ABA3429)
In-Reply-To: <20180705084126.jbqiduxkq7257asu@mwanda>
References: <1530762533-30510-1-git-send-email-ajay.kathat@microchip.com>
        <20180705084126.jbqiduxkq7257asu@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Thu, 5 Jul 2018 11:41:26 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Thu, Jul 05, 2018 at 09:18:53AM +0530, Ajay Singh wrote:
> > Fix for static checker warning inconsistent returns of
> > 'hif_deinit_lock'(more details [1]).
> > 
> > "drivers/staging/wilc1000/host_interface.c:3390 wilc_deinit()
> >               warn: inconsistent returns 'hif_deinit_lock'."
> > 
> > Introduced in "ff52a57a7a42: staging: wilc1000: move the allocation
> > of cmd out of wilc_enqueue_cmd()".  
> 
> Can you use the Fixes tag so it's machine parseable?
> 
> Fixes: ff52a57a7a42 ("staging: wilc1000: move the allocation of cmd
> out of wilc_enqueue_cmd()")

Thanks for your suggestion.
Will include the 'Fixes' tag and submit patch v2 version.

> 
> With the fixes tag, say someone pulls ff52a57a7a42 into their code,
> they will know to pull this patch as well.  Also scientists will be
> able to measure the time between bug and fix and write a scholarly
> paper about it.
> 
> regards,
> dan carpenter
