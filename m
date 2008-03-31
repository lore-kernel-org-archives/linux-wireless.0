Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:17580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbYCaV4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 17:56:03 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2250938wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 14:55:58 -0700 (PDT)
Subject: Re: [PATCH 13/18] mac80211: mesh statistics and config through
	debugfs
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080327231639.fd1264b9.akpm@linux-foundation.org>
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142015.478371000@sipsolutions.net>
	 <20080327231639.fd1264b9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 31 Mar 2008 14:55:56 -0700
Message-Id: <1207000556.7792.35.camel@localhost> (sfid-20080331_225607_179853_A4D41AE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-03-27 at 23:16 -0700, Andrew Morton wrote:
> - then fix the obvious, trivial, instantly-detectable, very-deadlocka=
ble
>   bug in this patch.  There is just no longer any excuse for this:
>=20
> +	read_lock(&dev_base_lock);
> +	if (copy_from_user(buf, userbuf, buf_size))

=EF=BB=BFAs the author of the patch, I would like to apologize about th=
is.=20

Regarding review quality, I would like to point out that the function
just above this one, ieee80211_if_read(), which has been for a while in
the stable releases, suffers the same problem. That does not excuse
myself though, I should have spotted and fixed it and then implement
ieee80211_if_write() properly. I will send a patch fixing both issues
today.

Again sorry for the mess and thank you for spotting the problem.

--=20
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
