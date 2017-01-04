Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35238 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933987AbdADNcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 08:32:17 -0500
Message-ID: <1483536734.7312.7.camel@sipsolutions.net> (sfid-20170104_144828_726570_D1E677E1)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jan 2017 14:32:14 +0100
In-Reply-To: <c807ce00-46bb-e214-8bef-3544e301aad6@broadcom.com> (sfid-20161221_101814_323016_46561D57)
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
         <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
         <1481102727.4092.34.camel@sipsolutions.net>
         <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
         <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
         <20161208175236.GA6121@jouni.qca.qualcomm.com>
         <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com>
         <1481644615.20412.25.camel@sipsolutions.net>
         <20161215110635.GA11840@jouni.qca.qualcomm.com>
         <1481882211.27953.18.camel@sipsolutions.net>
         <20161220205221.GB9756@jouni.qca.qualcomm.com>
         <c807ce00-46bb-e214-8bef-3544e301aad6@broadcom.com>
         (sfid-20161221_101814_323016_46561D57)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Also I don't see the array issue. @relative_rssi_5g_pref with s8
> value seems same as @rssi_adjust with (band=5g, s8 value) packed
> together. Or am I missing something here.

Jouni is arguing that if you can specify which band to adjust, you
might want to adjust more than one band - and need an array of
(band,adjustment) rather than just a single such tuple.

But if we introduce this attribute with the tuple now, we can extend it
to an array of tuples later if we really need that.

johannes
