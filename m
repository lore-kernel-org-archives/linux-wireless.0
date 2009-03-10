Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:55586 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZCJJIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 05:08:18 -0400
Received: by fxm24 with SMTP id 24so1535945fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 02:08:15 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] cfg80211: send regulatory beacon hint events to userspace
Date: Tue, 10 Mar 2009 10:08:04 +0100
Cc: linux-wireless@vger.kernel.org
References: <1236653332-3515-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1236653332-3515-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903101008.04862.helmut.schaa@gmail.com> (sfid-20090310_100822_562450_30E48FDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 10. M=E4rz 2009 schrieb Luis R. Rodriguez:
> This informs userspace when a change has occured on a world
> roaming wiphy's channel which has lifted some restrictions
> due to a regulatory beacon hint.
>=20
> Because this is now sent to userspace through the regulatory
> multicast group we remove the debug prints we used to use as
> they are no longer necessary.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> There is something awefully wrong with this patch and after some
> good review I cannot determine what is wrong with it. The issue is
> I end up following bug complaint saying I'm sleeping while I'm atomic=
=2E.
> but this is all from a workqueue so what gives?
>=20
> I have to be missing something obvious or could this be another issue=
?

The code is sleeping while holding a spinlock (see reg_process_pending_=
beacon_hints).

[...]

> +void nl80211_send_beacon_hint_event(struct wiphy *wiphy,
> +					   struct ieee80211_channel *channel_before,
> +					   struct ieee80211_channel *channel_after)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +	struct nlattr *nl_freqs, *nl_freq;
> +	struct ieee80211_channel *chan;
> +	unsigned int i;
> +
> +	msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);

Just using GFP_ATOMIC here should be fine.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
