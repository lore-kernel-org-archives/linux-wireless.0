Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40547 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388781AbeGXV7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 17:59:15 -0400
Received: from mail-io0-f197.google.com ([209.85.223.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fi4Gp-0006z4-8O
        for linux-wireless@vger.kernel.org; Tue, 24 Jul 2018 20:50:59 +0000
Received: by mail-io0-f197.google.com with SMTP id y13-v6so3571518iop.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 13:50:59 -0700 (PDT)
Date: Tue, 24 Jul 2018 15:50:57 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: bkil <bkil.hu+Aq@gmail.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless-regdb: update rules for Hungary (HU) on
 2.4/5/60G, 5725-5875MHz
Message-ID: <20180724205057.GD3636@ubuntu-xps13> (sfid-20180724_225106_720994_42A97F5C)
References: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPuHQ=EWtsOs2naY2pLx9D-JJbDr1kc8sisd-JNHiEekJ5ijDQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 30, 2018 at 10:40:34PM +0200, bkil wrote:
> * 2400-2483.5M: extend bounds
> * 5150-5250M: extend bounds, add NO-OUTDOOR, no TPC so +3dB
> * 5250-5350M: extend bounds, add NO-OUTDOOR
> * 5470-5725M: extend bounds
> * 5725-5875M: introduce, as EU SRD provisions have been implemented
> * 57-66G: add NO-OUTDOOR
> 
> Freely available online references have been added hosted by the regulatory
> body in Hungary, the National Media and Infocommunications Authority.
> 
> To refer to a specific section, you can grep for the frequency in question.
> 
> Translation key:
> "Csak beltéri" / "Épületen belüli használatra korlátozott" = indoor only;
> "Kültéri és beltéri" = both indoor and outdoor;
> "Nem működő TPC esetén a maximális teljesítményjellemzők 3 dB-lel
> csökkennek." = reduce max power specs by 3dB in case of no TPC;
> "Rögzített kültéri telepítés nem megengedett" = no fixed outdoor install
> 
> Signed-off-by: bkil <b.K.il.h.u+tigbuh@gmail.com>

Apologies, I had started reviewing this a while back, but got distracted
and forgot to come back to it.

The changes look okay as far as I can tell. However the patch itself
seems to be corrupt -- one line is wrapped, and there are whitespace
problems. This is probably due to your mail client, I suggest using
git-send-email.

Can you try re-sending?

Thanks,
Seth

> ---
>  db.txt | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index 8963c01..cadfe77 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -581,13 +581,24 @@ country HT: DFS-FCC
>   (5490 - 5730 @ 160), (24), DFS
>   (5735 - 5835 @ 80), (30)
> 
> +# http://stir.nmhh.hu/?oldal=dokumentumGeneralo&root_rendeletelem_id=3&hatalyos=1
> +# http://english.nmhh.hu/cikk/297/Eljarasi_tajekoztato_a_24_GHzes_es_az_5_GHzes_savban_mukodo_berendezesek_engedelyezeserol
> +# http://nmhh.hu/dokumentum/319/kis_hatotavolsagu_eszkozok_srdk.pdf
>  country HU: DFS-ETSI
> - (2402 - 2482 @ 40), (20)
> - (5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
> - (5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
> - (5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
> - # 60 GHz band channels 1-4, ref: Etsi En 302 567
> - (57000 - 66000 @ 2160), (40)
> + # ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 300 328
> + # additionally: 100mW @ 10MHz channels, 50mW @ 5MHz (max. 10mW/MHz)
> + (2400 - 2483.5 @ 40), (20)
> + # ref: 2005/513/EK
> + # note: TPC not needed @ 5150-5250
> + (5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
> + # note: max would be +3dB with TPC @ 5250-5725
> + (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
> + (5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
> + # ref: Short Range Devices (SRD) - 2006/771/EK, (EU) 2017/1483, MSZ
> EN 300 440, MSZ EN 302 064
> + (5725 - 5875 @ 80), (25 mW)
> + # 60 GHz band channels 1-4, "Fixed outdoor installation not allowed"
> + # ref: 2006/771/EK, (EU) 2017/1483, MSZ EN 302 567
> + (57000 - 66000 @ 2160), (40), NO-OUTDOOR
> 
>  country ID: DFS-JP
>   # ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
> -- 
> 2.7.4
