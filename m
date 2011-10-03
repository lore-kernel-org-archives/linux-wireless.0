Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64938 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1JCPx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 11:53:27 -0400
From: "Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce buffer
Date: Mon, 3 Oct 2011 15:52:36 +0000
Message-ID: <EDA962D9696870498097087E0373E7710B5AA5@nasanexd01e.na.qualcomm.com> (sfid-20111003_175331_415850_549C68CF)
References: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>,<1317390526-3442-4-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317390526-3442-4-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Thiagarajan, Vasanthakumar
Sent: Friday, September 30, 2011 7:18 PM
To: Valo, Kalle
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce buffer

There is only one bounce buffer (ar_sdio->dma_buffer) which is used
for both read and write without any protection. Fix this race by
allocating bounce buffer every time when it is needed.

As I have never seen any race in bounce buffer practically during my testing,
this patch can be dropped instead of making the code complex for no reason.

Vasanth 
