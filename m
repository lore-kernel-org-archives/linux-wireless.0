Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:57437 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab3BSAuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 19:50:07 -0500
Received: by mail-bk0-f45.google.com with SMTP id i18so2809685bkv.18
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 16:50:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVPAAU-funSovS=3Lh1YddPpKa2xc1SS0bS3A-axqUt01w@mail.gmail.com>
References: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com>
	<1361214203.8555.40.camel@jlt4.sipsolutions.net>
	<CAG6hwVPAAU-funSovS=3Lh1YddPpKa2xc1SS0bS3A-axqUt01w@mail.gmail.com>
Date: Tue, 19 Feb 2013 08:50:04 +0800
Message-ID: <CAEFj9865=-_XEi-dXQotWahCn47E87P7nzvghPCz1jEPVwqk5A@mail.gmail.com> (sfid-20130219_015013_189156_EB7E51EB)
Subject: Re: [PATCH] mac80211: fix the problem of unicast forwarding from DS
 to DS in Mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, cedric.voncken@acksys.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I think he's deleting the mpath if an mppath was found (mpath is not
> valid), but this cleanup will happen in the housekeeping work anyway,
> so it's not needed here.

Unfortunately, the housekeeping takes about 10 minutes to delete the
mpath. In that case, if the mesh STA moves in and out from DS to MBSS
or vice versa, the connectivity is loss for that duration.

---
Chun-Yeow
