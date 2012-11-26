Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xnode.org ([94.76.208.25]:47911 "EHLO xnode.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab2KZXGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 18:06:33 -0500
Received: from host-2-103-186-214.as13285.net ([2.103.186.214] helo=[10.0.0.51])
	by xnode.org with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.80)
	(envelope-from <ben@xnode.org>)
	id 1Td7Mk-0006TZ-0r
	for linux-wireless@vger.kernel.org; Mon, 26 Nov 2012 22:41:26 +0000
Message-ID: <50B3F009.4010903@xnode.org> (sfid-20121127_000636_993613_18515A36)
Date: Mon, 26 Nov 2012 22:41:13 +0000
From: Benjamin Hodgetts <ben@xnode.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: IWLWIFI Issues (TX Retries, Speed, Disconnections)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wireless card seems to cap out around 6MB/s even when connected at 
(apparently) 216Mb so throughput isn't as high as it should be (even 
accounting for the massive wireless overheads) but that isn't the main 
issue...

Currently I'm seeing a MASSIVE amount of Tx excessive retries. After 
copying a 4GB file the figure was at 825394 (without any bluetooth 
activity).

Secondly (the main issue): If I use something bluetooth at the same time 
as the Wireless card, it seems to fall over after a few minutes (it's 
fine up until that point).

The device in question is a Intel(R) Centrino(R) Wireless-N 2230 BGN 
Mini-PCIe card (it's both a Wireless G/N card and a Bluetooth 4 card).

For example, I just tried to use it again and ended up giving up. I was 
trying to use Bluetooth headphones and the wireless at the same time. It 
was ok for a minute or two and then just kept silently dropping out (not 
disconnecting from the AP though). The time between it happening would 
shorten each time until it seemed to happen every 20 seconds or so.

Kernel output:
[301961.010199] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues
[302045.433040] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302052.978602] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302067.127391] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302073.046653] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302076.299569] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302079.683274] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302143.254305] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302170.259993] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302203.089092] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302345.510246] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302361.812532] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302375.833424] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302383.333181] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302396.240417] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302399.632266] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302446.190562] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302466.248471] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302479.420951] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[302488.926232] iwlwifi 0000:04:00.0: BT traffic (2), no aggregation allowed
[303036.959778] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues
[303157.754721] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues
[303279.622419] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues


This is Arch Linux using the 3.6.6 kernel. This same scenario works fine 
on my laptop.
