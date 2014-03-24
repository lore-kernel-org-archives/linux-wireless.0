Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64658 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaCXHtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 03:49:45 -0400
Received: by mail-vc0-f174.google.com with SMTP id ld13so5199907vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 00:49:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395441560-6028-1-git-send-email-greearb@candelatech.com>
References: <1395441560-6028-1-git-send-email-greearb@candelatech.com>
Date: Mon, 24 Mar 2014 15:49:44 +0800
Message-ID: <CAEFj985_eDiVj2eeJeH0a6o0a0pTrO1NAsL457w82fL5HYW9Fw@mail.gmail.com> (sfid-20140324_084949_141084_69934FA3)
Subject: Re: [PATCH v2] ath10k: add the Rx rate in FW stats
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -                       tmp += sizeof(struct wmi_peer_stats);
> +                       if (test_bit(ATH10K_FW_FEATURE_WMI_10X,
> +                                    ar->fw_features)) {
> +                               s->peer_rx_rate =
> +                                       __le32_to_cpu(peer_stats->peer_rx_rate);
> +                               tmp += sizeof(struct wmi_peer_stats_10x);
> +

Oops, additional space.

Tested and working for me.

----
Chun-Yeow
