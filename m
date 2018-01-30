Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48440 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752820AbeA3Ok6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 09:40:58 -0500
Date: Tue, 30 Jan 2018 17:40:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: kbuild test robot <lkp@intel.com>, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        kbuild-all@01.org, aditya.shankar@microchip.com
Subject: Re: [PATCH v2 13/14] staging: wilc1000: rename Handle_Connect() to
 avoid camelCase
Message-ID: <20180130144031.hd5whcs4lwah4qhs@mwanda> (sfid-20180130_154102_513508_22643498)
References: <1516616547-24654-14-git-send-email-ajay.kathat@microchip.com>
 <201801300113.VYPjzW6k%fengguang.wu@intel.com>
 <20180130192949.016ed06a@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180130192949.016ed06a@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 30, 2018 at 07:29:49PM +0530, Ajay Singh wrote:
> On Tue, 30 Jan 2018 02:13:53 +0800
> kbuild test robot <lkp@intel.com> wrote:
> 

> 
> 
> The patch only change variable names to avoid the camelCase, didn't modify any extra code to dereference memory.

You are responding to a robot and I think we all understood that this
warning was there before you renamed the variables.

> I think, with the use of shorter variable name now memcpy() is taking 1 line instead of 3 lines. So, now line 937 has different code line(as code is swifted up by few lines).So because of that new potential NULL dereference error is popped up for same existing code.  
> The code to validate dynamically allocated memory before access, will be include in separate patch to keep it segregated from variable names changes. 
> I will rework on this patch and resend again.

There is no need to re-work the patch.

You are right that the NULL check should be added as a separate check.

regards,
dan carpenter
