Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:38126 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYA1AtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 19:49:08 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2648727wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 16:49:06 -0800 (PST)
Message-ID: <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com> (sfid-20080128_004913_561560_8A630ACA)
Date: Mon, 28 Jan 2008 02:49:06 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and driver conversion
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080124184357.839387000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080124183837.577631000@sipsolutions.net>
	 <20080124184357.839387000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 24, 2008 8:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> This patch creates new cfg80211 wiphy API for channel and bitrate
> registration and converts mac80211 and drivers to the new API. The
> old mac80211 API is completely ripped out. All drivers (except ath5k)
> are updated to the new API, in many cases I expect that optimisations
> can be done.
>
> Along with the regulatory code I've also ripped out the
> IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
> unnecessary if the hardware simply gives us whatever channels it wants
> to support and we then enable/disable them as required, which is pretty
> much required for travelling.
>
> Additionally, the patch adds proper "basic" rate handling for STA
> mode interface, AP mode interface will have to have new API added
> to allow userspace to set the basic rate set, currently it'll be
> empty... However, the basic rate handling will need to be moved to
> the BSS conf stuff.
>
> I do expect there to be bugs in this, especially wrt. transmit
> power handling where I'm basically clueless about how it should work.

True, total havoc

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Changes:
> v1..v3: <untracked>
> v4:     fix bugs in iwl4965

Also inserting few, actually drawing it unusable. You are lucky we
like you here :)
The question is how we handle this?. Do you want  to resubmit this
huge patch or we fix it somehow over it...

Tomas


>
