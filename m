Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52532 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbaJNM3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 08:29:06 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so10971598wgg.32
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2014 05:29:04 -0700 (PDT)
Message-ID: <543D170A.6060709@gmail.com> (sfid-20141014_142910_855594_B0A8C8DD)
Date: Tue, 14 Oct 2014 14:28:58 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: qca_vkondrat@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members
 on 60GHz band
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

related to 623d8438b724afb7c4818cb9b129a552ef2b518b at wireless-regdb.

On 12/10/2012, Vladimir Kondratiev wrote:

> Purpose is to serve for 802.11ad specification that introduces operation
> on the 60GHz band, using bandwidth 2160MHz.
> 
> For the 60GHz band, regulation defined in the "Etsi En 302 567"
> http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html
> 
> It defines for the frequency range 57 GHz to 66 GHz,
> Max. power level (EIRP) for
> indoor only: 40 dBm, and indoor/outdoor: 25 dBm
> Also, there is spectral power density limit
> 13 dBm/MHz for indoor and -2 dBm/MHz indoor/outdoor

I don't know where you did get this information.
ETSI EN 302 567 V1.2.1 (2012-01) http://www.etsi.org/deliver/etsi_en/302500_302599/302567/01.02.01_60/en_302567v010201p.pdf
doesn't handle in different way indoor/outdoor.

And also 57000 - 66000 is allowed.

So that:
"(57240 - 65880 @ 2160), (40), NO-OUTDOOR" should(must) be replaced by:
"(57000 - 66000 @ 2160), (40)"

> Only indoor part specified, as kernel can't use multiple
> rules per frequency at the moment. Also, standard do not set bandwidth limitation;
> for purpose of 802.11ad this patch specifies bandwidth 2160 MHz,
> in this case gross EIRP limit applies. Frequency limits also set accordingly
> to the 802.11ad channel allocation.
> 
> This patch apply this to the full ETSI member countries:
> [...]
>
> diff --git a/db.txt b/db.txt
> index c00602c..848c985 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -12,6 +12,10 @@ country 00:
>          (5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
>  
>  
> +country AD:
> +        # 60 gHz band channels 1-4, ref: Etsi En 302 567
> +        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> [...]
