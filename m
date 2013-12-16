Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:35544 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3LPSeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 13:34:31 -0500
Received: by mail-qe0-f42.google.com with SMTP id b4so4281924qen.15
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 10:34:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHNKnsTAJJBNT0nj8z-4mSAC_Gh1F6M7pdu3CGAMQ70+aALx4w@mail.gmail.com>
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
 <1387142056-21850-2-git-send-email-twpedersen@gmail.com> <CAHNKnsTAJJBNT0nj8z-4mSAC_Gh1F6M7pdu3CGAMQ70+aALx4w@mail.gmail.com>
From: Thomas Pedersen <twpedersen@gmail.com>
Date: Mon, 16 Dec 2013 10:34:10 -0800
Message-ID: <CAHmEv85q4c0FmvS+_kwQG9SfZgrokfYPNUvJmteKjdzxqnDvHw@mail.gmail.com> (sfid-20131216_193434_931870_A4CDB084)
Subject: Re: [PATCH 2/3] mac80211: reset TSF to 0 when joining a mesh
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 4:33 AM, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> Hello Thomas,
>
> 2013/12/16 Thomas Pedersen <twpedersen@gmail.com>:
>> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
>> index 330d1f7..1174157 100644
>> --- a/net/mac80211/mesh.c
>> +++ b/net/mac80211/mesh.c
>> @@ -802,6 +802,8 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>>                 return -ENOMEM;
>>         }
>>
>> +       /* next beacon will be DTIM-1, so TSF=0 was DTIM=0 */
>> +       drv_set_tsf(local, sdata, 0);
>>         ieee80211_bss_info_change_notify(sdata, changed);
>>
>>         netif_carrier_on(sdata->dev);
>
> What happen with AP interface on the same radio if we configure mesh
> portal? Clients could be confused by such TSF jump.

Like Johannes said; either the driver supports per-vif TSF, or well,
it doesn't. Anyway wouldn't clients reset their own TSF when the new
beacon is received?

Thomas
