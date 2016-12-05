Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32888 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbcLEO4v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:56:51 -0500
Received: by mail-oi0-f65.google.com with SMTP id f201so36848985oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 06:55:39 -0800 (PST)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
 <1480945883.31788.3.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <58457FEA.4030305@gmail.com> (sfid-20161205_155714_254546_E53F8D12)
Date: Mon, 5 Dec 2016 08:55:38 -0600
MIME-Version: 1.0
In-Reply-To: <1480945883.31788.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/05/2016 07:51 AM, Johannes Berg wrote:
> On Fri, 2016-12-02 at 21:56 +0100, Andrew Zaborowski wrote:
>> Disconnect or deauthenticate when the owning socket is closed if this
>> flag has been supplied to CMD_CONNECT, CMD_AUTHENTICATE or
>> CMD_ASSOCIATE.
>
> Huh. That I think needs a lot more commit log to justify this code -
> why do you think this would be useful? Connection managers dying don't
> really mean you need to disconnect immediately, after all, and if they
> restart it's pretty simple to detect the existing connection and
> perhaps even use it...
>

Detecting it is easy, sure.  But I'm a bit lost on how you propose to 
'use' it.  The connection is active up until the next rekey event.  If 
rekey offloading is supported, then this might never involve user space. 
  But if it isn't (and I can't get rekey offload to work on any recent 
kernel I tried) then how do you propose userspace obtains the rekey 
counter, or the various keys used in the connection?

What about all the other state information?  FT, Pre-Authentication, etc?

Can you point me to a connection manager that actually performs this 
'reuse' and not just simply wipes the state clean when starting?

Regards,
-Denis
