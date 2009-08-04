Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:38110 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbZHDPSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:18:41 -0400
Received: by vws2 with SMTP id 2so1425367vws.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 08:18:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090731180238.GA7963@makis>
References: <20090731180238.GA7963@makis>
Date: Tue, 4 Aug 2009 11:18:37 -0400
Message-ID: <b6c5339f0908040818w20de62aex2d89650e09b06502@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/4]: Check EEPROM before tweaking SERDES
From: Bob Copeland <bcopeland@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 2:02 PM, Nick
Kossifidis<mick@madwifi-project.org> wrote:
> +       /* Check if PCIE_OFFSET points to PCIE_SERDES_SECTION
> +        * and enable serdes programming if needed.
> +        *
> +        * XXX: Serdes values seem to be fixed so
> +        * no need to read them here, we write them
> +        * during ath5k_hw_attach */
> +       AR5K_EEPROM_READ(AR5K_EEPROM_PCIE_OFFSET, val);
> +       ee->ee_serdes = (val == AR5K_EEPROM_PCIE_SERDES_SECTION) ?
> +                                                       true : false;

Minor nit, can just be:

> +       ee->ee_serdes = (val == AR5K_EEPROM_PCIE_SERDES_SECTION);

Just a matter of taste though, so:

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
