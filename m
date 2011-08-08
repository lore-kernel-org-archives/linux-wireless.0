Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35690 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1HHTPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 15:15:49 -0400
Received: by wwf5 with SMTP id 5so1916270wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 12:15:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312830630.4372.40.camel@jlt3.sipsolutions.net>
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
	<1311638357-28740-5-git-send-email-thomas@cozybit.com>
	<1312809868.4372.33.camel@jlt3.sipsolutions.net>
	<CAG6hwVN4i5Yh_ea0j3kvPyznUuZmfxog2OzK1Y74eveU2kR6Dg@mail.gmail.com>
	<1312830630.4372.40.camel@jlt3.sipsolutions.net>
Date: Mon, 8 Aug 2011 12:15:48 -0700
Message-ID: <CAG6hwVOF1Ve5-u1_wWMu9DM=sV3+soBUmOHxQFip++JJYzbFYA@mail.gmail.com> (sfid-20110808_211552_778176_283B13B4)
Subject: Re: [PATCH 4/6] mac80211: update mesh peering frame format
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 8, 2011 at 12:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-08-08 at 11:47 -0700, Thomas Pedersen wrote:
>
>> >> +     case WLAN_CATEGORY_SELF_PROTECTED:
>> >> +             switch (mgmt->u.action.u.self_prot.action_code) {
>> >> +             case WLAN_SP_MESH_PEERING_OPEN:
>> >> +             case WLAN_SP_MESH_PEERING_CLOSE:
>> >> +             case WLAN_SP_MESH_PEERING_CONFIRM:
>> >> +                     if (!ieee80211_vif_is_mesh(&sdata->vif))
>> >> +                             goto invalid;
>> >> +                     if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
>> >> +                             /* userspace handles this frame */
>> >
>> > Will this compile in the CONFIG_MAC80211_MESH=n case? It seems like it
>> > might not? Do you routinely test that?
>> >
>>
>> Yes. The CONFIG_MAC80211_MESH check around the ieee80211_if_mesh was
>> removed in c80d545da3f7c0e534ccd4a780f322f80a92cff1
>
> I mean the "sdata->u.mesh.security" dereference. I know vif_is_mesh() is
> always available, but I thought u.mesh wasn't?
>

Sorry, I should have been more explicit. sdata->u.mesh is now always
available since the above commit.

> johannes
>
>
