Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbeBAG4T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 01:56:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 4/8] rsi: add coex support
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-5-git-send-email-amitkarwar@gmail.com>
Date: Thu, 01 Feb 2018 08:56:14 +0200
In-Reply-To: <1513168977-2121-5-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 13 Dec 2017 18:12:53 +0530")
Message-ID: <87r2q5mc4x.fsf@purkki.adurom.net> (sfid-20180201_075623_549808_64420D2D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> With BT support, driver has to handle two streams of data
> (i.e. wlan and BT). Actual coex implementation is in firmware.
> Coex module just schedule the packets to firmware by taking them
> from the corresponding paths.
>
> Structures for module and protocol operations are introduced for
> this purpose. Protocol operations structure is global structure
> which can be shared among different modules. Initialization of
> coex and operating mode values is moved to rsi_91x_init().
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> @@ -270,6 +271,7 @@ struct rsi_common {
>  	u8 obm_ant_sel_val;
>  	int tx_power;
>  	u8 ant_in_use;
> +	struct semaphore tx_bus_lock;

Do you really need to use semaphore? I think nowadays the preference is
to use something other than semaphores.

Also calling it tx_bus_lock is IMHO misleading, tx_bus_sema would be
nicer.

-- 
Kalle Valo
