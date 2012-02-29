Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36894 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2B2MpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 07:45:15 -0500
Message-ID: <4F4E1DD7.4050509@openwrt.org> (sfid-20120229_134535_698728_68B34F07)
Date: Wed, 29 Feb 2012 13:45:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: YIN Wei <yinwei168@gmail.com>
CC: johannes <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	mattias.nissler@gmx.de, stefano.brivio@polimi.it
Subject: Re: [PATCH] mac80211: improve PID rate control mechanism by avoiding
 rate oscillation problem
References: <CAFxU49m76xaLGv9CFhKcZBhE-8QgT1KSuhnZRcVwzP2ogrGpbQ@mail.gmail.com>
In-Reply-To: <CAFxU49m76xaLGv9CFhKcZBhE-8QgT1KSuhnZRcVwzP2ogrGpbQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-29 1:14 PM, YIN Wei wrote:
> From: Wei YIN (Wei.Yin@nicta.com.au)
> 
> Improve PID rate control mechanism by solving the rate oscillation
> problem. Current PID mechanism is based on a PID  controller which
> tries to minimise the difference between the frame loss ratio (FLR)
> and the target FLR. Therefore it is straight forward that it increases
> to a higher rate when the FLR is less than the target without
> considering whether the higher rate can be supported. If the higher
> rate cannot be supported, significant FLR will occur, which causes the
> mechanism to decrease the rate sharply. The proposed approach only
> updates the rate when the proposed rate by the PID controller can
> achieve better throughput than the old rate. This patch applies to
> kernel 3.3.0.
> Signed-off-by: Wei YIN (Wei.Yin@nicta.com.au)
> ---
> diff -uprN wireless-testing_orig/net/mac80211/Kconfig
> wireless-testing/net/mac80211/Kconfig
> --- wireless-testing_orig/net/mac80211/Kconfig	2012-02-17
> 13:59:53.495254495 +1000
> +++ wireless-testing/net/mac80211/Kconfig	2012-02-21 11:35:40.495706869 +1000
> @@ -21,6 +21,7 @@ config MAC80211_HAS_RC
>  config MAC80211_RC_PID
>  	bool "PID controller based rate control algorithm" if EXPERT
>  	select MAC80211_HAS_RC
> +	default y
>  	---help---
>  	  This option enables a TX rate control algorithm for
>  	  mac80211 that uses a PID controller to select the TX
Several issues with this patch: line wrapping, weird encoding in the
comments: —
Also, please drop this change that alters the default value of
MAC80211_RC_PID.

- Felix
