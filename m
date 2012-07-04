Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50186 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2GDAty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 20:49:54 -0400
Received: by yhmm54 with SMTP id m54so6747000yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 17:49:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341362473-18747-1-git-send-email-xose.vazquez@gmail.com>
References: <1341362473-18747-1-git-send-email-xose.vazquez@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 3 Jul 2012 17:49:33 -0700
Message-ID: <CAB=NE6U=bk6RSXHouuHvJd0=GErYJp82jkgeNWGnPDooZ_SONQ@mail.gmail.com> (sfid-20120704_024957_780791_26B3D6C2)
Subject: Re: [PATCH v2] wireless-regdb: Update regulatory rules for ES (Spain)
 on 5GHz and 2.4GHz
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 5:41 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> Spanish law was based on CEPT/EU rules:
> http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html
> http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000059.html
>
>
> Orden ITC/332/2010, de 12 de febrero, por la que se aprueba el cuadro
> nacional de atribución de frecuencias (CNAF):
> https://www.boe.es/diario_boe/txt.php?id=BOE-A-2010-2719
> https://www.boe.es/boe/dias/2010/02/19/pdfs/BOE-A-2010-2719.pdf
>
> search for:
>  UN - 85 RLANs y datos en 2400 a 2483,5 MHz (pag. 213)
>  UN – 128 RLANs en 5 GHz (pag. 232)
>
> more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
> http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
> ---
>  db.txt |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/db.txt b/db.txt
> index 4c54543..11409d6 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -239,10 +239,10 @@ country EG:
>         (5250 - 5330 @ 20), (N/A, 20), DFS
>
>  country ES: DFS-ETSI
> -       (2402 - 2482 @ 40), (N/A, 20)
> -       (5170 - 5250 @ 40), (N/A, 20)
> -       (5250 - 5330 @ 40), (N/A, 20), DFS
> -       (5490 - 5710 @ 40), (N/A, 27), DFS
> +       (2400 - 2483.5 @ 40), (N/A, 100 mW)
> +       (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> +       (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> +       (5470 - 5725 @ 40), (N/A, 500 mW), DFS

You are changing from dBm to mW directly... please do the unit change
in one patch and *then* the actual change. This would make it easier
to review....

  Luis
