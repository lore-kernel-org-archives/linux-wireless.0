Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:19955 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZEQXCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 19:02:39 -0400
Received: by ey-out-2122.google.com with SMTP id 9so920593eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 16:02:39 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 0/5] p54spi: fixes to achieve link stability
Date: Mon, 18 May 2009 03:02:30 +0400
Message-Id: <1242601355-3178-1-git-send-email-jcmvbkbc@gmail.com>
In-Reply-To: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
References: <0001-p54spi-fix-incorrect-access-sequence-to-DMA_WRITE_C.patch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fixes STLC DMA write register access bug and cleans
up code that used to mask it.
Also it introduces fix for yet another firmware/DMA bug.

It has been tested in heterogeneous mesh network with Nokia N810
on one side and PC with b43 on the other. There's been hours
of ping -f with different packet size and hours of iperf, where
it showed a peak ~6Mbit throughput.
