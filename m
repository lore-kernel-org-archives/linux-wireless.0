Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35430 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2K2HsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 02:48:09 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so8309867lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 23:48:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <A16247DB21CEBB409D0827EB13D43B451696F72F@NASANEXD02E.na.qualcomm.com>
References: <A16247DB21CEBB409D0827EB13D43B4501F6200E@NASANEXD02E.na.qualcomm.com>
 <9DB666D2CF7F704E84559F1AEF4EBA97193ECF5C@aphydexd01a> <906BB7F9E7542D408351AC9D2A8FDABA03DC4DE0@nasanexd02f.na.qualcomm.com>
 <50B6EFC4.4070505@qca.qualcomm.com> <A16247DB21CEBB409D0827EB13D43B451696F72F@NASANEXD02E.na.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 28 Nov 2012 23:47:47 -0800
Message-ID: <CAB=NE6Wf4WSzej2v+1QM3NEkhoDv28aWahUxD+bPr4erDqsp7g@mail.gmail.com> (sfid-20121129_084813_744057_10294B20)
Subject: Re: [patch] add K3 and PS to db.txt
To: "Bu, Jinsong" <jinsong@qca.qualcomm.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>,
	"Mani, Raja" <rmani@qca.qualcomm.com>,
	"Sundar, Mohan Kumar" <msundar@qca.qualcomm.com>,
	"Jin, Navy" <nhjin@qca.qualcomm.com>,
	"Thiagarajan, Vasanthakumar" <vthiagar@qca.qualcomm.com>,
	"Yuan, Ye" <yeyuan@qca.qualcomm.com>,
	wireless-regdb@lists.infradead.org,
	Michael Green <green@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 11:38 PM, Bu, Jinsong <jinsong@qca.qualcomm.com> wrote:
> Hi John,
>
> I created a patch to add K3 and PS country string to db.txt, please review the patch.
>
> Note that I copied KP's rules for K3 since they are all APL9_WORLD.
>
> -------------------------------------------------------------------------------------------------------------------------------------
> From a006587d846cd91a07d3e232421947bc3f96e235 Mon Sep 17 00:00:00 2001
> From: jinsong <jinsong@qca.qualcomm.com>
> Date: Thu, 29 Nov 2012 15:15:21 +0800
> Subject: [PATCH] add K3 and PS
>
>
> Signed-off-by: jinsong <jinsong@qca.qualcomm.com>
> ---
>  db.txt |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/db.txt b/db.txt
> index 4c54543..a7ff207 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -391,6 +391,13 @@ country JO:
>         (2402 - 2482 @ 40), (N/A, 20)
>         (5170 - 5250 @ 40), (N/A, 18)
>
> +country K3:
> +       (2402 - 2482 @ 40), (N/A, 20)
> +       (5170 - 5330 @ 40), (3, 20)
> +       (5160 - 5250 @ 40), (3, 20), DFS
> +       (5490 - 5630 @ 40), (3, 30), DFS
> +       (5735 - 5815 @ 40), (3, 30)
> +

What is K3? Please note that I removed all variations of different
regulatory domains for a country when I converted the HAL reg code out
to db.txt format for CRDA. The intent was to provide a unified up to
date regulatory solution only. All variations that are "preferred"
should simply just rely on the old rules if these need to be
productized for whatever OEM/parnoid/stupid reasons. Please let me
know if you find a good reason to actually add these and if so please
consider adding them as custom regulatory domains which we do support
-- see the custom world regulatory domains on the ath module.

>  country KE:
>         (2402 - 2482 @ 40), (N/A, 20)
>         (5735 - 5835 @ 40), (N/A, 30)
> @@ -554,6 +561,12 @@ country PL: DFS-ETSI
>         (5250 - 5330 @ 40), (N/A, 20), DFS
>         (5490 - 5710 @ 40), (N/A, 27), DFS
>
> +country PS:
> +       (2402 - 2472 @ 40), (3, 27)
> +       (5170 - 5250 @ 40), (3, 17)
> +       (5250 - 5330 @ 40), (3, 23), DFS
> +       (5735 - 5835 @ 40), (3, 30)
> +

What is PS? Historically the Atheros HAL has used "PS" for Public
Safety but not that technically it is the ISO3166-alpha2 country code
for Palestine, did you intend to define that or Public Safety? If your
intent was to try to add Public Safety then consider using the custom
regulatory domains but then also try to figure out with marketing /
etc if we ever want to sell products to Palestine.

  Luis
