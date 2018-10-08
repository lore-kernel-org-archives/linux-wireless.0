Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B2AC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69903204EC
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69903204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbeJHV4u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:56:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56720 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbeJHV4t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:56:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9Wm4-0008OW-Ai; Mon, 08 Oct 2018 16:44:44 +0200
Message-ID: <1539009873.3687.79.camel@sipsolutions.net>
Subject: Re: [PATCH 14/19] wilc: add linux_mon.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:44:33 +0200
In-Reply-To: <1537957525-11467-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122626_311829_D43D65D0)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-15-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122626_311829_D43D65D0)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:
> 
> +static struct net_device *wilc_wfi_mon; /* global monitor netdev */

There might not exist platforms with multiple devices (yet), but it's
really bad practice to do this anyway.

> +static u8 srcadd[6];
> +static u8 bssid[6];
> +
> +#define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
> +#define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/

Uh.. we have a radiotap include file and you already use it, why?

> +void wilc_wfi_deinit_mon_interface(void)
> +{
> +	bool rollback_lock = false;
> +
> +	if (wilc_wfi_mon) {
> +		if (rtnl_is_locked()) {
> +			rtnl_unlock();
> +			rollback_lock = true;
> +		}
> +		unregister_netdev(wilc_wfi_mon);
> +
> +		if (rollback_lock) {
> +			rtnl_lock();
> +			rollback_lock = false;
> +		}
> +		wilc_wfi_mon = NULL;
> +	}
> +}

Uh, no, you really cannot do conditional locking like this.

But seeing things like this pretty much destroys all of the confidence I
might have had of the code, so I'd say we cannot merge this until you
can demonstrate somebody more familiar with Linux has reviewed it, I'm
just doing a drive-by review for the stack integration aspects (and
haven't even found where that happens yet).

johannes
