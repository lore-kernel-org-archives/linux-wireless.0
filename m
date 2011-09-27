Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51401 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1I0VMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 17:12:53 -0400
Received: by eya28 with SMTP id 28so5113695eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 14:12:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317124207.4082.20.camel@jlt3.sipsolutions.net>
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
 <1317034493-5300-4-git-send-email-arik@wizery.com> <1317124207.4082.20.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 28 Sep 2011 00:12:37 +0300
Message-ID: <CA+XVXfd5ZipjgSCaVka9TgLFyc7mi-QSJRcqSpVMxkcir7u_3A@mail.gmail.com> (sfid-20110927_231257_032539_9151CB4E)
Subject: Re: [PATCH 3/5] mac80211: handle TDLS high-level commands and frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 14:50, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-09-26 at 13:54 +0300, Arik Nemtsov wrote:
>
>> +/*
>> + * TDLS capabililites to be enabled in the 5th byte of the
>> + * @WLAN_EID_EXT_CAPABILITY information element
>> + */
>> +#define WLAN_EXT_CAPA_TDLS_ENABLED   BIT(5)
>> +#define WLAN_EXT_CAPA_TDLS_PROHIBITED        BIT(6)
>
> Would it be useful to have the IE declared as a struct somewhere?

It's really just a bit-mask, and a variable length one as it is. But
I'll change the name to make it more palatable. Something like
WLAN_EXT_CAPA5_TDLS_ENABLED :)

>
>
>> +static int
>> +ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
>> +                            u8 *peer, u8 action_code, u8 dialog_token,
>> +                            u16 status_code, struct sk_buff *skb)
>
> All the code addition here makes me wonder if it'd be useful to move it
> into a new tdls.c file and just call the right hooks from cfg.c? the cfg
> file is pretty large already ... tdls wouldn't be huge, but still might
> make sense?

As discussed on IRC, this code is pretty much stateless, and it's not
a lot of code. We agreed we can keep it in cfg.c for now.

Arik
