Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaCETul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 14:50:41 -0500
Message-ID: <1394049034.6583.0.camel@jlt4.sipsolutions.net> (sfid-20140305_205203_402310_84ACE376)
Subject: Re: WEP is not working on libertas drivers.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Enric Balletbo Serra <eballetbo@gmail.com>, david.abd@gmail.com,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Wed, 05 Mar 2014 20:50:34 +0100
In-Reply-To: <1394048380.2278.9.camel@dcbw.local> (sfid-20140305_203822_760823_413635B2)
References: <CAFqH_52V8JPROp_cmJHsVEu4s+s20vbkWgL2xykDoJAAScWmVw@mail.gmail.com>
	 <1394048380.2278.9.camel@dcbw.local> (sfid-20140305_203822_760823_413635B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 13:39 -0600, Dan Williams wrote:

> which pretty much means it isn't there.  If you wanted to fix this, what
> you'd do is you'd look at priv->wdev->connect_keys, and if that was !
> NULL, you'd run through each of the 6 keys and if at least one key was
> valid, you'd then set the PRIVACY bit in the beacon.  Then later after
> the join was successful, the kernel already calls the functions for
> uploading the keys to the driver
> (net/wireless/util.c::cfg80211_upload_connect_keys()).

Small correction - you want to look at cfg80211_ibss_params->privacy,
not the connect_keys.

johannes

