Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:34216 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbYGOIb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 04:31:28 -0400
Received: by py-out-1112.google.com with SMTP id p76so3001557pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 01:31:27 -0700 (PDT)
Message-ID: <1ba2fa240807150131w4a08ae6dhae7bab8ab6adbde7@mail.gmail.com> (sfid-20080715_103142_039579_76995425)
Date: Tue, 15 Jul 2008 11:31:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216109902.23746.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <1216109902.23746.27.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 11:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +     ifsta->direct_probe_tries++;
>> +     if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
>> +             printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
>> +                    dev->name, print_mac(mac, ifsta->bssid));
>> +             ifsta->state = IEEE80211_DISABLED;
>> +             return;
>> +     }
>> +
>> +     printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
>> +                     dev->name, print_mac(mac, ifsta->bssid),
>> +                     ifsta->direct_probe_tries);
>
> I just removed all the log flooding. Don't add it back please.

Right, will resubmit.
