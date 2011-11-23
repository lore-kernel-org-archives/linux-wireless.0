Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp204.alice.it ([82.57.200.100]:58572 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1KWP7n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:59:43 -0500
From: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
To: "Franky Lin" <frankyl@broadcom.com>
Subject: Re: brcmfmac + compat wireless + 2.6.35
Date: Wed, 23 Nov 2011 16:59:39 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <201111221600.31514.GNUtoo@no-log.org> <201111222046.54310.GNUtoo@no-log.org> <4ECC1F41.90003@broadcom.com>
In-Reply-To: <4ECC1F41.90003@broadcom.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201111231659.39189.GNUtoo@no-log.org> (sfid-20111123_165950_642442_77E530DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>Root cause for the mmc complain is that there is no handler for function 
>2 interrupt. 4329 generate a SDIO interrupt when there are something 
>available for the driver to retrieve from the dongle. It will flag both 
>function 1 and function 2 at the same time. They are identical. A empty 
>dummy irq handler register to function 2 irq will make the warning go 
>away. FWIW, it doesn't affect anything here since they have been taken 
>care in function 1 irq handler. 
ok,thanks for the explanation.

>I will submit a patch too add the dummy handler.
Thanks a lot.

Denis.
