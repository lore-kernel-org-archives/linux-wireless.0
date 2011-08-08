Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1HHSre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 14:47:34 -0400
Received: by wwf5 with SMTP id 5so1894813wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 11:47:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312809868.4372.33.camel@jlt3.sipsolutions.net>
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
	<1311638357-28740-5-git-send-email-thomas@cozybit.com>
	<1312809868.4372.33.camel@jlt3.sipsolutions.net>
Date: Mon, 8 Aug 2011 11:47:32 -0700
Message-ID: <CAG6hwVN4i5Yh_ea0j3kvPyznUuZmfxog2OzK1Y74eveU2kR6Dg@mail.gmail.com> (sfid-20110808_204737_967765_F392AC10)
Subject: Re: [PATCH 4/6] mac80211: update mesh peering frame format
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 6:24 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-07-25 at 16:59 -0700, Thomas Pedersen wrote:
>
>> -#define PLINK_GET_LLID(p) (p + 4)
>> -#define PLINK_GET_PLID(p) (p + 6)
>> +#define PLINK_GET_LLID(p) (p + 2)
>> +#define PLINK_GET_PLID(p) (p + 4)
>
> This is a more tangential comment -- but I'd feel more comfortable with
> the code if these macros were removed and some structs overlaid the IEs
> instead. But definitely not as part of this patch -- hence tangential.
>

Sounds good, I'll make a note.
>> +     case WLAN_CATEGORY_SELF_PROTECTED:
>> +             switch (mgmt->u.action.u.self_prot.action_code) {
>> +             case WLAN_SP_MESH_PEERING_OPEN:
>> +             case WLAN_SP_MESH_PEERING_CLOSE:
>> +             case WLAN_SP_MESH_PEERING_CONFIRM:
>> +                     if (!ieee80211_vif_is_mesh(&sdata->vif))
>> +                             goto invalid;
>> +                     if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
>> +                             /* userspace handles this frame */
>
> Will this compile in the CONFIG_MAC80211_MESH=n case? It seems like it
> might not? Do you routinely test that?
>

Yes. The CONFIG_MAC80211_MESH check around the ieee80211_if_mesh was
removed in c80d545da3f7c0e534ccd4a780f322f80a92cff1
> johannes

>
>
