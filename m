Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760706AbYDCDfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 23:35:00 -0400
Subject: Re: [PATCH] libertas: fix mode initialization problem
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804021634.51406.hs4233@mail.mn-solutions.de>
References: <200804021634.51406.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 23:33:02 -0400
Message-Id: <1207193582.9435.6.camel@localhost.localdomain> (sfid-20080403_043509_129901_A8253EFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-02 at 16:34 +0200, Holger Schurig wrote:
> After moving lbs_find_best_network_ssid() from scan.c to assoc.c gcc was
> able to deduce that new_mode might stay uninitialized.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:29:48.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:31:10.000000000 +0200
> @@ -1021,7 +1021,7 @@ void lbs_association_worker(struct work_
>  	}
>  
>  	if (find_any_ssid) {
> -		u8 new_mode;
> +		u8 new_mode = assoc_req->mode;
>  
>  		ret = lbs_find_best_network_ssid(priv, assoc_req->ssid,
>  				&assoc_req->ssid_len, assoc_req->mode, &new_mode);

