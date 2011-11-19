Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64806 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1KSIwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 03:52:35 -0500
Received: by bke11 with SMTP id 11so4361670bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 00:52:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321632729.10266.68.camel@jlt3.sipsolutions.net>
References: <1320917337-30561-1-git-send-email-arik@wizery.com>
 <1320917337-30561-3-git-send-email-arik@wizery.com> <1321632729.10266.68.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sat, 19 Nov 2011 10:52:18 +0200
Message-ID: <CA+XVXfe-NgwN3XuQoJ-BNHmKSdFaoDqQpr0NyrJF4rL0e5vhpQ@mail.gmail.com> (sfid-20111119_095241_786692_95FB05FD)
Subject: Re: [PATCH v5 3/3] mac80211: Save probe response data for bss
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 18:12, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-11-10 at 11:28 +0200, Arik Nemtsov wrote:
>> Allow setting a probe response template for an interface operating in
>> AP mode. Low level drivers are notified about changes in the probe
>> response template and are able to retrieve a copy of the current probe
>> response. This data can, for example, be uploaded to hardware as a
>> template.
>
>> +static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
>> +                                 u8 *resp, size_t resp_len)
>> +{
>> +     struct sk_buff *new, *old;
>> +
>> +     if (!resp || !resp_len)
>> +             return -EINVAL;
>> +
>> +     old = sdata->u.ap.probe_resp;
>
> sparse warns here with RCU checking enabled in the kernel:
>
> cfg.c:502:13: warning: incorrect type in assignment (different address spaces)
> cfg.c:502:13:    expected struct sk_buff *old
> cfg.c:502:13:    got struct sk_buff [noderef] <asn:4>*probe_resp
>
>
> Please take a look, ieee80211_set_beacon() uses rtnl_dereference() to
> avoid the sparse warning and annotate that the RTNL is used to protect
> the pointer.
>

Thanks. That's indeed a handy .config option.

Arik
