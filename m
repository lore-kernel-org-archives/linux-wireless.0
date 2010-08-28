Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53676 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0H1Vbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 17:31:40 -0400
Received: by pwi7 with SMTP id 7so1659233pwi.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Aug 2010 14:31:39 -0700 (PDT)
Message-ID: <4C798080.8010002@lwfinger.net>
Date: Sat, 28 Aug 2010 16:32:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: linux-wireless@vger.kernel.org,
	Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2010 12:54 AM, Thadeu Lima de Souza Cascardo wrote:
> The code for rtl8187 does not do per packet TX AGC. Resetting the per
> packet TX AGC for rtl8187b appears to increase its overall TX power.
> This allows the device to associate and a connection be established
> using APs a little further away.
> 
> Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>
> Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Cc: Hin-Tak Leung <hintak.leung@gmail.com>
> ---

I'm a little confused here. The subject says not to set the per packet TX AGC,
while the submission text says that setting it helps. I don't have access to any
documents that describe this register, but I expect that clearing
RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT would disable that feature. As a result
the code change seems to match the subject.

I have not yet tested this code, but I do note that all the Realtek drivers for
the RTL8187B set this bit.

Until testing, I withhold judgment on the actual code change, but NACK for the
inconsistency.

Larry

