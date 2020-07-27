Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C551EC433E4
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 08:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9665B20714
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 08:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgG0I1v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 Jul 2020 04:27:51 -0400
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:48704 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgG0I1u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Jul 2020 04:27:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id C23DD1730850;
        Mon, 27 Jul 2020 08:27:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sleet04_270be7a26f5f
X-Filterd-Recvd-Size: 2386
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 08:27:48 +0000 (UTC)
Message-ID: <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Pkshih <pkshih@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 27 Jul 2020 01:27:47 -0700
In-Reply-To: <1595830034.12227.7.camel@realtek.com>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-07-27 at 06:07 +0000, Pkshih wrote:
> On Sat, 2020-07-25 at 12:55 -0700, Joe Perches wrote:
> > Make these statements a little simpler.
[]
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
[]
> > @@ -874,11 +874,10 @@ static void halbtc_display_wifi_status(struct
> > btc_coexist *btcoexist,
> >  	seq_printf(m, "\n %-35s = %s / %s/ %s/ AP=%d ",
> >  		   "Wifi freq/ bw/ traffic",
> >  		   gl_btc_wifi_freq_string[wifi_freq],
> > -		   ((wifi_under_b_mode) ? "11b" :
> > -		    gl_btc_wifi_bw_string[wifi_bw]),
> > -		   ((!wifi_busy) ? "idle" : ((BTC_WIFI_TRAFFIC_TX ==
> > -					      wifi_traffic_dir) ? "uplink" :
> > -					     "downlink")),
> > +		   wifi_under_b_mode ? "11b" : gl_btc_wifi_bw_string[wifi_bw],
> > +		   (!wifi_busy ? "idle" :
> > +		    wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX ? "uplink" :
> > +		    "downlink"),
> 
> I think this would be better
> 
> +		   !wifi_busy ? "idle" :
> +		   (wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX ? "uplink" :
> +		    "downlink"),

It seems most repeated test1 ? : test2 ? : test3 ?:
uses do not have the style you suggest in the kernel.


