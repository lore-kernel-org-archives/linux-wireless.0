Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:54960 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbeCZLZC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:25:02 -0400
Date: Mon, 26 Mar 2018 16:54:52 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 4/9] staging: wilc1000: free memory allocated in add wep
 key functions
Message-ID: <20180326165452.478099d0@ajaysk-VirtualBox> (sfid-20180326_132506_132263_6A5E35B4)
In-Reply-To: <20180326081748.srvuwoekodihtpfh@mwanda>
References: <1521817738-7557-1-git-send-email-ajay.kathat@microchip.com>
        <1521817738-7557-5-git-send-email-ajay.kathat@microchip.com>
        <20180326081748.srvuwoekodihtpfh@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Mon, 26 Mar 2018 11:17:48 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Fri, Mar 23, 2018 at 08:38:53PM +0530, Ajay Singh wrote:

> We should "return result;" here otherwise we'll hang when we
> wait_for_completion().  This is the sort of bug why I always encourage
> people to keep the error path and success path separate (unless they
> both have to unlock or free the same resources).
> 

Yes, wait_for_completion() will hang for the error path. I have included
the changes in V2 patch series.

> 
> This code works, but it would look cleaner with "return result;".
> 
> 	result = wilc_enqueue_cmd(&msg);
> 	if (result) {
> 		netdev_err(vif->ndev, "AP - WEP Key\n");
> 		kfree(msg.body.key_info.attr.wep.key);
> 		return result;
> 	}
> 
> 	wait_for_completion(&hif_drv->comp_test_key_block);
> 	return 0;
> 
> I removed a blank line between the wilc_enqueue_cmd() and the error
> handling because they're very connected.  All the success path is at
> indent level one so you can just glance at the function and see what
> it's supposed to do in the normal case.  The error handling is self
> contained at indent level two.
> 

I will send the updated patch by modifying the code as suggested.


Regards,
Ajay
