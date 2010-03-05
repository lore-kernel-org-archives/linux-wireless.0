Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41200 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab0CENeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 08:34:03 -0500
Received: by gwb15 with SMTP id 15so1806341gwb.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Mar 2010 05:34:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100305063255.29522.83920.stgit@void>
References: <20100305063255.29522.83920.stgit@void>
Date: Fri, 5 Mar 2010 08:26:44 -0500
Message-ID: <b6c5339f1003050526r12b21c8awdd4ea5e0fcd72425@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath5k: fix I/Q calibration (for real)
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, 8an@praha12.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 5, 2010 at 1:32 AM, Bruno Randolf <br1@einfach.org> wrote:
> I/Q calibration was completely broken, resulting in a high number of CRC errors
> on received packets. before i could see around 10% to 20% CRC errors, with this
> patch they are between 0% and 3%.

Er, ouch.  This is definitely stable material -- can
you add cc to stable@kernel.org?

> -       i_coff = ((-iq_corr) / i_coffd);
> -
> -       /* Boundary check */
> +       i_coff = (-iq_corr) / i_coffd;
> +       /* Boundary check (signed 6 bit) */


>        if (i_coff > 31)
>                i_coff = 31;
> -       if (i_coff < -32)
> +       else if (i_coff < -32)
>                i_coff = -32;

Can't we just do

i_coff &= 0x3f;


Boundary check */
> +       q_coff = (i_pwr / q_coffd) - 128;
> +       /* Boundary check (signed 5 bit) */
>        if (q_coff > 15)
>                q_coff = 15;

q_coff &= 0x1f;

... and then these are equivalent to the masks we
already use in WRITE_BITS, right?

-- 
Bob Copeland %% www.bobcopeland.com
