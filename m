Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35087 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0KLT3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:29:01 -0500
Received: by vws13 with SMTP id 13so1098067vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:29:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <12365511.1131289487494944.JavaMail.wlan@CHBU500181>
References: <30519539.771289486691846.JavaMail.wlan@CHBU500181>
	<12365511.1131289487494944.JavaMail.wlan@CHBU500181>
Date: Fri, 12 Nov 2010 14:28:58 -0500
Message-ID: <AANLkTi=MstcO94GctAjAajiFiEOAUSL63-KT_B8EahxJ@mail.gmail.com>
Subject: Re: [PATCH 7/9] ath5k: AHB port. Add specific initialization for
 RF2317 radio chip.
From: Bob Copeland <me@bobcopeland.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
> +                       /* Override settings from rf2413_ini_common_end */
> +                       ath5k_hw_reg_write(ah, 0x00004000, AR5K_PHY_AGC);
> +                       AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TPC_RG5,
> +                               AR5K_PHY_TPC_RG5_PD_GAIN_OVERLAP, 0xa);
> +                       ath5k_hw_reg_write(ah, 0x800000a8, 0x8140);
> +                       ath5k_hw_reg_write(ah, 0x000000ff, 0x9958);

It'd be better not to use magic numbers here if we know what they are.

-- 
Bob Copeland %% www.bobcopeland.com
