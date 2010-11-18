Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44803 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0KRS3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:29:15 -0500
Received: by iwn35 with SMTP id 35so3789199iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 10:29:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290029817-711-1-git-send-email-linville@tuxdriver.com>
References: <20100525151429.GC6342@tpkurt2.garloff.de> <1290029817-711-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 18 Nov 2010 10:28:48 -0800
Message-ID: <AANLkTimDkoqNbkFWDsU2HgFK3926gRpcBbokX_GL5sSc@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: update rules for DE
To: "John W. Linville" <linville@tuxdriver.com>,
	Michael Green <Michael.Green@atheros.com>
Cc: wireless-regdb@lists.infradead.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Kurt Garloff <garloff@suse.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 1:36 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> From: Kurt Garloff <garloff@suse.de>
>
> http://marc.info/?l=linux-wireless&m=127480075306482&w=2
>
> Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Time to clear the logjam...

Michael, are you subscribed to wireless-regdb now? Did you get this e-mail? ACK?

  Luis

>  db.txt |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index e63a43e..40a8bbc 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -176,17 +176,27 @@ country CZ:
>        (5250 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
>        (5470 - 5725 @ 40), (N/A, 1000 mW), DFS
>
> -# Data from "Frequenznutzungsplan" (as published in April 2008),
> -# downloaded from http://www.bundesnetzagentur.de/media/archive/13358.pdf
> -# Also applicable is http://www.bundesnetzagentur.de/media/archive/5009.pdf
> -# On the 5 GHz ranges TX power can be doubled if TPC is implemented.
> +# Data from "Frequenznutzungsplan" (as published in April 2008), downloaded from
> +# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/publicationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
> +# For the 5GHz range also see
> +# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/publicationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
> +# The values have been reduced by a factor of 2 (3db) for non TPC devices
> +# (in other words: devices with TPC can use twice the tx power of this table).
> +# Note that the docs do not require TPC for 5150--5250; the reduction to
> +# 100mW thus is not strictly required -- however the conservative 100mW
> +# limit is used here as the non-interference with radar and satellite
> +# apps relies on the attenuation by the building walls only in the
> +# absence of DFS; the neighbour countries have 100mW limit here as well.
> +
>  country DE:
>        # entries 279004 and 280006
>        (2400 - 2483.5 @ 40), (N/A, 100 mW)
> -       # entries 303005, 304002 and 305002
> -       (5150 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> +       # entry 303005
> +       (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> +       # entries 304002 and 305002
> +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>        # entries 308002, 309001 and 310003
> -       (5470 - 5725 @ 40), (N/A, 500 mW), NO-OUTDOOR, DFS
> +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS
>
>  country DK:
>        (2402 - 2482 @ 40), (N/A, 20)
> --
> 1.7.3.2
>
>
