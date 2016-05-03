Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33770 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbcECMxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 08:53:37 -0400
Received: by mail-yw0-f175.google.com with SMTP id t10so19047837ywa.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2016 05:53:37 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 May 2016 18:23:16 +0530
Message-ID: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com> (sfid-20160503_145341_421923_5A199EC6)
Subject: dynamic ps + offchannel mgmt_tx + HW RoC
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When the HW is in PS and Dynamic PS is enabled we are dropping
all the offchannel frames. Sequence is as below

if hw is in PS: stop_queues reason=PS, queue dynamic_ps_disable_work
send Offchannel mgmt_tx
drop the packet because offchanel + stop_reasons[q] !=0

How should we handle this? SW RoC is handling this
by checking for offchannel and bringing the HW out of PS before
handing the packet to TX path, so it works fine.

-- 
Thanks,
Regards,
Chaitanya T K.
