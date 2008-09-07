Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:48033 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbYIGAVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 20:21:43 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1046242fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 17:21:41 -0700 (PDT)
Message-ID: <1ba2fa240809061721k2082d038j63c272f5b29a66c6@mail.gmail.com> (sfid-20080907_022146_775575_95FC37A5)
Date: Sun, 7 Sep 2008 03:21:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2 V2] mac80211: add direct probe before association
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1220744663.21016.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1218240139-5009-1-git-send-email-tomas.winkler@intel.com>
	 <1220744663.21016.28.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 2:44 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> I was just pondering rewriting parts of the state machine (and you've
> already seen the other cleanups I did today) and found this:
>
>> +     /* Direct probe is sent to broadcast address as some APs
>> +      * will not answer to direct packet in unassociated state.
>> +      */
>> +     ieee80211_send_probe_req(dev, NULL,
>> +                              ifsta->ssid, ifsta->ssid_len);
>
>> +     /* direct probe may be part of the association flow */
>> +     if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
>> +                                                     &ifsta->request)) {
>> +             printk(KERN_DEBUG "%s direct probe responded\n", dev->name);
>> +             ieee80211_authenticate(dev, ifsta);
>
> Doesn't the latter code have to check that the sender is the correct
> one? First we broadcast the probe request, and then we may be getting
> one from a different AP but still clear our direct probe association
> flow step, no?

Yep, this is not covered. Don't remember why it wasn't straight
forward to implement...will look at it again after sunrise.

Thanks
Tomas
