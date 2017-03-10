Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:35786 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932925AbdCJJL7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 04:11:59 -0500
Received: by mail-ua0-f173.google.com with SMTP id q7so91762130uaf.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 01:11:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1489136175.3038.2.camel@sipsolutions.net>
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
 <1489136175.3038.2.camel@sipsolutions.net>
From: Rostyslav Khudolii <rkhudolii@airtame.com>
Date: Fri, 10 Mar 2017 10:11:52 +0100
Message-ID: <CAPXt_daQxHAsPfeRjP0CZfq_Uu4EXHvjsko-EUb0mKmDaef_SQ@mail.gmail.com> (sfid-20170310_101253_931867_21C2EA9A)
Subject: Re: [PATCH] ath6kl: Remove old 802.11a-only channels
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kvalo@qca.qualcomm.com, ath6kl@lists.infradead.org,
        linux-wireless@vger.kernel.org, Attila Sukosd <attila@airtame.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2017 at 09:56, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2017-03-10 at 09:49 +0100, Rostyslav Khudolii wrote:
>> Channels 34/38/42/46 can only be used for compatibility with
>> old devices sold in Japan. Modern products, such as AR6003/AR6004
>> don't support these channels.
>> Keeping them in the upstream is error prone and requires full
>> network stack support.
>
> Seems pointless. Nothing in the network stack really cares much about
> the channel numbers, so what exactly does this improve?
>

Without this one, a user is able to start an AP using wpa_supplicant,
for example, on one of these channels (34/38/42/46), without getting
any warning/error from the cfg80211 or ath6kl - which is correct
(since these channels match regdom rules). However, the AR6003 and its
firmware (we're using v3.4.0.225) will fail and return
"WMI_CMDERROR_EVENTID" with "INVALID_PARAM" error code.
In my opinion, ath6kl shouldn't support anything the firmware doesn't.
We should also handle WMI_CMDERROR_EVENTID properly (not just printing
a message), but this is another problem, I believe.
