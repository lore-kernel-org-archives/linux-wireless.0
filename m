Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:56603 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683AbZLFVtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 16:49:35 -0500
Received: by iwn35 with SMTP id 35so2686828iwn.4
        for <linux-wireless@vger.kernel.org>; Sun, 06 Dec 2009 13:49:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912061829.32633.8an@praha12.net>
References: <200912061820.26320.8an@praha12.net> <200912061829.32633.8an@praha12.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 6 Dec 2009 13:49:22 -0800
Message-ID: <43e72e890912061349m341f95bbl89abaad8d3dec1c1@mail.gmail.com>
Subject: Re: [PATCH] iw: Add support for NL80211_ATTR_WIPHY_COVERAGE_CLASS
To: 8an@praha12.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 6, 2009 at 9:29 AM, Lukáš Turek <8an@praha12.net> wrote:
> New nl80211 attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS allows setting
> IEEE 802.11 coverage class, which is then used by drivers to calculate
> slot time and ACK timeout for long distance links.
>
> Two iw parameters are added: 'coverage' sets the coverage class
> directly, while 'distance' is more user-friendly, as it allows to set
> just the link distance and let iw do the necessary calculation itself.
>
> Signed-off-by: Lukas Turek <8an@praha12.net>
> ---
>  info.c    |    7 +++++++
>  nl80211.h |   15 +++++++++++++++
>  phy.c     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+), 0 deletions(-)
>
> diff --git a/info.c b/info.c
> index ddff78b..3c69afc 100644
> --- a/info.c
> +++ b/info.c
> @@ -264,6 +264,13 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
>                        printf("\tRTS threshold: %d\n", rts);
>        }
>
> +       if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
> +               unsigned int coverage;

Just some quick comments.

u8 seems more appropriate, given that you define this a u8 anyway.

> +
> +               coverage = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
> +               printf("\tCoverage class: %d (up to %dm)\n", coverage, 900 * coverage);

printf ?

  Luis
