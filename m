Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:61343 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaAOQK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:10:27 -0500
Received: by mail-lb0-f181.google.com with SMTP id z5so972618lbh.12
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 08:10:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389792475.4338.11.camel@jlt4.sipsolutions.net>
References: <1389788210-7246-1-git-send-email-janusz.dziedzic@tieto.com>
	<1389788210-7246-2-git-send-email-janusz.dziedzic@tieto.com>
	<1389792475.4338.11.camel@jlt4.sipsolutions.net>
Date: Wed, 15 Jan 2014 17:10:25 +0100
Message-ID: <CALhHN=q=r-X_tk56NFZSrhscvnFRhMzbUh41pEHThq4gKf7bYw@mail.gmail.com> (sfid-20140115_171035_094042_9243F250)
Subject: Re: [RFC 2/2] cfg80211: DFS get CAC time from regulatory
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 January 2014 14:27, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-15 at 13:16 +0100, Janusz Dziedzic wrote:
>
>> @@ -3211,6 +3212,7 @@ struct wireless_dev {
>>
>>       bool cac_started;
>>       unsigned long cac_start_time;
>> +     unsigned int cac_time_ms;
>
> Why would that need to be stored here? Isn't it just a pretty much local
> parameter of the radar detection startup?
>
Because of this WARN_ON

@@ -778,7 +778,7 @@ void cfg80211_cac_event(struct net_device *netdev,
        switch (event) {
        case NL80211_RADAR_CAC_FINISHED:
                timeout = wdev->cac_start_time +
-                         msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
+                         msecs_to_jiffies(wdev->cac_time_ms);
                WARN_ON(!time_after_eq(jiffies, timeout));

We have to know this if we need this warning.

BR
Janusz
