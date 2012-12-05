Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49807 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2LEWVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 17:21:21 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so5487wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 14:21:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1WUzo0jBv=zJ4Bw+A_4=zr9YszCzP+X4ujXFfGwKAk8w@mail.gmail.com>
References: <1354393301-11051-1-git-send-email-lewurm@gmail.com>
 <CAAr_hs53SddPbUUAdaqBFjc8fx-sqDPVjqkq645cMptQqsaQOw@mail.gmail.com> <CAD2nsn1WUzo0jBv=zJ4Bw+A_4=zr9YszCzP+X4ujXFfGwKAk8w@mail.gmail.com>
From: Bernhard Urban <lewurm@gmail.com>
Date: Wed, 5 Dec 2012 23:13:29 +0100
Message-ID: <CAAr_hs6GpSse8t2tbr7p3GcqsHm6+qe--=XFk+1ezt9TBS0irA@mail.gmail.com> (sfid-20121205_232125_734457_A767BF0E)
Subject: Re: [PATCH] ath9k_htc: update RSSI values only when the device is associated
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	c_manoha@qca.qualcomm.com, Sujith.Manoharan@atheros.com,
	linville@tuxdriver.com, m.sujith@gmail.com, nbd@openwrt.org,
	markus@indoo.rs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

thanks for your comment

On Mon, Dec 3, 2012 at 7:41 AM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> >> -       last_rssi = priv->rx.last_rssi;
> >> +       if (is_mybeacon && priv->ah->opmode == NL80211_IFTYPE_STATION) {
> >> +               if (rxbuf->rxstatus.rs_rssi != ATH9K_RSSI_BAD &&
> >> +                   !rxbuf->rxstatus.rs_moreaggr)
> >> +                       ATH_RSSI_LPF(priv->rx.last_rssi,
> >> +                                    rxbuf->rxstatus.rs_rssi);
>
> should we account for IBSS mode ?

Yeah, it would make sense but it changes my measureresults
significantly, although my device is never in ad-hoc mode. I already
posted a question regarding this topic:
http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg09470.html


Thanks,
Bernhard
