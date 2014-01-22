Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50019 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaAVGpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 01:45:35 -0500
Received: by mail-oa0-f52.google.com with SMTP id i4so3752416oah.39
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 22:45:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390334699.6199.67.camel@jlt4.sipsolutions.net>
References: <1390334699.6199.67.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 14:45:34 +0800
Message-ID: <CAHS2MGOVvv92L7c85Z0J70mt8kM9nG-P=2G-diL4UsC6MVTJgg@mail.gmail.com> (sfid-20140122_074538_973347_C18D8DA3)
Subject: Re: [PATCH] mac80211: mesh: fix mesh_id check
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

Thanks for pointing out.

> @@ -866,7 +866,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
>         if (sdata->vif.csa_active)
>                 return true;
>
> -       if (!ifmsh->mesh_id)
> +       if (!ifmsh->mesh_id_len)

I don't see this in mac80211-next. Anyway, I think that this is not
needed since the checking (sdata->wdev.mesh_id_len) is done at
ieee80211_mesh_rx_queued_mgmt prior to
ieee80211_mesh_process_chnswitch.

---
Chun-Yeow
