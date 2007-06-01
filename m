Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:25721 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762814AbXFASNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 14:13:38 -0400
Received: by wx-out-0506.google.com with SMTP id t15so586124wxc
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2007 11:13:38 -0700 (PDT)
Message-ID: <1ba2fa240706011113x37fc35b0mf673abd1243cd36a@mail.gmail.com>
Date: Fri, 1 Jun 2007 21:13:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: mac80211 initial rate: a question
Cc: wireless <linux-wireless@vger.kernel.org>,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <466045F2.6010708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <466045F2.6010708@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What about making the initial rate to be configurable in rc80211_simple.c ?


On 6/1/07, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In routine rate_control_simple_rate_init in net/mac80211/rc80211_simple.c, there is a comment that says
>
>          /* TODO: what is a good starting rate for STA? About middle? Maybe not
>           * the lowest or the highest rate.. Could consider using RSSI from
>           * previous packets? Need to have IEEE 802.1X auth succeed immediately
>           * after assoc.. */
>
> After that the code goes on to set the rate equal to the last one in the rate table, which might be
> the highest rate. Although that rate might be OK for most of the devices using mac80211, it
> certainly is not for bcm43xx, which does not have the ability to transmit or receive at speeds much
> above 1 Mbs. In a private patch circulated only on the bcm43xx mailing list, I changed this routine
> to set an initial rate of 1 Mbs, which certainly helps bcm43xx authenticate and communicate with the
> DHCP server.
>
> If this low rate were to be set for all drivers, how rapidly would the rate-control algorithm
> respond? Would this cause a serious performance degradation?
>
> Larry
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
