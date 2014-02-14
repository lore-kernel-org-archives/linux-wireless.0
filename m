Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:45606 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaBNBzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 20:55:12 -0500
Received: by mail-ve0-f172.google.com with SMTP id c14so9346314vea.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 17:55:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87r4767rmo.fsf@kamboji.qca.qualcomm.com>
References: <1392197844-1223-1-git-send-email-yeohchunyeow@gmail.com>
	<87r4767rmo.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 14 Feb 2014 09:55:11 +0800
Message-ID: <CAEFj986=ABAqRYXcL9_Ov8MkHVfjOnc=y9nx65hFXbBcH61WyQ@mail.gmail.com> (sfid-20140214_025517_306889_2C2CD51F)
Subject: Re: [PATCH] ath10k: implement drv_get_tsf for ibss merging
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah, this extremely ugly but don't really know any better way to handle
> this now.

I have observed that we have ath10k_wmi_event_tsf_measurement_report,
but no so sure how to trigger this event.

> But why do you need to take conf_mutex? Isn't this enough:
>
> +static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> +{
> +       /*
> +        * FIXME: Return 0 for time being. Need to figure out whether FW
> +        * has the API to fetch 64-bit TSF
> +        */
> +
> +       return 0;
> +}

Ya, I think this is enough for time being. I will submit v2 on this.

-----
Chun-Yeow
