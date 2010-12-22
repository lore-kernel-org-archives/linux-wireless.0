Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0LVN6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 08:58:38 -0500
Subject: Re: [PATCH 1/8] wireless-regdb: Add DFS bit fields for countries
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1292864555-28661-2-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
	 <1292864555-28661-2-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 14:58:27 +0100
Message-ID: <1293026307.3531.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:

>  for alpha2 in countrynames:
>      coll = countries[alpha2]
>      # struct regdb_file_reg_country
> -    output.write(struct.pack('>ccxxI', str(alpha2[0]), str(alpha2[1]), reg_rules_collections[coll.permissions]))
> +    output.write(struct.pack('>cchI', str(alpha2[0]), str(alpha2[1]), coll.cflags, reg_rules_collections[coll.permissions]))

maybe you shouldn't be using the full two bytes we have since you just
need three bits?

johannes

