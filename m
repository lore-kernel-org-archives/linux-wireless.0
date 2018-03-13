Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932338AbeCMPYK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:24:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 05/10] rsi: roaming enhancements
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-6-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:24:06 +0200
In-Reply-To: <1520260620-4694-6-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 5 Mar 2018 20:06:55 +0530")
Message-ID: <878taw0zjd.fsf@purkki.adurom.net> (sfid-20180313_162421_254423_FE20A8B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> To support roaming below changes are done:
> * Station notify frame is send to firmware after sending assoc
>   request. This will avoid dropping of first EAPOL frame due to
>   delay in creation of station control block in firmware.
> * Data queues are unblocked after sending station notify in open
>   mode, after configuring key in WEP mode, and after receiving
>   EAPOL4 confirm in WPA mode.
> * Initial EAPOL frames priority is chaged to MGMT, rekey EAPOL
>   frames priority changed to VO.
> * Data frames with wrong BSSID are dropped.

I don't know what Johannes thinks but IMHO the driver should not drop
any data frames, it should just submit what mac80211 gives to it. All
filtering should happen in mac80211 (or controlled by it).

-- 
Kalle Valo
