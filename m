Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54749 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0H3OOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 10:14:53 -0400
Date: Mon, 30 Aug 2010 10:12:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org,
	Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20100830141218.GB30864@tuxdriver.com>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
 <4C798080.8010002@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C798080.8010002@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 28, 2010 at 04:32:48PM -0500, Larry Finger wrote:
> On 08/28/2010 12:54 AM, Thadeu Lima de Souza Cascardo wrote:
> > The code for rtl8187 does not do per packet TX AGC. Resetting the per
> > packet TX AGC for rtl8187b appears to increase its overall TX power.
> > This allows the device to associate and a connection be established
> > using APs a little further away.
> > 
> > Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>
> > Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Cc: Hin-Tak Leung <hintak.leung@gmail.com>
> > ---
> 
> I'm a little confused here. The subject says not to set the per packet TX AGC,
> while the submission text says that setting it helps. I don't have access to any
> documents that describe this register, but I expect that clearing
> RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT would disable that feature. As a result
> the code change seems to match the subject.
> 
> I have not yet tested this code, but I do note that all the Realtek drivers for
> the RTL8187B set this bit.
> 
> Until testing, I withhold judgment on the actual code change, but NACK for the
> inconsistency.

Perhaps the word "clearing" rather than "resetting" would be less confusing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
