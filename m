Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab0LNCXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 21:23:30 -0500
Received: by iwn9 with SMTP id 9so176962iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 18:23:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
References: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 13 Dec 2010 18:23:09 -0800
Message-ID: <AANLkTinS35SU=RZ+G=b6Q1729Zpfm5cfqjTNOCr6zSe4@mail.gmail.com>
Subject: Re: [PATCH 1/2] nl80211: Export available antennas
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 13, 2010 at 6:20 PM, Bruno Randolf <br1@einfach.org> wrote:
> Signed-off-by: Bruno Randolf <br1@einfach.org>
>
> ---
>
> v2:     rebased
> ---
>  include/linux/nl80211.h |    5 +++++
>  net/wireless/nl80211.c  |    2 ++
>  2 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index b8fa25d..63b603c 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -841,6 +841,9 @@ enum nl80211_commands {
>  *     the hardware should not be configured to receive on this antenna.
>  *     For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
>  *
> + * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL: Bitmap of antennas which are available for
> + *     configuration via the above parameters.
> + *

Not clear exactly what the point of this is -- there's no commit
message -- but should not this API distinguish between TX and RX?
E.g., several chipsets can only TX from a subset of RX antennas.

Dan
