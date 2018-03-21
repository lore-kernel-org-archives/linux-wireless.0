Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34004 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeCUKPy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 06:15:54 -0400
Message-ID: <1521627352.2645.27.camel@sipsolutions.net> (sfid-20180321_111558_049044_A7A1A312)
Subject: Re: [PATCH 2/2] cfg80211: Modify wiphy registration semantics for
 self managed hints
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amar Singhal <asinghal@codeaurora.org>,
        Kiran Kumar Lokere <klokere@codeaurora.org>
Date: Wed, 21 Mar 2018 11:15:52 +0100
In-Reply-To: <1520106021-16836-2-git-send-email-jouni@codeaurora.org>
References: <1520106021-16836-1-git-send-email-jouni@codeaurora.org>
         <1520106021-16836-2-git-send-email-jouni@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I really think this should just be one patch - it's not about
"registration semantics" but about which types of requests get passed
to reg_notifier(), and if you do it in one place you'd better also do
it in the other.

Secondly, this changes behaviour - not only for ath which presumably is
what you want, but also for
 * brcmfmac
 * brcmsmac
 * libertas
 * mwifiex
 * mt76
 * qtnfmac
 * rtlwifi (& its staging cousin)
 * rsi
 * wlcore
 * rtl8723bs (staging)

So I'm not really convinced we should do this unconditionally.

johannes
