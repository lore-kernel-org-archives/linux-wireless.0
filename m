Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:57909 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3LPMdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:33:50 -0500
Received: by mail-ve0-f171.google.com with SMTP id pa12so3275062veb.30
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 04:33:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387142056-21850-2-git-send-email-twpedersen@gmail.com>
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com> <1387142056-21850-2-git-send-email-twpedersen@gmail.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Mon, 16 Dec 2013 16:33:29 +0400
Message-ID: <CAHNKnsTAJJBNT0nj8z-4mSAC_Gh1F6M7pdu3CGAMQ70+aALx4w@mail.gmail.com> (sfid-20131216_133353_898923_40EC56CD)
Subject: Re: [PATCH 2/3] mac80211: reset TSF to 0 when joining a mesh
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Thomas,

2013/12/16 Thomas Pedersen <twpedersen@gmail.com>:
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 330d1f7..1174157 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -802,6 +802,8 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>                 return -ENOMEM;
>         }
>
> +       /* next beacon will be DTIM-1, so TSF=0 was DTIM=0 */
> +       drv_set_tsf(local, sdata, 0);
>         ieee80211_bss_info_change_notify(sdata, changed);
>
>         netif_carrier_on(sdata->dev);

What happen with AP interface on the same radio if we configure mesh
portal? Clients could be confused by such TSF jump.

-- 
BR,
Sergey
