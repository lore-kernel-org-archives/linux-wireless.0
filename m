Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:19216 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbeHPJ1o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 05:27:44 -0400
Date: Thu, 16 Aug 2018 01:52:43 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: feedback on mainlining wilc1000 staging driver
Message-ID: <20180816015243.545cd009@ajaysk-VirtualBox> (sfid-20180816_083159_201852_EC0F4898)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

We all are working on submitting and reviewing patches for wilc1000 in
staging driver for quite some time. 

We would like to have feedback on the next steps to bring wilc1000
driver closer to move into the wireless subsystem tree. 

In summary, the following major things from TODO have been addressed in
staging:
-remove the defined feature as kernel versions
-remove OS wrapper functions
-remove custom debug and tracing functions
-rework comments and function headers(also coding style)
-remove build warnings
-replace all semaphores with mutexes or completions
-make spi and sdio components coexist in one build
-turn compile-time platform configuration (BEAGLE_BOARD, PANDA_BOARD,
PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...) into run-time
options that are read from DT
-replace SIOCDEVPRIVATE commands with generic API functions
-use wext-core handling instead of private SIOCSIWPRIV implementation
-Move handling for each individual members of 'union message_body' out
into a separate 'struct work_struct' and completely remove the
multiplexer that is currently part of host_if_work(), allowing movement
of the implementation of each message handler into the callsite of the
function that currently queues the 'host_if_msg'.
-convert all uses of the old GPIO API from <linux/gpio.h> to the GPIO
descriptor API in <linux/gpio/consumer.h> and look up GPIO lines from
device tree, ACPI or board files, board files should use
<linux/gpio/machine.h>

I have few patches to submit based on last week comments. I
will send these patches as soon as the merge window is closed.

1. Delete wilc_debugfs.c file, as not used.
2. Remove use of remaining global variables.
3. Remove udelay realted checkpatch warning.
4. Use void return for function whose return value is not used.


Currently, there are 2 known items pending in our TODO. 
-support soft-ap and p2p mode
-support resume/suspend function
 
For the above 2 remaining TODO items, we need to add extra code but as
suggested in [1], we have not taken up this activity yet.
 
We would like to know your opinion whether we should start working on
these features in staging-next tree or take it up after having moved
the code to wireless sub-system.

Do you think it’s better to initiate review in parallel with
wireless subsystem maintainer to identify any pending TODO items. 

Please guide us on how to proceed further.

[1] . https://patchwork.kernel.org/patch/9809145
 

Regards,
Ajay
