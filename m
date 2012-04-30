Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54241 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2D3HL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 03:11:28 -0400
Received: by eaaq12 with SMTP id q12so589905eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 00:11:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335768826-12529-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1335768826-12529-1-git-send-email-emmanuel.grumbach@intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 Apr 2012 17:11:06 +1000
Message-ID: <CAGRGNgWiyNUzL=Y11r-ZLyNm0dx9KqC33bN7PjMz1TiXrB0u8Q@mail.gmail.com> (sfid-20120430_091159_639127_A47C8417)
Subject: Re: [PATCH] cfg80211: fix BSS comparison
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

On Mon, Apr 30, 2012 at 16:53, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> Since the BSS table is organized in a RB tree, the BSSs need to be
> comparable. This means that we must define a < and > operator to
> the BSS object.
> compare_ethr_addr isn't enough since it returns only a binary value.
[snip]
> ---
>  net/wireless/scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index bd6a0ee..8c8b550 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -378,7 +378,7 @@ static int cmp_bss_core(struct cfg80211_bss *a,
>                               b->len_information_elements);
>        }
>
> -       return compare_ether_addr(a->bssid, b->bssid);
> +       return memcmp(a->bssid, b->bssid, sizeof(a->bssid));

You should probably add a comment here to remind people that
compare_ether_addr() will cause issues or someone will change it
again.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
