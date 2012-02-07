Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59586 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2BGXL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 18:11:58 -0500
Received: by iacb35 with SMTP id b35so10757372iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 15:11:58 -0800 (PST)
Message-ID: <4F31AFBB.1000907@lwfinger.net> (sfid-20120208_001201_780360_8E69DCA7)
Date: Tue, 07 Feb 2012 17:11:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Simon Graham <simon.graham@virtualcomputer.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [PATCH] rtlwifi: Handle previous allocation failures when freeing
 device memory
References: <BC8BC73D12649F439B502B4CB6FD58B1053E2C92@BE23.exg4.exghost.com> <4F319DCA.7080507@lwfinger.net> <BC8BC73D12649F439B502B4CB6FD58B1053E2D11@BE23.exg4.exghost.com>
In-Reply-To: <BC8BC73D12649F439B502B4CB6FD58B1053E2D11@BE23.exg4.exghost.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 04:37 PM, Simon Graham wrote:
>
> Which looks like rtl_pci_probe is calling rtl_pci_free_rx_ring which is
> freeing a NULL pointer...
>
> We have not seen this specific crash since adding the change in my
> proposed patch.

After taking another look at the code, I can see paths that would call the free 
routines incorrectly. Your fix is probably easier that doing it "the right way".

BTW, your mailer mangled the patch. If you don't know how to fix that, attach it 
to mail and send it to me privately. I'll send it to John.

Larry

