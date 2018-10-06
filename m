Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82127C67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2696921473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A35l5f4c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2696921473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbeJGBEQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 21:04:16 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:46162 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJGBEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 21:04:16 -0400
Received: by mail-qt1-f173.google.com with SMTP id d8-v6so17107879qtk.13
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2018 11:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K4ZbR8Gi/rJeu9yJvcrHgOaXLbkjHgv8z1N5yjCN64Q=;
        b=A35l5f4cUguFxqpnmcsqGEWXtf8xQD068/44tB49RrOAsxWJle/WgfuwzPK4qeYezv
         WkPxXUnd0BcEsvq9gHyXzCdM3gU0KhQiJPI+m1urakOusZyOs8XMsvF2HNiXwM5yYvwf
         WOGoUBXNDCH0kx08YDNipAJOoEPJj8BTudlFDGMrNROta1z81wgdKpF9FX5Br81wDf+4
         dFyzJN0dtbEsbhu9dwJbTgAyOObviA0oA1zCM0lnQxzYqh8b1LfhVN1eYuiqQ2Ns3TZI
         Tm97Q5X6htUq8v6dWWDPlbLg5P46u2o6KotwXRDhzaH4KNvCU7ZApmkUsJIDuIQ+qjbJ
         HbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K4ZbR8Gi/rJeu9yJvcrHgOaXLbkjHgv8z1N5yjCN64Q=;
        b=AZK2T9R7vmZOcOQ/BhN6t5X3t2NGGxKtN54Hu2U4rQwlJhoks5h4XaRrY5LLJsX5D8
         SvLCKpJluFdzU6gTwXlEGs8q1byFWv17CZF2WvLpVF5kQ91RwuFkzbZBhC8r/kxlB4D9
         Iocflso7bLu7ZIuZ3ATWpuhrWip87qh8cX5i14yhnPybHqfVcfpRPl1dHfp8lgQheMpF
         oNr1S4fR38/91ArQRjq6Q2KNxo9aVZ/lHvnQoXKKBZX11eGk6Jwyl8dDRb+HPNKUgU2A
         +9LxXD/ECAEXe+FGHfA0N+57hWb1vzSRqxqzxZzjgFrEC3IAw72yBZuXc2+zAnEnk4gq
         Tx3A==
X-Gm-Message-State: ABuFfojfjFyfplBCc7pOUCQDWp9T4KC/fmJCjBJtkt6B7ogwXKUWpiaz
        6RebiQvkVlFTEOPqozutfr65H2J+Yu3l5NbzheQ=
X-Google-Smtp-Source: ACcGV60JHS4LcU2F11vYyMpv8p5KhmS3KE1vLE9YJ23GxL090tFq1mrU3BzEaV6XOp91bwXVY23GaktRJs0fYVuMxxc=
X-Received: by 2002:ac8:2d9d:: with SMTP id p29-v6mr14143836qta.238.1538848800045;
 Sat, 06 Oct 2018 11:00:00 -0700 (PDT)
