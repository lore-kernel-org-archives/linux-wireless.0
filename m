Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:12598 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYGPNLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 09:11:25 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1755608rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2008 06:11:25 -0700 (PDT)
Message-ID: <1ba2fa240807160611h5d0d4ae5g68bfa2366cf514ec@mail.gmail.com> (sfid-20080716_151130_134607_C6793A22)
Date: Wed, 16 Jul 2008 16:11:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216111065.3535.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <1216109902.23746.27.camel@johannes.berg>
	 <1ba2fa240807150131w4a08ae6dhae7bab8ab6adbde7@mail.gmail.com>
	 <1216111065.3535.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 11:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-15 at 11:31 +0300, Tomas Winkler wrote:
>> On Tue, Jul 15, 2008 at 11:18 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >
>> >> +     ifsta->direct_probe_tries++;
>> >> +     if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
>> >> +             printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
>> >> +                    dev->name, print_mac(mac, ifsta->bssid));
>> >> +             ifsta->state = IEEE80211_DISABLED;
>> >> +             return;
>> >> +     }
>> >> +
>> >> +     printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
>> >> +                     dev->name, print_mac(mac, ifsta->bssid),
>> >> +                     ifsta->direct_probe_tries);
>> >
>> > I just removed all the log flooding. Don't add it back please.
>>
>> Right, will resubmit.
>
> Actually, it looks like I kept those for association because I decided
> that we weren't printing them too much. It might be much nicer to send
> them all as wireless events though, thoughts?

Something like IWEVASSOCTIMEDOUT. Won't it make wpa_supplicant go nuts?
Thanks
Tomas
