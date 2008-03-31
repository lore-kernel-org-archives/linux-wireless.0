Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:24873 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYCaVsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 17:48:37 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1776035wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 14:48:37 -0700 (PDT)
Subject: Re: [PATCH 13/18] mac80211: mesh statistics and config through
	debugfs
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080327233816.f6cb207e.akpm@linux-foundation.org>
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142015.478371000@sipsolutions.net>
	 <20080327233816.f6cb207e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 31 Mar 2008 14:48:34 -0700
Message-Id: <1207000114.7792.27.camel@localhost> (sfid-20080331_224841_230833_41149E8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-03-27 at 23:38 -0700, Andrew Morton wrote:
> Would it be OK if we do this?
>=20
> From: Andrew Morton <akpm@linux-foundation.org>

> -IEEE80211_IF_WFILE(auto_open_plinks, u.sta.mshcfg.auto_open_plinks, =
DEC, bool);
> +IEEE80211_IF_WFILE(auto_open_plinks, u.sta.mshcfg.auto_open_plinks, =
DEC, u8);
>  IEEE80211_IF_WFILE(dot11MeshMaxPeerLinks,
>  		u.sta.mshcfg.dot11MeshMaxPeerLinks, DEC, u16);
>  IEEE80211_IF_WFILE(dot11MeshHWMPactivePathTimeout,
> _
>=20

=EF=BB=BFUsing bool ensures that only boolean values can be written to =
that
debugfs file. It is just used to cast the value, I do not know why that
causes any problem.

Anyway, using u8 would work almost the same, so it is an acceptable
solution if there is no other easy workaround.

--=20
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
