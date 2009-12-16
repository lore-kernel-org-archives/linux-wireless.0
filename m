Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:45517 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763208AbZLPWxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 17:53:52 -0500
Date: Wed, 16 Dec 2009 23:55:24 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: libertas driver carrier of signaling
Message-ID: <20091216225524.GD3788@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

I was looking at the libertas driver and found that piece of code, at scan.c:

/* We want to scan all channels */
	chan_count = lbs_scan_create_channel_list(priv, chan_list);

	netif_stop_queue(priv->dev);
	netif_carrier_off(priv->dev);

So, why do we need to turn carrier off when scanning? I could barely see why
we'd want to stop the netdev tx queue, but is turning carrier off really
needed ?

Thanks in advance for your answers.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
