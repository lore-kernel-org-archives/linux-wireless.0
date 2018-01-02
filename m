Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49924 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbeABN1M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 08:27:12 -0500
Message-ID: <1514899630.2024.2.camel@sipsolutions.net> (sfid-20180102_142716_604722_5389FD45)
Subject: Re: [RFC 0/4] EAPoL over NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 02 Jan 2018 14:27:10 +0100
In-Reply-To: <186d4469-fffb-45b2-1ea7-53a4eaf1c966@gmail.com> (sfid-20171229_192937_701953_D7DF1E5F)
References: <20171228175832.3253-1-denkenz@gmail.com>
         <5A460B01.7060603@broadcom.com>
         <186d4469-fffb-45b2-1ea7-53a4eaf1c966@gmail.com>
         (sfid-20171229_192937_701953_D7DF1E5F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-29 at 12:29 -0600, Denis Kenzior wrote:

> Agreed, requiring both attributes is less than ideal, but I tried to 
> make the initial RFC as minimal as possible.  It also helped that iwd 
> uses SOCKET_OWNER by default.  What can be done is to always set 
> conn_owner_nlportid and introduce another flag that would indicate 
> whether 'connection tear-down on application exit' was requested.
> 
> However, my opinion is that the current SOCKET_OWNER behavior should 
> just be made default, especially for control port over nl80211 
> connections, even if SOCKET_OWNER was not requested.  Once the 
> controlling application dies, there's no hope of salvaging the 
> connection, perform rekeys, etc.

I think we should keep both attributes; it's better to be explicit that
both are needed than to set socket-owner automatically.

> The biggest issue was that each driver defines a set of management 
> frames it can accept via this mechanism.

I'm not sure this is "the biggest issue", but I tend to agree with
keeping them separate.

johannes
