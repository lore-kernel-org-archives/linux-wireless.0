Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755634AbcJMMpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 08:45:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 3/3] rsi: Updated boot parameters
References: <1476358025-15576-1-git-send-email-prameela.j04cs@gmail.com>
Date: Thu, 13 Oct 2016 15:45:37 +0300
In-Reply-To: <1476358025-15576-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Thu, 13 Oct 2016 16:57:05
        +0530")
Message-ID: <87vawwct8u.fsf@kamboji.qca.qualcomm.com> (sfid-20161013_144551_659348_61AC5E81)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> * Switch clock info is divided in to different clock information fields for
>   readability and synchronization with firmware code.
> * Other parameters are added for future use and to make the frame size in sync
>   with latest firmware. Otherwise firmware will discard the frame considering
>   corrupted frame.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Thanks, this is much easier to review now that the style changes are gone.

>  /* structure to store configs related to UMAC clk programming */
>  struct switch_clk {
> -	__le16 switch_clk_info;
> +	__le16 switch_umac_clk : 1; /* If set rest is valid */
> +	__le16 switch_qspi_clk : 1; /* If set qspi clk will be changed */
> +	__le16 switch_slp_clk_2_32 : 1;
> +	__le16 switch_bbp_lmac_clk_reg : 1;
> +	__le16 switch_mem_ctrl_cfg : 1;
> +	__le16 reserved : 11;

This immediately caugh my eye. Are you sure this works on big endian
machines? I have never seen __le16 mixed with bitfields so I'm skeptical
that this will even work, but I don't have time to really check. Anyone
else know?

Anyway, the original code used the preferred format:

-			.switch_clk_info = cpu_to_le16(BIT(3)),

That is use BIT() or GENMASK()/FIELD_PREP() to create the bitmask in cpu
native format and then convert it with cpu_to_le*() family of functions.

-- 
Kalle Valo
