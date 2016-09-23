Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:33626 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758866AbcIWNRK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 09:17:10 -0400
From: <Aditya.Shankar@microchip.com>
To: <Ganesh.Krishna@microchip.com>, <gregkh@linuxfoundation.org>,
        <nicolas.ferre@atmel.com>
CC: <linux-wireless@vger.kernel.org>, <luisbg@osg.samsung.com>
Subject: Re: staging: wilc1000: kernel Oops while opening the device
Date: Fri, 23 Sep 2016 13:17:08 +0000
Message-ID: <1FA4CE79C3B5BA4CB1930722261ABC02CAF96970@CHN-SV-EXMX03.mchp-main.com> (sfid-20160923_151714_040738_D6A612F6)
References: <c12338f5-0a50-bb55-0b83-0fa705237cf8@atmel.com>
 <20160919134201.GA25769@kroah.com>
 <65355EED85AFFB41B861AC69A1D0893DCADB8ACF@CHN-SV-EXMX03.mchp-main.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 September 2016 06:04 PM, Ganesh Krishna - I00112 wrote:
>> -----Original Message-----
>> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org] 
>> Sent: Monday, September 19, 2016 7:12 PM
>> To: Nicolas Ferre
>> Cc: linux-wireless@vger.kernel.org; Aditya Shankar - I16078; Ganesh Krishna - I00112; luisbg@osg.samsung.com
>> Subject: Re: staging: wilc1000: kernel Oops while opening the device
>>
>> On Mon, Sep 19, 2016 at 02:06:02PM +0200, Nicolas Ferre wrote:
>>> Hi all,
>>>
>>> While using the wilc1000 driver with latest 4.8-rc7, I have 
>>> difficulties to open the device and actually use it as I have this 
>>> kernel Oops right after the loading of the firmware (wilc1003_firmware.bin).
>>>
>>> If I revert back the driver to its 
>>> b9811891a9f60ca9c314dcab3244c65930c4cf37 state, it works okay. I did 
>>> this because I tend to think that it might be related to the latest move on this driver to "completion" or "work queues".
>>> It seems to be a regression from 4.7.
>>
>> Ick, not good at all.
>>
>> Any chance you can run 'git bisect' to see if you can find the offending patch?
>>
>> I thought the maintainers were testing this driver over time :(
> 
>> thanks,
>>
>> greg k-h
> 
> Ick indeed. Maintainers are on it full time. Thank you very much for the flag. While I am only reporting activity, hope to have results soon.
> Regards,
> ganesh k 
> 
Hi All,

bisecting changes on the wilc1000 host driver, I find that this problem seems to occur after the below change. 
As of now, I only know the where and not the why. So I will continue to figure out why this happens.

commit 2518ac59eb27ed003c5a97e8f9588adafdfe4a8a
Author: Binoy Jayan <binoy.jayan@linaro.org>
Date:   Thu Jun 23 11:11:51 2016 +0530

    staging: wilc1000: Replace kthread with workqueue for host interface
    
    Deconstruct the kthread / message_queue logic, replacing it with
    create_singlethread_workqueue() / queue_work() setup, by adding a
    'struct work_struct' to 'struct host_if_msg'. The current kthread
    hostIFthread() is converted to a work queue helper with the name
    'host_if_work'.
    
Thanks!
Aditya
