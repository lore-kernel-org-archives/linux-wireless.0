Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38955 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbaDXIuj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:50:39 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex: add firmware dump feature for PCIe
References: <20140423143029.GA28228@mwanda>
	<477F20668A386D41ADCC57781B1F70430F70A2A9EA@SC-VEXCH1.marvell.com>
Date: Thu, 24 Apr 2014 11:50:33 +0300
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70A2A9EA@SC-VEXCH1.marvell.com>
	(Bing Zhao's message of "Wed, 23 Apr 2014 14:37:09 -0700")
Message-ID: <87eh0n5cx2.fsf@purkki.adurom.net> (sfid-20140424_105047_994797_45D05F87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Zhao <bzhao@marvell.com> writes:

>> The main question is why are we writing to /var and /tmp anyway instead
>> of putting this in debugfs or sysfs?

IMHO no sane wifi driver should _ever_ write anything to a file system.
That's just evil.

> AFAIK, the debugfs or sysfs cannot store/hold the files we retrieve
> from firmware at the scene. We write fw_dump files to rootfs so that
> the files are stored even if the system reboots due to hung_task
> timeout.

Can't you have a user space tool reading the sysfs file and store the
file permanently? That way kernel is not involved in file system access
at all.

-- 
Kalle Valo
