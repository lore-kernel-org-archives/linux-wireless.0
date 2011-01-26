Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57429 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1AZFzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 00:55:00 -0500
Received: by gwj20 with SMTP id 20so8762gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 21:55:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295869126.3639.4.camel@jlt3.sipsolutions.net>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295816579-28925-5-git-send-email-arik@wizery.com> <1295869126.3639.4.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Jan 2011 07:54:44 +0200
Message-ID: <AANLkTimUvSp9WZj-77px4iZ-+p9ST105SGGd31fEs2Zs@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] mac80211: Save probe response data for BSS
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 13:38, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:
>
>> +static int ieee80211_set_probe_resp(struct wiphy *wiphy,
>> +                                 struct net_device *dev, u8 *resp,
>> +                                 size_t resp_len)
>> +{
>> +     struct ieee80211_sub_if_data *sdata;
>> +     struct sk_buff *new, *old;
>> +
>> +     sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +     old = sdata->u.ap.probe_resp;
>> +
>> +     if (!resp || !resp_len)
>> +             return -EINVAL;
>> +
>> +     new = dev_alloc_skb(resp_len);
>> +     if (!new) {
>> +             printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
>> +                    "response template\n", sdata->name);
>> +             return -ENOMEM;
>
> I'd remove that message -- userspace already knows, and it's the only
> thing that really needs to?
>

Sure. I'll fix this in v3 (somehow missed this email before).

Arik
