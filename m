Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54692 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab1AVWww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 17:52:52 -0500
Received: by fxm20 with SMTP id 20so2929658fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 14:52:51 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard =?iso-8859-15?q?Sch=FCtz?= <r.schtz@t-online.de>
Subject: Re: ath9k prevents CPU from entering C4 state (kernel 2.6.37 regression)
Date: Sat, 22 Jan 2011 23:52:42 +0100
Cc: linux-wireless@vger.kernel.org
References: <4D3B4057.5000206@t-online.de>
In-Reply-To: <4D3B4057.5000206@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101222352.42913.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 January 2011 21:38:47 Richard Schütz wrote:
> I noticed that from kernel 2.6.37 on (i've tested 2.6.38-rc2, too) ath9k 
> prevents my CPU (Intel Atom N450) from entering the C4 power state. It 
> only goes down to C2 (there's no C3) instead. In 2.6.36(.3) everything 
> is still fine. The CPU will only go down to C4 with 2.6.37 when the 
> wireless interface is brought down.

"ath9k: Fix a DMA latency issue for Intel Pinetrail platforms."
http://www.spinics.net/lists/linux-wireless/msg58264.html

the pm_qos value will be configurable with 2.6.38: 

"ath9k: Make PM-QOS value as user configurable"
http://www.spinics.net/lists/linux-wireless/msg61259.html

"This will help our customers to configure the pm-qos value according
to the effect in throughput due to the DMA latency problem which was
observed in Intel Pinetrail platforms."