MIME-Version: 1.0
References: <20181006173507.7316-1-nbd@nbd.name> <20181006173507.7316-9-nbd@nbd.name>
In-Reply-To: <20181006173507.7316-9-nbd@nbd.name>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sat, 6 Oct 2018 10:59:47 -0700
Message-ID: <CAA93jw48KRNTcGy_RecY8u-1wqL9uWzeP4JK4-pgf9LV9ihzDQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] mac80211: rc80211_minstrel: remove variance / stddev calculation
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew McGregor <andrewmcgr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 6, 2018 at 10:37 AM Felix Fietkau <nbd@nbd.name> wrote:
>
> When there are few packets (e.g. for sampling attempts), the exponentiall=
y
> weighted variance is usually vastly overestimated, making the resulting d=
ata
> essentially useless. As far as I know, there has not been any practical u=
se
> for this, so let's not waste any cycles on it.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/mac80211/rc80211_minstrel.c            |  6 -----
>  net/mac80211/rc80211_minstrel.h            | 26 +---------------------
>  net/mac80211/rc80211_minstrel_debugfs.c    | 14 ++++--------
>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 14 ++++--------
>  4 files changed, 9 insertions(+), 51 deletions(-)
>
> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minst=
rel.c
> index dead57ba9eac..a34e9c2ca626 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -167,12 +167,6 @@ minstrel_calc_rate_stats(struct minstrel_rate_stats =
*mrs)
>                 if (unlikely(!mrs->att_hist)) {
>                         mrs->prob_ewma =3D cur_prob;
>                 } else {
> -                       /* update exponential weighted moving variance */
> -                       mrs->prob_ewmv =3D minstrel_ewmv(mrs->prob_ewmv,
> -                                                       cur_prob,
> -                                                       mrs->prob_ewma,
> -                                                       EWMA_LEVEL);
> -
>                         /*update exponential weighted moving avarage */
>                         mrs->prob_ewma =3D minstrel_ewma(mrs->prob_ewma,
>                                                        cur_prob,
> diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minst=
rel.h
> index 54b2b2c3e10a..23ec953e3a24 100644
> --- a/net/mac80211/rc80211_minstrel.h
> +++ b/net/mac80211/rc80211_minstrel.h
> @@ -35,19 +35,6 @@ minstrel_ewma(int old, int new, int weight)
>         return old + incr;
>  }
>
> -/*
> - * Perform EWMV (Exponentially Weighted Moving Variance) calculation
> - */

I worry about this one. where are you getting your proof from?

> -static inline int
> -minstrel_ewmv(int old_ewmv, int cur_prob, int prob_ewma, int weight)
> -{
> -       int diff, incr;
> -
> -       diff =3D cur_prob - prob_ewma;
> -       incr =3D (EWMA_DIV - weight) * diff / EWMA_DIV;
> -       return weight * (old_ewmv + MINSTREL_TRUNC(diff * incr)) / EWMA_D=
IV;
> -}
> -
>  struct minstrel_rate_stats {
>         /* current / last sampling period attempts/success counters */
>         u16 attempts, last_attempts;
> @@ -56,11 +43,8 @@ struct minstrel_rate_stats {
>         /* total attempts/success counters */
>         u32 att_hist, succ_hist;
>
> -       /* statistis of packet delivery probability
> -        *  prob_ewma - exponential weighted moving average of prob
> -        *  prob_ewmsd - exp. weighted moving standard deviation of prob =
*/
> +       /* prob_ewma - exponential weighted moving average of prob */
>         u16 prob_ewma;
> -       u16 prob_ewmv;
>
>         /* maximum retry counts */
>         u8 retry_count;
> @@ -140,14 +124,6 @@ struct minstrel_debugfs_info {
>         char buf[];
>  };
>
> -/* Get EWMSD (Exponentially Weighted Moving Standard Deviation) * 10 */
> -static inline int
> -minstrel_get_ewmsd10(struct minstrel_rate_stats *mrs)
> -{
> -       unsigned int ewmv =3D mrs->prob_ewmv;
> -       return int_sqrt(MINSTREL_TRUNC(ewmv * 1000 * 1000));
> -}
> -
>  extern const struct rate_control_ops mac80211_minstrel;
>  void minstrel_add_sta_debugfs(void *priv, void *priv_sta, struct dentry =
*dir);
>
> diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc802=
11_minstrel_debugfs.c
> index 698a668b5316..c8afd85b51a0 100644
> --- a/net/mac80211/rc80211_minstrel_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_debugfs.c
> @@ -70,14 +70,13 @@ minstrel_stats_open(struct inode *inode, struct file =
*file)
>         p =3D ms->buf;
>         p +=3D sprintf(p, "\n");
>         p +=3D sprintf(p,
> -                    "best   __________rate_________    ________statistic=
s________    ____last_____    ______sum-of________\n");
> +                    "best   __________rate_________    ____statistics___=
    ____last_____    ______sum-of________\n");
>         p +=3D sprintf(p,
> -                    "rate  [name idx airtime max_tp]  [avg(tp) avg(prob)=
 sd(prob)]  [retry|suc|att]  [#success | #attempts]\n");
> +                    "rate  [name idx airtime max_tp]  [avg(tp) avg(prob)=
]  [retry|suc|att]  [#success | #attempts]\n");
>
>         for (i =3D 0; i < mi->n_rates; i++) {
>                 struct minstrel_rate *mr =3D &mi->r[i];
>                 struct minstrel_rate_stats *mrs =3D &mi->r[i].stats;
> -               unsigned int prob_ewmsd;
>
>                 *(p++) =3D (i =3D=3D mi->max_tp_rate[0]) ? 'A' : ' ';
>                 *(p++) =3D (i =3D=3D mi->max_tp_rate[1]) ? 'B' : ' ';
> @@ -93,15 +92,13 @@ minstrel_stats_open(struct inode *inode, struct file =
*file)
>                 tp_max =3D minstrel_get_tp_avg(mr, MINSTREL_FRAC(100,100)=
);
>                 tp_avg =3D minstrel_get_tp_avg(mr, mrs->prob_ewma);
>                 eprob =3D MINSTREL_TRUNC(mrs->prob_ewma * 1000);
> -               prob_ewmsd =3D minstrel_get_ewmsd10(mrs);
>
> -               p +=3D sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u    %3u.=
%1u"
> +               p +=3D sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u"
>                                 "     %3u   %3u %-3u   "
>                                 "%9llu   %-9llu\n",
>                                 tp_max / 10, tp_max % 10,
>                                 tp_avg / 10, tp_avg % 10,
>                                 eprob / 10, eprob % 10,
> -                               prob_ewmsd / 10, prob_ewmsd % 10,
>                                 mrs->retry_count,
>                                 mrs->last_success,
>                                 mrs->last_attempts,
> @@ -137,7 +134,6 @@ minstrel_stats_csv_open(struct inode *inode, struct f=
ile *file)
>         for (i =3D 0; i < mi->n_rates; i++) {
>                 struct minstrel_rate *mr =3D &mi->r[i];
>                 struct minstrel_rate_stats *mrs =3D &mi->r[i].stats;
> -               unsigned int prob_ewmsd;
>
>                 p +=3D sprintf(p, "%s" ,((i =3D=3D mi->max_tp_rate[0]) ? =
"A" : ""));
>                 p +=3D sprintf(p, "%s" ,((i =3D=3D mi->max_tp_rate[1]) ? =
"B" : ""));
> @@ -153,14 +149,12 @@ minstrel_stats_csv_open(struct inode *inode, struct=
 file *file)
>                 tp_max =3D minstrel_get_tp_avg(mr, MINSTREL_FRAC(100,100)=
);
>                 tp_avg =3D minstrel_get_tp_avg(mr, mrs->prob_ewma);
>                 eprob =3D MINSTREL_TRUNC(mrs->prob_ewma * 1000);
> -               prob_ewmsd =3D minstrel_get_ewmsd10(mrs);
>
> -               p +=3D sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,%u,"
> +               p +=3D sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,%u,"
>                                 "%llu,%llu,%d,%d\n",
>                                 tp_max / 10, tp_max % 10,
>                                 tp_avg / 10, tp_avg % 10,
>                                 eprob / 10, eprob % 10,
> -                               prob_ewmsd / 10, prob_ewmsd % 10,
>                                 mrs->retry_count,
>                                 mrs->last_success,
>                                 mrs->last_attempts,
> diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc=
80211_minstrel_ht_debugfs.c
> index 8065da2cf0f1..57820a5f2c16 100644
> --- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
> +++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
> @@ -57,7 +57,6 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, int =
i, char *p)
>                 struct minstrel_rate_stats *mrs =3D &mi->groups[i].rates[=
j];
>                 static const int bitrates[4] =3D { 10, 20, 55, 110 };
>                 int idx =3D i * MCS_GROUP_RATES + j;
> -               unsigned int prob_ewmsd;
>                 unsigned int duration;
>
>                 if (!(mi->supported[i] & BIT(j)))
> @@ -104,15 +103,13 @@ minstrel_ht_stats_dump(struct minstrel_ht_sta *mi, =
int i, char *p)
>                 tp_max =3D minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC=
(100, 100));
>                 tp_avg =3D minstrel_ht_get_tp_avg(mi, i, j, mrs->prob_ewm=
a);
>                 eprob =3D MINSTREL_TRUNC(mrs->prob_ewma * 1000);
> -               prob_ewmsd =3D minstrel_get_ewmsd10(mrs);
>
> -               p +=3D sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u    %3u.=
%1u"
> +               p +=3D sprintf(p, "%4u.%1u    %4u.%1u     %3u.%1u"
>                                 "     %3u   %3u %-3u   "
>                                 "%9llu   %-9llu\n",
>                                 tp_max / 10, tp_max % 10,
>                                 tp_avg / 10, tp_avg % 10,
>                                 eprob / 10, eprob % 10,
> -                               prob_ewmsd / 10, prob_ewmsd % 10,
>                                 mrs->retry_count,
>                                 mrs->last_success,
>                                 mrs->last_attempts,
> @@ -149,9 +146,9 @@ minstrel_ht_stats_open(struct inode *inode, struct fi=
le *file)
>
>         p +=3D sprintf(p, "\n");
>         p +=3D sprintf(p,
> -                    "              best   ____________rate__________    =
________statistics________    _____last____    ______sum-of________\n");
> +                    "              best   ____________rate__________    =
____statistics___    _____last____    ______sum-of________\n");
>         p +=3D sprintf(p,
> -                    "mode guard #  rate  [name   idx airtime  max_tp]  [=
avg(tp) avg(prob) sd(prob)]  [retry|suc|att]  [#success | #attempts]\n");
> +                    "mode guard #  rate  [name   idx airtime  max_tp]  [=
avg(tp) avg(prob)]  [retry|suc|att]  [#success | #attempts]\n");
>
>         p =3D minstrel_ht_stats_dump(mi, MINSTREL_CCK_GROUP, p);
>         for (i =3D 0; i < MINSTREL_CCK_GROUP; i++)
> @@ -206,7 +203,6 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *mi=
, int i, char *p)
>                 struct minstrel_rate_stats *mrs =3D &mi->groups[i].rates[=
j];
>                 static const int bitrates[4] =3D { 10, 20, 55, 110 };
>                 int idx =3D i * MCS_GROUP_RATES + j;
> -               unsigned int prob_ewmsd;
>                 unsigned int duration;
>
>                 if (!(mi->supported[i] & BIT(j)))
> @@ -251,14 +247,12 @@ minstrel_ht_stats_csv_dump(struct minstrel_ht_sta *=
mi, int i, char *p)
>                 tp_max =3D minstrel_ht_get_tp_avg(mi, i, j, MINSTREL_FRAC=
(100, 100));
>                 tp_avg =3D minstrel_ht_get_tp_avg(mi, i, j, mrs->prob_ewm=
a);
>                 eprob =3D MINSTREL_TRUNC(mrs->prob_ewma * 1000);
> -               prob_ewmsd =3D minstrel_get_ewmsd10(mrs);
>
> -               p +=3D sprintf(p, "%u.%u,%u.%u,%u.%u,%u.%u,%u,%u,"
> +               p +=3D sprintf(p, "%u.%u,%u.%u,%u.%u,%u,%u,"
>                                 "%u,%llu,%llu,",
>                                 tp_max / 10, tp_max % 10,
>                                 tp_avg / 10, tp_avg % 10,
>                                 eprob / 10, eprob % 10,
> -                               prob_ewmsd / 10, prob_ewmsd % 10,
>                                 mrs->retry_count,
>                                 mrs->last_success,
>                                 mrs->last_attempts,
> --
> 2.17.0
>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
