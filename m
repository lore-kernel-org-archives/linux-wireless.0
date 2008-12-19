Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:39782 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYLSUle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 15:41:34 -0500
Received: by yx-out-2324.google.com with SMTP id 8so430679yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 12:41:32 -0800 (PST)
Message-ID: <b6c5339f0812191241q3f2ff8aas5d538568552aca16@mail.gmail.com> (sfid-20081219_214140_193504_02C4FBC0)
Date: Fri, 19 Dec 2008 15:41:31 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: sbrown@cortland.com
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: Keir <keirlawson@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <494C0181.8050008@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>
	 <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>
	 <494A578A.7070803@cortland.com>
	 <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>
	 <494ABA6D.8070002@cortland.com>
	 <b6c5339f0812181348x49e5c68bia827d9feb4ef0e6c@mail.gmail.com>
	 <494C0181.8050008@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 3:18 PM, Steve Brown <sbrown@cortland.com> wrote:
> If I revert this part of the pcu patch, the "queue 7" messages go away.
> Beacons remain.
>
> -       ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
> +       /* When in AP mode zero timer0 to start TSF */
> +       if (ah->ah_op_mode == NL80211_IFTYPE_AP)
> +               ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
> +       else
> +               ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);

So you're talking about AP mode and not mesh right (otherwise above code
wouldn't make a difference)?  As in the HAL we do want to write 0 there.
There's probably some other issue with setup of beacon timers.

-- 
Bob Copeland %% www.bobcopeland.com
