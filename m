Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-i4.informatik.RWTH-Aachen.DE ([137.226.12.21]:49254 "EHLO
	mail-i4.informatik.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbXJ3T7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 15:59:54 -0400
Received: from info-4.informatik.rwth-aachen.de (cronos.info-4.informatik.rwth-aachen.de [137.226.12.31])
	by mail-i4.informatik.rwth-aachen.de (Postfix) with ESMTP id A69F79806D
	for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 20:27:32 +0100 (CET)
Date: Tue, 30 Oct 2007 20:27:40 +0100
From: Ulrich Meis <meis@nets.rwth-aachen.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Subject: Re: [ath5k-devel] [PATCH] ath5k: Remove fill_tx_desc
Message-ID: <20071030192740.GA10233@nets.rwth-aachen.de> (sfid-20071030_195957_845795_6F98D0D0)
References: <20071027235827.GH5973@localhost.domain.invalid> <43e72e890710300945r41bd982bife52835660ff0c10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890710300945r41bd982bife52835660ff0c10@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 30.10.07 12:45, Luis R. Rodriguez wrote:
> On 10/27/07, Nick Kossifidis <mick@madwifi.org> wrote:
> > fill_tx_desc is used for fast frames operation, since
> > we don't support fast frames (and since fill_tx_desc
> > had a bug -thanx to Ulrich Meis for finding that out-)
> > these functions are not needed (+ they are misleading
> > because they don't "fill" any tx descriptor).
> >
> > I couldn't test this patch much so plz someone ACK it...
> >
> > It applies on top of my previous patches (i just thought
> > that [PATCH 8/7] won't look nice ;-) ).
> >
> >
> > Changes-licensed-under: ISC
> > Signed-off-by: Ulrich Meis <meis@nets.rwth-aachen.de>
> > Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> Very nice, I've been testing this on 2.6.24-rc1 for a day without
> problems. I'll soon post results of of all your patches and your 1-7
> series on big endian. Compiling takes a while there, heh.. I guess I
> should be cross compiling huh.

People using the 5212 need the line below though if they wanna be able
to sent out frames :) It's missing in the 4word version. Besides that
the patches also seem to run fine here.

Uli

P.S.: Sry Nick, posted this to you yesterday but forgot to include the list.

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 7b9920c..dc9b881 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -3641,6 +3641,8 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
        if (buff_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
                return -EINVAL;

+       tx_desc->tx_control_1 = buff_len & AR5K_2W_TX_DESC_CTL1_BUF_LEN;
+
        tx_desc->tx_control_0 |=
                AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
                AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
