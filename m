Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35076 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934217AbdLSJpd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:45:33 -0500
Message-ID: <1513676731.26145.8.camel@sipsolutions.net> (sfid-20171219_104536_883727_316CC599)
Subject: Re: [PATCH 1/2] cfg80211/nl80211: Optional authentication offload
 to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
Date: Tue, 19 Dec 2017 10:45:31 +0100
In-Reply-To: <829f69319fad450db616f02de781d1a8@aphydexm01b.ap.qualcomm.com>
References: <1513187438-23967-1-git-send-email-jouni@qca.qualcomm.com>
         <A0B39E95-DAA8-4676-A0C7-8C21DBFE7DE4@holtmann.org>
         <829f69319fad450db616f02de781d1a8@aphydexm01b.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-15 at 08:51 +0000, Srinivas Dasari wrote:
> > don’t we actually need a flag in NL80211_CMD_CONNECT that indicates that userspace is able to actually handle NL80211_CMD_EXTERNAL_AUTH. It is nice >that there is feature for userspace to see if the driver supports it, but how is the driver able to offload successfully if it doesn’t know that userspace can do it.
> 
> Our idea was the driver to timeout the connect for the scenarios where the external auth (SAE) status is not indicated.
> I agree with you on user space indicating this capability to the driver. 
> Is it a fair idea to extend enum cfg80211_assoc_req_flags for this ? 

Seems reasonable to me - though you still need to deal with userspace
not responding I guess.

johannes
